int fps = 2000;

// timing
double currentTime;
double deltaTime;
double expectedFrameTime;
double deltaTimeFactor; 

// ball variables
float ballXPos = width/2;
float ballYPos = height/2;
float ballWidth = 20;
float ballXSpeed = 200; // 2 px per second
float ballYSpeed = 80; // TODO
float ballSpeed = 600;
float ballAngel = PI/3;


// pad variables
float padXPos = 50;
float padYPos = mouseY;
float padWidth = 10;
float padHeight = 100;

// right pad
float rpadYPos;
float padToBallSpeed = 270;


void setup() {
  size(800, 400); 
  frameRate(fps);
  // time in ms
  currentTime = System.nanoTime()/1000000;
  expectedFrameTime = 1.0/fps;
  rpadYPos = height/2;
}



void draw() {
  // deltaTime
  deltaTime = System.nanoTime()/1000000000.0 - currentTime;
  currentTime = System.nanoTime() / 1000000000.0;
  deltaTimeFactor = deltaTime / expectedFrameTime;

  // if frametime is under half or double of expected frame time, we will pretend it's normal value
  // happends in inizialization of the loop
  if (deltaTimeFactor > 2 || deltaTimeFactor < 0.5)
  {
    deltaTimeFactor = 1;
  }

  // IO
  padYPos = mouseY;

  // ballspeed and ballangel to ballXSpeed and ballYSpeed
  ballXSpeed = ballSpeed * cos(ballAngel);
  ballYSpeed = ballSpeed * sin(ballAngel);

  // move ball
  ballXPos += (ballXSpeed/fps * deltaTimeFactor);
  ballYPos += (ballYSpeed/fps * deltaTimeFactor);

  // move right pad
  int upOrDownDirection = 0;
  upOrDownDirection = (ballYPos > rpadYPos) ? 1 : -1;
  rpadYPos += (upOrDownDirection * padToBallSpeed/fps  * deltaTimeFactor);

  // COLLISION

  // if ball hit right wall
  if (ballXPos > width-ballWidth/2) {
    ballAngel = ballAngel + PI - 2*ballAngel;
  }

  // if ball hit left wall
  if (ballXPos < ballWidth/2) {
    ballAngel = ballAngel + PI - 2*ballAngel;
  }

  // if ball hit top wall  
  if (ballYPos < ballWidth/2) {
    //ballYSpeed = abs(ballYSpeed);
    // mirror the x axis of the unit circle
    ballAngel = ballAngel - 2*(ballAngel-PI);
  }

  // if ball hit bottom wall
  if (ballYPos > height - ballWidth/2) {
    //ballYSpeed = -abs(ballYSpeed);
    // mirror the x axis of the unit circle
    ballAngel = ballAngel - 2*(ballAngel-PI);
  }

  // collison with left pad
  if (ballXPos - ballWidth/2 < padXPos + padWidth/2 && 
    ballYPos < padYPos + padHeight/2 + ballWidth/2 &&
    ballYPos > padYPos - padHeight/2 - ballWidth/2 &&
    ballXPos > padXPos) {
    //ballXSpeed = abs(ballXSpeed);
    //ballAngel = ballAngel + PI - 2*ballAngel;
    ballAngel = map(padYPos - ballYPos, 
      -padHeight/2 - ballWidth/2, 
      padHeight/2 + ballWidth/2, 
      PI*1/3, -PI*1/3);
  }

  // collison with right pad
  if (ballXPos + ballWidth/2 > width - padXPos - padWidth/2 && 
    ballYPos < rpadYPos + padHeight/2 &&
    ballYPos > rpadYPos - padHeight/2 &&
    width - padXPos > ballXPos) {
    //ballXSpeed = -abs(ballXSpeed);
    //ballAngel = ballAngel + PI - 2*ballAngel;
    ballAngel = map(rpadYPos - ballYPos, 
      -padHeight/2 - ballWidth/2, 
      padHeight/2 + ballWidth/2, 
      PI - PI*1/3, PI + PI*1/3);
  }

  // draw
  background(0);
  fill(255);
  rectMode(CENTER);
  rect(padXPos, mouseY, padWidth, padHeight);
  ellipse(ballXPos, ballYPos, ballWidth, ballWidth);
  rect(width - padXPos, rpadYPos, padWidth, padHeight);
}
