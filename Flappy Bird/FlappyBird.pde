//
// Flappy Bird
//
// Created by Dor Shitrit

// declerations
Image bg = new Image();
Image ground = new Image();
Image bird = new Image();
Image tPipe = new Image();
Image bPipe = new Image();
Image tPipe1 = new Image();
Image bPipe1 = new Image();

Music theme = new Music();
Music wing = new Music();
Music hit = new Music();
Music lose = new Music();

Text score = new Text();
Text finalScore = new Text();
Text gameOver = new Text();

Rect end = new Rect();

// global variables
int counter = 0;
float birdVelocity = 0;    // Vertical velocity of the bird
float gravity = 0.5;       // Gravity pulling the bird down
float jumpStrength = -7;
float birdAngle = 0;
int loser = 0;
int loseFlag = 0;
int points = 0;


void setup() {
  size(900, 600);
  bg.setImage("bg.png"); // background
  bg.x = 0;
  bg.y = 0;
  bg.width = 900;
  bg.height = 600;

  ground.setImage("ground.png"); // ground
  ground.x = 0;
  //ground.y = 500;
  ground.y = 550;
  ground.width = 900;
  ground.height = 50;

  theme.load("Angry Birds Theme.mp3"); // theme music
  theme.loop = true;
  theme.play();

  wing.load("wing.mp3"); // wing sound
  hit.load("hit.mp3"); // hit sound
  lose.load("lose.mp3"); // lose sound

  bird.setImage("bird.png"); // bird object
  bird.x = 150;
  bird.y = 300;

// 1th pipes
  tPipe.setImage("pipe-top.png"); // 1th top pipe
  tPipe.x = 900;
  tPipe.y = int(random(-1600, -1300));
  //tPipe.y = -1400;

  int gap = int(random(150, 400)); // gap
  //int gap = 400;

  bPipe.setImage("pipe-bottom.png"); // 1th buttom pipe
  bPipe.x = 900;
  bPipe.y = 1664 + tPipe.y + gap;
  //bPipe.y = int(random(200,500));
  //bPipe.y = 500;

  tPipe.direction = Direction.LEFT;
  tPipe.speed = 10;
  bPipe.direction = Direction.LEFT;
  bPipe.speed = 10;

  if (bPipe.y >= 550) { // fix 1th buttom pipe location
    bPipe.y = 450;
  }

// 2nd pipes
  tPipe1.setImage("pipe-top.png"); // 2nd top pipe
  tPipe1.x = 900;
  tPipe1.y = int(random(-1600, -1300));
  //tPipe1.y = -1400;

  int gap1 = int(random(150, 400)); // gap1
  //int gap1 = 400;

  bPipe1.setImage("pipe-bottom.png"); // 2nd buttom pipe
  bPipe1.x = 900;
  bPipe1.y = 1664 + tPipe1.y + gap1;
  //bPipe1.y = int(random(200,500));
  //bPipe1.y = 500;

  if (bPipe1.y >= 550) { // fix 2nd buttom pipe location
    bPipe1.y = 500;
  }
  
  score.text = str(points);
  score.x = width/2;
  score.y = 50;
  score.textSize = 40;
  score.brush = color(255);
  
  finalScore.text = "Your score is: " + points;
  finalScore.x = 300;
  finalScore.y = 380;
  finalScore.textSize = 50;
  finalScore.brush = color(#E6F700);
  
  gameOver.text = "GAME OVER!";
  gameOver.x = 320;
  gameOver.y = 300;
  gameOver.textSize = 50;
  gameOver.brush = color(#E6F700);
  
  end.x = 250;
  end.y = 245;
  end.width = 410;
  end.height = 160;
  end.pen = 30;
  end.brush = color(153,51,0);
}

/////////////////////////////////////////////////////////////////////////////////////

void draw() {
  bg.draw();
  tPipe.draw();
  bPipe.draw();
  tPipe1.draw();
  bPipe1.draw();
  ground.draw();
  bird.draw();
  score.text = str(points);
  score.draw();

  
  birdVelocity += gravity; // add gravity to speed
  bird.y += birdVelocity; // bird's vertical speed



  if (tPipe.x < -150) { // reset 1th pipes location
    tPipe.y = int(random(-1600, -1300));
    int gap = int(random(150, 400));
    bPipe.y = 1664 + tPipe.y + gap;
    if (bPipe.y >= 550) {
      bPipe.y = 520;
    }
    tPipe.x = 900;
    bPipe.x = 900;
    counter = counter + 1;
  }
  if ((counter >= 5) && (loseFlag == 0)) { // add 2nd pipes after 5 iterations
    addPipe();
  }
    if (tPipe1.x < -150) { // reset 2nd pipes location
      tPipe1.y = int(random(-1600, -1300));
      int gap1 = int(random(150, 400));
      bPipe1.y = 1664 + tPipe1.y + gap1;
      if (bPipe1.y >= 550) {
        bPipe1.y = 450;
      }
      tPipe1.x = 900;
      bPipe1.x = 900;
    }
  
  borders(); // check if the bird doesn't hit anything
  finalScore.text = "Your score is : " + points;
  if ((tPipe.x + 100 == bird.x) || (tPipe1.x + 100 == bird.x)){
    hit.play();
    points++;
  }
}

/////////////////////////////////////////////////////////////////////////////////////

void mousePressed() {
  if (mouseButton == LEFT) {
    if (loser == 0){
    wing.play();
    birdVelocity = jumpStrength; // Jump the bird
    birdAngle = -25;
    }
  }
}

void keyPressed() {
  if(key == ' '){
    if (loser == 0){
    wing.play();
    birdVelocity = jumpStrength; // Jump the bird
    birdAngle = -25;
    }
  }
}

/////////////////////////////////////////////////////////////////////////////////////

void borders() {
  if (tPipe.pointInShape(bird.x, bird.y)) {
    done();
    }
  
  if (bPipe.pointInShape(bird.x, bird.y)) {
    done();
  }
  
  if (tPipe1.pointInShape(bird.x, bird.y)) {
    done();
  }
  
  if (bPipe1.pointInShape(bird.x, bird.y)) {
    done();
  }
  
  if (ground.pointInShape(bird.x, bird.y + 60)) {
    birdVelocity = 0;
    done();
  }

  if (bird.y < -100) {// make function
    done();
  }
}
  

/////////////////////////////////////////////////////////////////////////////////////

void done() {
  //bird.direction = Direction.DOWN;
  //bird.speed = 20;
  if(loseFlag == 0){
  lose.play();
  }
  loseFlag = 1;
  tPipe.speed = 0;
  bPipe.speed = 0;
  tPipe1.speed = 0;
  bPipe1.speed = 0;
  loser = 1;
  if (ground.pointInShape(bird.x, bird.y + 60)) {
  end.draw();
  gameOver.draw();
  if(points >= 10){
    finalScore.x = 290;
  }
  finalScore.draw();
  }
}

/////////////////////////////////////////////////////////////////////////////////////

void addPipe() {
  if (tPipe.x < 450) {
      tPipe1.direction = Direction.LEFT;
      tPipe1.speed = 10;

      bPipe1.direction = Direction.LEFT;
      bPipe1.speed = 10;
    }
}
