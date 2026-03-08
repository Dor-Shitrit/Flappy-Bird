//
// Flappy Bird
//
// Created by Dor Shitrit
//

// declerations
Rect stopScrn = new Rect();
Rect[] stop = new Rect[2];
Image bg = new Image();
Image ground1 = new Image();
Image ground2 = new Image();
Image bird = new Image();
Image tPipe1 = new Image();
Image bPipe1 = new Image();
Image tPipe2 = new Image();
Image bPipe2 = new Image();

Music theme = new Music();
Music wing = new Music();
Music hit = new Music();
Music lose = new Music();

Text opening = new Text();
Text pause1 = new Text();
Text pause2 = new Text();
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
int points = 0;

//flags
boolean isPressed = false; // game start flag
boolean pipe1Scored = false;
boolean pipe2Scored = false;
int loser = 0; // lose flag
int isPaused = -1; // pause flag


void setup() {
  size(900, 600);

  stopScrn.x = 0; // // start + pause background
  stopScrn.y = 0;
  stopScrn.width = 900;
  stopScrn.height = 600;
  stopScrn.alpha = 70;
  stopScrn.brush = color(#00D4FC);

  int xSt = 0;
  for (int i = 0; i < stop.length; i++) { // pause symbol
    stop[i] = new Rect();
    stop[i].x = 380 + xSt;
    stop[i].y = 200;
    stop[i].width = 40;
    stop[i].height = 120;
    stop[i].brush = color(#E6F700);

    xSt += 80;
  }

  bg.setImage("bg.png"); // background
  bg.x = 0;
  bg.y = 0;
  bg.width = 900;
  bg.height = 600;

  ground1.setImage("ground.png"); // ground1
  ground1.x = 0;
  ground1.y = 550;
  ground1.width = 900;
  ground1.height = 50;

  ground2.setImage("ground.png"); // ground2
  ground2.x = width;
  ground2.y = 550;
  ground2.width = 900;
  ground2.height = 50;

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
  tPipe1.setImage("pipe-top.png"); // 1th top pipe
  tPipe1.x = 700;
  tPipe1.y = int(random(-1600, -1300));

  int gap = int(random(150, 400)); // gap

  bPipe1.setImage("pipe-bottom.png"); // 1th buttom pipe
  bPipe1.x = 700;
  bPipe1.y = 1664 + tPipe1.y + gap;

  if (bPipe1.y >= 550) { // fix 1th buttom pipe location
    bPipe1.y = 450;
  }

  // 2nd pipes
  tPipe2.setImage("pipe-top.png"); // 2nd top pipe
  tPipe2.x = 900;
  tPipe2.y = int(random(-1600, -1300));

  int gap1 = int(random(150, 400)); // gap1

  bPipe2.setImage("pipe-bottom.png"); // 2nd buttom pipe
  bPipe2.x = 900;
  bPipe2.y = 1664 + tPipe2.y + gap1;

  if (bPipe2.y >= 550) { // fix 2nd buttom pipe location
    bPipe2.y = 500;
  }

  opening.text = "Press any key to start";
  opening.x = 220;
  opening.y = 300;
  opening.textSize = 50;
  opening.brush = color(#E6F700);
  //opening.font = "Baskerville-SemiBold-48";

  pause1.text = "Game Paused";
  pause1.x = 340;
  pause1.y = 130;
  pause1.textSize = 35;
  pause1.brush = color(#E6F700);

  pause2.text = "Press P to continue";
  pause2.x = 310;
  pause2.y = 170;
  pause2.textSize = 35;
  pause2.brush = color(#E6F700);

  score.text = str(points);
  score.x = width/2 - 18;
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
  end.brush = color(153, 51, 0);
}

/////////////////////////////////////////////////////////////////////////////////////

void draw() {
  bg.draw();
  tPipe1.draw();
  bPipe1.draw();
  tPipe2.draw();
  bPipe2.draw();
  ground1.draw();
  ground2.draw();
  bird.draw();
  score.text = str(points);
  score.draw();

  if (isPressed == false) {
    stopScrn.draw();
    opening.draw();
  }

  if (isPressed == true) { // Start game
    if (tPipe1.speed == 0) {
      tPipe1.speed = 10;
      bPipe1.speed = 10;
      ground1.speed = 10;
      ground2.speed = 10;
    }
    
    groundMove();

    birdVelocity += gravity; // add gravity to speed
    bird.y += birdVelocity; // bird's vertical speed

    pipeOne(); // reset 1th pipes location

    level2(); // add 2nd pipes after 5 points

    level3(); // speed up after 10 points

    borders(); // check if the bird doesn't hit anything

    done(); // stop everything

    finalScore.text = "Your score is : " + points; // update the score

    if ((isPaused == 1) && (loser != 1)) {
      birdVelocity = 0;
      stopScrn.draw();
      for (int i = 0; i < stop.length; i++) {
        stop[i].draw();
        pause1.draw();
        pause2.draw();
      }
    }

    if (loser == 0) { // score logic
      if (!pipe1Scored && (tPipe1.x + 100 < bird.x)) {
        hit.play();
        points++;
        pipe1Scored = true;
      }
      if (!pipe2Scored && (tPipe2.x + 100 < bird.x)) {
        hit.play();
        points++;
        pipe2Scored = true;
      }
    }
  }
}

/////////////////////////////////////////////////////////////////////////////////////

void mousePressed() {
  isPressed = true;
  if ((mouseButton == LEFT) && (isPaused != 1)) {
    if (loser == 0) {
      wing.play();
      birdVelocity = jumpStrength; // Jump the bird
      birdAngle = -25;
    }
  }
}

void keyPressed() {
  isPressed = true;
  if ((key == ' ') && (isPaused != 1)) {
    if (loser == 0) {
      wing.play();
      birdVelocity = jumpStrength; // Jump the bird
      birdAngle = -25;
    }
  }
  if ((key == 'p') || (key == 'P') || (key == 'פ')) {
    isPaused *= -1;
  }
}

/////////////////////////////////////////////////////////////////////////////////////

void pipeOne() {
  tPipe1.direction = Direction.LEFT;
  bPipe1.direction = Direction.LEFT;

  if (tPipe1.x < -150) {
    tPipe1.y = int(random(-1600, -1300));
    int gap = int(random(150, 400));
    bPipe1.y = 1664 + tPipe1.y + gap;

    if (bPipe1.y >= 550) { // fix bottom pipe if the gap is too small
      bPipe1.y = 450;
    }
    tPipe1.x = 900;
    bPipe1.x = 900;
    pipe1Scored = false;
  }
}

/////////////////////////////////////////////////////////////////////////////////////

void borders() {
  if ((tPipe1.pointInShape(bird.x, bird.y)) && (loser == 0)) {
    lose.play();
    loser = 1;
  }

  if ((bPipe1.pointInShape(bird.x, bird.y)) && (loser == 0)) {
    lose.play();
    loser = 1;
  }

  if ((tPipe2.pointInShape(bird.x, bird.y)) && (loser == 0)) {
    lose.play();
    loser = 1;
  }

  if ((bPipe2.pointInShape(bird.x, bird.y)) && (loser == 0)) {
    lose.play();
    loser = 1;
  }

  if ((bird.y < -100) && (loser == 0)) {
    lose.play();
    loser = 1;
  }

  if ((ground1.pointInShape(bird.x, bird.y + 60))
    || (ground2.pointInShape(bird.x, bird.y + 60))) {
    birdVelocity = 0;
    if (loser == 0) {
      lose.play();
    }
    loser = 1;

    end.draw();
    gameOver.draw();

    if (points >= 10) { // center the scoreboard
      finalScore.x = 290;
    }

    finalScore.draw();
  }
}

/////////////////////////////////////////////////////////////////////////////////////

void done() {
  if ((loser == 1) || (isPaused == 1)) {
    tPipe1.speed = 0;
    bPipe1.speed = 0;
    tPipe2.speed = 0;
    bPipe2.speed = 0;
    ground1.speed = 0;
    ground2.speed = 0;
  }
}

/////////////////////////////////////////////////////////////////////////////////////

void groundMove() {
  ground1.direction = Direction.LEFT;
  ground2.direction = Direction.LEFT;
  if (ground1.x <= -ground1.width) {
    ground1.x = width;
  }

  if (ground2.x <= -ground2.width) {
    ground2.x = width;
  }
}

/////////////////////////////////////////////////////////////////////////////////////

void level2() {
  if ((points >= 5) && (loser == 0)) {
    addPipe();
  }
  if (tPipe2.x < -150) { // reset 2nd pipes location
    tPipe2.y = int(random(-1600, -1300));
    int gap1 = int(random(150, 400));
    bPipe2.y = 1664 + tPipe2.y + gap1;
    if (bPipe2.y >= 550) { // fix bottom pipe if the gap is too small
      bPipe2.y = 450;
    }
    tPipe2.x = 900;
    bPipe2.x = 900;
    pipe2Scored = false;
  }
}

/////////////////////////////////////////////////////////////////////////////////////

void addPipe() {
  if (tPipe1.x == 450) {
    tPipe2.direction = Direction.LEFT;
    tPipe2.speed = tPipe1.speed;

    bPipe2.direction = Direction.LEFT;
    bPipe2.speed = bPipe1.speed;
  }
}

/////////////////////////////////////////////////////////////////////////////////////

void level3() {
  if ((points >= 10) && (points < 15) && (loser == 0)) {
    int newSpeed = points + 1;
    tPipe1.speed = newSpeed;
    bPipe1.speed = newSpeed;
    tPipe2.speed = newSpeed;
    bPipe2.speed = newSpeed;
    ground1.speed = newSpeed;
    ground2.speed = newSpeed;
  }
}
