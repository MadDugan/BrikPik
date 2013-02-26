/*
paddle bounce \_\__|__/_/
wall bounce animation
lives
expand boxes based on # of same color
*/

// Global variables
final int canvas_width = 1024;
final int canvas_height = 768;
final int quarter_width = (canvas_width / 4);
float moveL = 0;
float moveR = 0;
int gameState = 0;
int currentLevel = 0;
final int maxLevel = 4;

/*supported resolutions
480x320
960x640
1024x768
2048x1536
*/

/*
0 - start screen
1 - setup
2 - no ball play
3 - play
4 - win
5 - death
*/

Paddle paddle;
ObjectManager om;

// Setup the Processing Canvas
void setup(){
	size( canvas_width, canvas_height );

	strokeWeight( 1 );
	frameRate( 30 );

	// Set stroke-color black
	stroke(000);

	// Set rect() to draw centered on x,y
	//rectMode(CENTER);
	om = new ObjectManager();
	om.loadLevel('title.json');
}

// Main draw loop
void draw(){
	// Fill canvas grey
	background( 100 );
	float m = millis();

	switch (gameState){
		case 0: // title
			drawStart();
			break;
		case 1: // level load
			drawSetup();
			break;
		case 2:
			drawPlay();

			textAlign(CENTER);
			textSize(25);
			fill( 255, 255, 255 );
			text("Press anywhere to launch ball", (canvas_width/2), canvas_height/2);
			break;
		case 3: // game
			drawPlay();
			break;
		case 4: // win
			//drawPlay();
			drawLevelWin();
			break;
		case 5: // lose
			//drawPlay();
			drawGameOver();
			break;
	}
}

void drawPlay () {
	om.draw();
	paddle.draw();
}

void drawStart() {
	om.draw();

	textAlign(CENTER);
	textSize(25);
	fill( 255, 255, 255 );
	text("Press anywhere to start", (canvas_width/2), canvas_height/2+85);
}

void drawSetup() {
	paddle = new Paddle();
	om = new ObjectManager();

	currentLevel = currentLevel % maxLevel;

	lvlName = "lvl";

	if(currentLevel < 100)
		lvlName = lvlName + 0;
	if(currentLevel < 10)
		lvlName = lvlName + 0;

	lvlName = lvlName + currentLevel + ".json";

	om.loadLevel(lvlName);

	om.draw();

	gameState = 2;
}

void drawLevelWin() {
	textSize(75);
	fill( 255, 255, 255 );
	textAlign(CENTER);
	text("LEVEL CLEARED", (canvas_width/2), canvas_height/2-85);

	textSize(25);
	fill( 255, 255, 255 );
	text("Press anywhere to play next level", (canvas_width/2), canvas_height/2+85);
}

void drawGameOver() {
	// dead

	textSize(75);
	fill( 255, 255, 255 );
	textAlign(CENTER);
	text("GAME OVER", (canvas_width/2), canvas_height/2-85);

	textSize(25);
	fill( 255, 255, 255 );
	text("Press anywhere to try again", (canvas_width/2), canvas_height/2+85);
}

void keyPressed() {
	if(keyCode == LEFT) {
		moveL = 1.0;
	}
	if(keyCode == RIGHT) {
		moveR = 1.0;
	}

	switch(gameState) {
		case 0:
			gameState = 1;
			break;
		case 1:
			gameState = 2;
			break;		
		case 2:
			paddle.launchBall();
			paddle.x = canvas_width / 2;
			paddle.y = canvas_height - 40;	
			gameState = 3;	
			break;
		case 4:
			gameState = 1;
			currentLevel++;		
			break;
		case 5:
			gameState = 1;
			break;
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
			switch(gameState) {
				case 0:
					gameState = 1;
					break;
				case 1:
					gameState = 2;
					break;
				case 2:
					//paddle.addTestBall();
					paddle.launchBall();
					paddle.x = canvas_width / 2;
					paddle.y = canvas_height - 40;
					gameState = 3;
					break;
				case 3:
					if(mouseX < quarter_width) {
						moveL = 1.0;
					} else if (mouseX > (quarter_width * 3)) {
						moveR = 1.0;
					}
					break;
				case 4:
					gameState = 1;
					currentLevel++;
					break;
				case 5:
					gameState = 1;
					break;
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

class Powerup
{
	float x, y;
	float minX, minY, maxX, maxY;
	int type;

	Powerup(float init_x, float init_y, int init_type) {
		x = init_x;
		y = init_y;
		type = init_type;

		minX = x - 12;
		maxX = x + 12;

		minY = y - 12;
		maxY = y + 12;

		switch (type) {
			case 0:
				break;
			case 1:
				break;
			case 2:
				break;
		}
	}

	void draw() {
		pushMatrix();
		translate(x, y);

		popMatrix();
	}
}

class Brick
{
	float x, y;
	float minX, minY, maxX, maxY;
	int len;
	int type;
	int hit;
	color c;
	color c1;
	color c2;
	int width = 48;
	int height = 48;
	int depth = 24;

	Brick(float init_x, float init_y, int init_length, int init_type) {
		x = init_x;
		y = init_y;
		len = init_length;
		type = init_type;
		
		depth = 12;

		width = width * len;

		minX = x - 24;
		maxX = x + (width - 24);

		minY = y - (height / 2);
		maxY = y + (height / 2);

		hit = 0;

		switch (type) {
			case 1:
				c = #FF0000;//lerpColor(#FF0000, 0, .50);
				//c1 = #FF0000;
				//c2 = lerpColor(#FF0000, #FFFFFF, .50);

				break;
			case 2:
				c = #00FF00;
				//c1 = #00FF00;
				//c2 = #7FFF7F;
				break;
			case 3:
				c = #0000FF;
				//c1 = #0000FF;
				//c2 = #7F7FFF;
				break;
		}

		c1 = lerpColor(c, 0, .50);
		c2 = lerpColor(c, #FFFFFF, .50);

	}

	void setHit() {
		hit = 8;
	}

	void draw() {
		pushMatrix();
		translate(x - 24, y - 24);
		fill(c);

		if(hit > 1) {
			hit = hit - 1;
			scale(hit / 8.0);
			alpha( 255 * (hit / 8.0));
		}

		rect( 0, 0, width, height );
		fill(c1);
		quad(0, 0, 0, height, -depth, (height - depth), -depth, -depth);
		fill(c2);
		quad(0, 0, width, 0, (width - depth), -depth, -depth, -depth);
		stroke(255, 255 ,255);
		line(width - 1, 1, width - 1, height - 1);
		line(1, 1, width - 1, 1);
		stroke(0);
		line(width - 1, 0, width - 1, height - 1);
		line(0, height - 1, width, height - 1);
		popMatrix();
	}
}

void addBrick(x, y, length, type) {

	if(type == 0)
		return;

	om.bricks.add(new Brick(x, y, length, type));
	om.numBricks++;

	if((y+48) > om.maxY)
		om.maxY = (y + 48);
}

class ObjectManager
{
	ArrayList bricks;
	int maxY;
	int numBricks;

	ObjectManager() {
		bricks = new ArrayList();
		numBricks = 0;
		maxY = 0;
	}

	void draw() {

		stroke(#000000);

		for (int i = bricks.size()-1; i >= 0; i--) {
			Brick b = (Brick) bricks.get(i);

			if(b.hit != 1)
				b.draw();
		}
	}

	void setHit(Brick b) {
		numBricks--;
		b.setHit();

		if(numBricks <= 0) {
			gameState = 4;
		}
	}

	void loadLevel(name) {

		bricks = new ArrayList();
		numBricks = 0;
		loadJSONLevel(name);
/*
		for(int i = 0; i<=30; i++) {
			bricks.add(new Brick(20 + (24 * i), 20, 0));
		}

		maxY = 350 + 20;
*/
	}
}

class Ball
{
	float x, y, dx, dy, speed;
	float last_x, last_y;
	float scale_anim;
	boolean active = true;

	Ball(float init_x, float init_y, float init_angle) {
		init(init_x, init_y, init_angle);

		speed = 16.0;
		scale_anim = 1.0;
	}
	
	void init(float init_x, float init_y, float init_angle) {
		last_x = x = init_x;
		last_y = y = init_y;
		dx = cos(init_angle);
		dy = sin(init_angle);
		
		scale_anim = 1.0;
		active = true;
	}

	void draw() {
		boolean collided = true;
		last_x = x;
		last_y = y;
		
		if(!active) {

			return;
		}

		x += dx * speed;
		y += dy * speed;

		while(collided) {
			collided = false;

			if(x < 0) { // reflect off left wall
				x = x * -1.0;
				dx = dx * -1.0 + (0.001);
				collided = true;
				scale_anim = 2.0;
			}
			else if(x > canvas_width) { // right wall
				x = (canvas_width * 2) - x;
				dx = dx * -1.0;
				collided = true;
				scale_anim = 2.0;
			}

			if(y < 0) { // top
				y = y * -1.0;
				dy = dy * -1.0 + (0.001);
				collided = true;
				scale_anim = 2.0;
			}
			else if(y > canvas_height) { // bottom 
/*
				// for testing
				y = (canvas_height * 2) - y;
				dy = dy * -1.0;
				collided = true;
				scale_anim = 2.0;
*/				
				active = false;
				gameState = 2;
				return;
			}

			if(y < om.maxY) {
				// test against boxes
				for (int i = om.bricks.size()-1; i >= 0; i--) {
					Brick b = (Brick) om.bricks.get(i);

					if(!b.hit) {
						if((x > b.minX) && (x < b.maxX) && (y > b.minY) && (y < b.maxY)) {
							om.setHit(b);
							scale_anim = 2.0;

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
		if((dy > 0) && y > (paddle.y + paddle.minY) && y < (paddle.y + paddle.maxY)) {
			if((x > paddle.x + paddle.minX) && (x < paddle.x + paddle.maxX)) {
				// hit
				y = ((paddle.y + paddle.minY) * 2) - y;
				float hitX = (paddle.x - x) / paddle.paddle_half_width;

				dy = dy * -1.0;

				float angle = atan2(dy, dx);

				angle = angle - (hitX * 0.5);
				
				dx = cos(angle);
				dy = sin(angle);
				//console.log('hitX = ' + hitX);
				// adjust based on location hit
				paddle.hit = 10;
			}
		}

		float angle = atan2(dy, dx);

		pushMatrix();
		translate(last_x, last_y);
		rotate(angle);

		noStroke();
		fill( 128 , 128, 128, 128);
		ellipse( 0, 0, 24, 10 );
		popMatrix();

		pushMatrix();
		translate(x, y);
		rotate(angle);
		scale(1.0);

		// Set stroke-color black
		stroke(0);
		// Draw ball
		fill( 255, 255, 255 );
		ellipse( 0, 0, 13, 10 );

		popMatrix();

		if(scale_anim > 1.0)
			scale_anim = scale_anim - 0.2;
	}
}

class Paddle
{
	float x, y, radius = 25;
	float minX, minY, maxX, maxY;
	int paddle_half_width;
	ArrayList balls;
	int hit = 0;

	Paddle() {
		balls = new ArrayList();

		x = canvas_width / 2;
		y = canvas_height - 40;

		paddle_half_width = 75;

		minX = -paddle_half_width;
		minY = -10;
		maxX = paddle_half_width;
		maxY = 10;
	}

	void addTestBall() {
		int numBalls = 24;

		for(int i=0;i<numBalls;i++) {
			balls.add(new Ball(canvas_width/2, 3 * canvas_height/4, ((3.1415 * 2 / numBalls) * i)));
		}
	}

	void launchBall() {

		// pick angle between
		float pi = 3.141592;
		float half_pi = 3.141592 / 2.0;
		float quarter_pi = 3.141592 / 4.0;
		// 0 -->
		// pi <--
		// half_pi \/

		float angle = random(0.0, quarter_pi);
		angle = angle + pi + quarter_pi;
		
		boolean ball_found = false;
		for (int i = balls.size()-1; i >= 0; i--) {
			Ball b = (Ball) balls.get(i);
			
			if(!b.active) {
				b.init(canvas_width/2, 4 * canvas_height/5, angle);
				ball_found = true;
			}
		}
		
		if(!ball_found)
			balls.add(new Ball(canvas_width/2, 4 * canvas_height/5, angle));
	}

	void draw() {

		x = x - (moveL * 25.0) + (moveR * 25.0);

		if (x < paddle_half_width)
			x = paddle_half_width;
		if (x > canvas_width - paddle_half_width)
			x = canvas_width - paddle_half_width;

		pushMatrix();
		translate(x, y);

		// Set stroke-color black
		stroke(000);

		// Draw Paddle
		fill( 0, 255, 0 );
		rect( minX, minY, paddle_half_width * 2, 20);
		
		fill( 196, 255, 196 );
		quad(minX, minY, minX - 4, minY - 4, maxX - 4, minY - 4, maxX, minY);
		fill( 0, 196, 0 );
		quad(minX, minY, minX, maxY, minX - 4, maxY - 4, minX - 4, minY - 4);
	
		popMatrix();
		
		for (int i = balls.size()-1; i >= 0; i--) {
			Ball b = (Ball) balls.get(i);

			b.draw();
		}		
	}
}
