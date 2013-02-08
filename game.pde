// Global variables
final int canvas_width = 768;
final int canvas_height = 1024;
final int quarter_width = (canvas_width / 4);
float moveL = 0;
float moveR = 0;
int gameState = 0;

/*supported resolutions
480x320
960x640
1024x768
2048x1536
*/

/*
0 - start screen
1 - play
2 - win
3 - death
*/

Paddle paddle;
BrickManager bm;

// Setup the Processing Canvas
void setup(){
	size( canvas_width, canvas_height );

	strokeWeight( 2 );
	frameRate( 30 );

	// Set stroke-color black
	stroke(000);

	// Set rect() to draw centered on x,y
	rectMode(CENTER);
}

// Main draw loop
void draw(){
	// Fill canvas grey
	background( 100 );
/*
	textSize(75);
	fill( 255, 255, 255 );
	textAlign(CENTER);
	text("GAME OVER", (canvas_width/2), canvas_height/2-85);
*/
	switch (gameState){
		case 0:
			gameState = 1;
			paddle = new Paddle();
			bm = new BrickManager();

			bm.loadLevel();

			paddle.addTestBall();

			drawStart();
			break;
		case 1:
			drawPlay();
			break;
		case 2:
			drawPlay();
			drawGameOver();
			break;
		case 3:
			break;
	}
}

void addBrick(x, y, type) {
	bm.bricks.add(new Brick(x, y, type));
	
	if((y+30) > bm.maxY)
		bm.maxY = (y + 30);
}

void drawPlay () {
	paddle.draw();
	bm.draw();
}

void drawStart() {
	paddle.draw();
	bm.draw();
}

void drawGameOver() {
	// dead

	textSize(75);
	fill( 255, 255, 255 );
	textAlign(CENTER);
	text("GAME OVER", (canvas_width/2), canvas_height/2-85);

	textSize(25);
	fill( 255, 255, 255 );
	//text("Press SPACE to try again", (canvas_width/2), canvas_height/2+85);
}

void keyPressed() {
	if(keyCode == LEFT) {
		moveL = 1.0;
	}
	if(keyCode == RIGHT) {
		moveR = 1.0;
	}
}

void keyReleased() {
	if(keyCode == LEFT) {
		moveL = 0.0;
	}
	if(keyCode == RIGHT) {
		moveR = 0.0;
	}
}

void mousePressed() {
	switch(mouseButton){
		case 37: // Left Mouse

			if(mouseX < quarter_width) {
				moveL = 1.0;
			} else if (mouseX > (quarter_width * 3)) {
				moveR = 1.0;
			}

			break;
	}
}

void mouseReleased() {
	switch(mouseButton){
		case 37: // Left Mouse
			moveL = 0.0;
			moveR = 0.0;
			break;
	}
}

class Brick
{
	float x, y;
	float minX, minY, maxX, maxY;
	int type;
	int hit;

	Brick(float start_x, float start_y, int start_type) {
		x = start_x;
		y = start_y;
		type = start_type;
		
		minX = x - 12;
		maxX = x + 12;
		
		minY = y - 12;
		maxY = y + 12;
		
		hit = 0;
	}

	void draw() {
		switch (type) {
			case 0:
				fill(255, 0, 0);
				break;
			case 1:
				fill(0, 255, 0);
				break;
			case 2:
				fill(0, 0, 255);
				break;
		}

		pushMatrix();
		translate(x, y);
		rect( 0, 0, 24, 24 );
		popMatrix();
	}
}

class BrickManager
{
	ArrayList bricks;
	int maxY;

	BrickManager() {
		bricks = new ArrayList();

		maxY = 0;
	}

	void draw() {
	
		stroke(000);
	
		for (int i = bricks.size()-1; i >= 0; i--) {
			Brick b = (Brick) bricks.get(i);

			if(!b.hit)
				b.draw();
		}
	}

	void loadLevel() {
	
		loadJSONLevel('1gam.json');
/*
		for(int i = 0; i<=30; i++) {
			bricks.add(new Brick(20 + (24 * i), 20, 0));
		}

		for(int i = 0; i<=30; i++) {
			bricks.add(new Brick(20 + (24 * i), 50, 1));
		}

		for(int i = 0; i<=30; i++) {
			bricks.add(new Brick(20 + (24 * i), 80, 2));
		}
	
		for(int i = 0; i<=30; i++) {
			bricks.add(new Brick(20 + (24 * i), 110, 0));
		}

		for(int i = 0; i<=30; i++) {
			bricks.add(new Brick(20 + (24 * i), 140, 1));
		}

		for(int i = 0; i<=30; i++) {
			bricks.add(new Brick(20 + (24 * i), 170, 2));
		}
		
		for(int i = 0; i<=30; i++) {
			bricks.add(new Brick(20 + (24 * i), 200, 0));
		}

		for(int i = 0; i<=30; i++) {
			bricks.add(new Brick(20 + (24 * i), 230, 1));
		}

		for(int i = 0; i<=30; i++) {
			bricks.add(new Brick(20 + (24 * i), 260, 2));
		}

		for(int i = 0; i<=30; i++) {
			bricks.add(new Brick(20 + (24 * i), 290, 0));
		}

		for(int i = 0; i<=30; i++) {
			bricks.add(new Brick(20 + (24 * i), 320, 1));
		}

		for(int i = 0; i<=30; i++) {
			bricks.add(new Brick(20 + (24 * i), 350, 2));
		}

		maxY = 350 + 20;
*/		
	}
}

class Ball
{
	float x, y, dx, dy, speed;
	float last_x, last_y;
	boolean once = false;

	Ball(float start_x, float start_y, float start_angle) {
		last_x = x = start_x;
		last_y = y = start_y;
		dx = cos(start_angle);
		dy = sin(start_angle);

		speed = 10.0;
	}

	void draw() {
		boolean collided = true;
		last_x = x;
		last_y = y;
		
		x += dx * speed;
		y += dy * speed;
		
		while(collided) {
			collided = false;
			
			if(x < 0) { // reflect off left wall
				x = x * -1.0;
				dx = dx * -1.0 + (0.001);
				collided = true;
			}
			else if(x > canvas_width) { // right wall
				x = (canvas_width * 2) - x;
				dx = dx * -1.0;
				collided = true;
			}

			if(y < 0) { // top
				y = y * -1.0;
				dy = dy * -1.0 + (0.001);
				collided = true;
			}
			else if(y > canvas_height) { // bottom for testing
				y = (canvas_height * 2) - y;
				dy = dy * -1.0;
				collided = true;
			}

			if(y < bm.maxY) {
				// test against boxes
				for (int i = bm.bricks.size()-1; i >= 0; i--) {
					Brick b = (Brick) bm.bricks.get(i);

					if(!b.hit) {
						if((x > b.minX) && (x < b.maxX) && (y > b.minY) && (y < b.maxY)) {
							b.hit = 1;
							collided = true;
							x1 = last_x - x;
							y1 = last_y - y;
							i = -1;  // stop testing

							float edge_x;
							float edge_y;
							float tx, ty;

							// Let x = x1 + dx * t and calculate t at the intersection point with a vertical border.
							if (x1 != 0) {
								if(x1 > 0) {
									edge_x = b.maxX;
								} else {
									edge_x = b.minX;
								}
								
								tx = (edge_x - x) / x1;
							}

							// Let y = y1 + dy * t and calculate t for the vertical border.
							if (y1 != 0) {
								if(y1 > 0) {
									edge_y = b.maxY;
								} else {
									edge_y = b.minY;
								}
								
								ty = (edge_y - y) / y1;
							}
	/*						
							if (dx == 0) 
								t = ty;
							else if (dy == 0) 
								t = tx;
							else 
								t = min(tx, ty);
								
							// Calculate the coordinates of the intersection point.
							float ix = x + dx * t;
							float iy = y + dy * t;						
	*/							
							// calculate reflected x,y
							
							
							//
							if(tx < ty) {
								dx = dx * -1.0;
								x = (2.0 * edge_x) - x;
							} else {
								dy = dy * -1.0;
								y = (2.0 * edge_y) - y;
							}
							
						}
					}
				}			
			}
		}
		// test on paddle top
		if((dy > 0) && y > (paddle.y + paddle.minY) && y > (paddle.y + paddle.maxY)) {
			if((x > paddle.x + paddle.minX) && (x < paddle.x + paddle.maxX)) {
				// hit
				y = ((paddle.y + paddle.minY) * 2) - y;
				float hitX = paddle.x - x;
				dy = dy * -1.0;

				//console.log('hitX = ' + hitX);
				// adjust based on location hit
			}
		}

		float angle = atan2(dy, dx);
		pushMatrix();

		translate(x, y);
		// Set stroke-color black
		stroke(000);
		
		//line(last_x - x, last_y - y, 0, 0);
		rotate(angle);

		// Draw ball
		fill( 255, 255, 255 );
		ellipse( 0, 0, 15, 10 );
		
		popMatrix();
	}
}

class Paddle
{
	float x, y, radius = 25;
	float minX, minY, maxX, maxY;
	int paddle_half_width;
	ArrayList balls;

	Paddle() {
		balls = new ArrayList();

		x = canvas_width / 2;
		y = canvas_height - 40;

		paddle_half_width = 75;

		minX = -paddle_half_width;
		minY = -10;
		maxX = paddle_half_width;
		maxY = -10;
	}

	void addTestBall() {
		int numBalls = 24;
		
		for(int i=0;i<numBalls;i++) {
			balls.add(new Ball(canvas_width/2, canvas_height/2, ((3.1415 * 2 / numBalls) * i) + (3.1415 / 4.0)));
		}
/*		
		balls.add(new Ball(canvas_width/2, canvas_height/2, 45));
		balls.add(new Ball(canvas_width/2, canvas_height/2, 75));
		balls.add(new Ball(canvas_width/2, canvas_height/2, 105));
		balls.add(new Ball(canvas_width/2, canvas_height/2, 135));
		balls.add(new Ball(canvas_width/2, canvas_height/2, 165));
		balls.add(new Ball(canvas_width/2, canvas_height/2, 195));
		balls.add(new Ball(canvas_width/2, canvas_height/2, 225));
		balls.add(new Ball(canvas_width/2, canvas_height/2, 255));
*/		
	}

	void draw() {

		for (int i = balls.size()-1; i >= 0; i--) {
			Ball b = (Ball) balls.get(i);

			b.draw();
		}

		x = x - (moveL * 15.0) + (moveR * 15.0);

		if (x < paddle_half_width)
			x = paddle_half_width;
		if (x > canvas_width - paddle_half_width)
			x = canvas_width - paddle_half_width;

		pushMatrix();
		translate(x, y);

		// Set stroke-color black
		//stroke(000);
		noStroke();
		// Draw Paddle

		fill( 0, 0, 0 );
		rect( 0, 0, paddle_half_width + 4, 14 );
		ellipse( paddle_half_width / 2, 0, 14, 14 );
		ellipse( -paddle_half_width / 2, 0, 14, 14 );

		fill( 0, 121, 184 );
		rect( 0, 0, paddle_half_width, 10 );
		ellipse( paddle_half_width / 2, 0, 10, 10 );
		ellipse( -paddle_half_width / 2, 0, 10, 10 );
		popMatrix();
	}
}
