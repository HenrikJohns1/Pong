
//==========================================================================================
// variables
//==========================================================================================
int fps = 120;
// timing
long currentTime;
long deltaTime;
long expectedFrameTime;
float deltaTimeFactor;

// ball variables
float ballXPos = width/2;
float ballYPos = height/2;
float ballWidth = 20;
double ballXSpeed = 0; //px per sec
double ballYSpeed = 0; 
float ballSpeed = 500;
float ballAngel = PI/3;


// pad variables
float padXPos = 50;
float padYPos = mouseY;
float padWidth = 10;
float padHeight = 100;
float padSpeed = 270;

// right pad
float rpadYPos;
float padToBallSpeed = padSpeed;

// score
int leftScore = 0;
int rightScore = 0;

// collision boolean checkers
boolean leftSide = false;
boolean rightSide = true;
boolean topSide = true;
boolean bottomSide = true;

//==========================================================================================
// Setup method
//==========================================================================================
void setup() {
  size(800, 400); 
  frameRate(fps);
  // time in ms
  currentTime = millis();
  expectedFrameTime = 1000/fps;
  rpadYPos = height/2;
}


//==========================================================================================
// game loop
//==========================================================================================
void draw() {
  // deltaTime
  deltaTime = millis() - currentTime;
  currentTime = millis();
  deltaTimeFactor = (float)deltaTime / expectedFrameTime;

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
  if (ballXPos > width-ballWidth/2 && rightSide) {
    leftScore++;
    ballXPos = width/2;
    ballYPos = height/2;
    ballAngel = ballAngel + PI - 2*ballAngel;
    rightSide = false;
    leftSide = true;
    topSide = true;
    bottomSide = true;
  }

  // if ball hit left wall
  if (ballXPos < ballWidth/2 && leftSide) {
    rightScore++;
    ballXPos = width/2;
    ballYPos = height/2;
    ballAngel = ballAngel + PI - 2*ballAngel;
    leftSide = false;
    rightSide = true;
    topSide = true;
    bottomSide = true;
  }

  // if ball hit top wall  
  if (ballYPos < ballWidth/2 && topSide) {
    //ballYSpeed = abs(ballYSpeed);
    // mirror the x axis of the unit circle
    ballAngel = ballAngel - 2*(ballAngel-PI);

    topSide = false;
    rightSide = true;
    leftSide = true;
    bottomSide = true;
  }

  // if ball hit bottom wall
  if (ballYPos > height - ballWidth/2 && bottomSide) {
    //ballYSpeed = -abs(ballYSpeed);
    // mirror the x axis of the unit circle
    ballAngel = ballAngel - 2*(ballAngel-PI);

    bottomSide = false;
    topSide = true;
    rightSide = true;
    leftSide = true;
  }

  // collison with left pad
  if (ballXPos - ballWidth/2 < padXPos + padWidth/2 && 
    ballYPos < padYPos + padHeight/2 + ballWidth/2 &&
    ballYPos > padYPos - padHeight/2 - ballWidth/2 &&
    ballXPos > padXPos &&
    leftSide) {
    //ballXSpeed = abs(ballXSpeed);
    //ballAngel = ballAngel + PI - 2*ballAngel;
    ballAngel = map(padYPos - ballYPos, 
      -padHeight/2 - ballWidth/2, 
      padHeight/2 + ballWidth/2, 
      PI*1/3, -PI*1/3);

    leftSide = false;
    bottomSide = true;
    topSide = true;
    rightSide = true;
  }

  // collison with right pad
  if (ballXPos + ballWidth/2 > width - padXPos - padWidth/2 && 
    ballYPos < rpadYPos + padHeight/2 &&
    ballYPos > rpadYPos - padHeight/2 &&
    width - padXPos > ballXPos &&
    rightSide) {
    //ballXSpeed = -abs(ballXSpeed);
    //ballAngel = ballAngel + PI - 2*ballAngel;
    ballAngel = map(rpadYPos - ballYPos, 
      -padHeight/2 - ballWidth/2, 
      padHeight/2 + ballWidth/2, 
      PI - PI*1/3, PI + PI*1/3);

    rightSide = false;
    leftSide = true;
    bottomSide = true;
    topSide = true;
  }


  //DRAW
  background(0);
  text(leftScore, width/4, height/5);
  text(rightScore, width - width/4, height/5);
  fill(255, 255, 255, 120);
  rect(width/2, height/2, 5, height);


  fill(255);
  rectMode(CENTER);
  rect(padXPos, mouseY, padWidth, padHeight);
  ellipse(ballXPos, ballYPos, ballWidth, ballWidth);
  rect(width - padXPos, rpadYPos, padWidth, padHeight);
  textSize(64);
}
