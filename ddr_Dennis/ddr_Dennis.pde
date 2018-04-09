//
// ddr_Dennis.pde
//
// Dennis Ng
// January 24, 2018
// ART 4200
// Project1
// The program is an interactive game that is very similar to "Dance Dance Revolution"
//



// ----- Measurement Notes for Myself ----- //

// 1083 milliseconds (65 frames) to reach perfect input 
// 17 pixels per milliseconds (one frame)
// Arrows spawn in a MINIMUM of 117 milliseconds (7 frames) per intervals


import ddf.minim.*;
Minim minim;
AudioPlayer player;

PFont font;

PImage leftInput; // Display UI
PImage downInput;
PImage upInput;
PImage rightInput;

boolean press = false;
int stage = 0;

int[] spawnInt; // Array of frames that indicate when arrows spawn
int[] perfectInt; // Array of frames that indicate when to get a PERFECT input (65 frames difference from spawn)
int[] combinationsInt; // Array of possible combination of arrows

int score = 0; //  Score count.
String inputStatus = " "; // Intialize status text

int spawnLeftMax; // Maximum number of left arrows that could spawn.
int spawnDownMax; // Maximum number of down arrows that could spawn.
int spawnUpMax; // Maximum number of up arrows that could spawn.
int spawnRightMax; // Maximum number of right arrows that could spawn.

int spawnLeftCount;
int spawnDownCount;
int spawnUpCount;
int spawnRightCount;

int activeCombination = 0; // Initialize arrow combination counter that use to determine 
// the nearest arrow line 

int arrowDefaultSize = 150; //  X x Y have the save value (150 X 150)

ArrayList<Left> left;
ArrayList<Down> down;
ArrayList<Up> up;
ArrayList<Right> right;

void setup() {

  minim = new Minim(this);
  player = minim.loadFile("dreamhour_safe_on_your_own.mp3"); // Import song file
  size(850, 1080);
  frameRate(250);

  spawnLeftMax = 0; // Initialize the maximum number of per arrows
  spawnDownMax = 0;
  spawnUpMax = 0;
  spawnRightMax = 0;

  String[] spawnString = loadStrings("song1SpawnArrows.txt"); // txt file that contains the spawn timers
  spawnInt = int(split(spawnString[0], ' ')); // Convert string type to int type
  // printArray(spawnInt);
  // for(int i = 0; i < spawnInt.length; i++)
  // {
  //   println(spawnInt[i]);
  // }


  String[] perfectString = loadStrings("song1PerfectInput.txt"); // txt file that contains the timers for perfect inputs
  perfectInt = int(split(perfectString[0], ' ')); // Convert string type to int type
  // printArray(perfectInt);

  String[] combinationsString = loadStrings("song1Combinations.txt"); // txt file that contains the list of possible combinations
  combinationsInt = int(split(combinationsString[0], ' ')); // Convert string type to int type
  // printArray(combinationsInt);  


  background(155);
  leftInput = loadImage("leftInput.png");
  downInput = loadImage("downInput.png");
  upInput = loadImage("upInput.png");
  rightInput = loadImage("rightInput.png");

  left = new ArrayList<Left>();
  down = new ArrayList<Down>();
  up = new ArrayList<Up>();
  right = new ArrayList<Right>();

  // Setting up arrows by going through the "combinationsInt" array.

  for (int count = 0; count < combinationsInt.length; count++) 
  {
    if (combinationsInt[count] == 0) // ←
    {

      left.add(new Left());
      spawnLeftMax++;
    }
    if (combinationsInt[count] == 1) // ← ↓
    {
      left.add(new Left());
      down.add(new Down());
      spawnLeftMax++;
      spawnDownMax++;
    }
    if (combinationsInt[count] == 2) // ← ↑
    {
      left.add(new Left());
      up.add(new Up());
      spawnLeftMax++;
      spawnUpMax++;
    }
    if (combinationsInt[count] == 3) // ← →
    {
      left.add(new Left());
      right.add(new Right());
      spawnLeftMax++;
      spawnRightMax++;
    }
    if (combinationsInt[count] == 4) // ↓
    {
      down.add(new Down());
      spawnDownMax++;
    }
    if (combinationsInt[count] == 5) // ↓ ↑
    {
      down.add(new Down());
      up.add(new Up());
      spawnDownMax++;
      spawnUpMax++;
    }
    if (combinationsInt[count] == 6) // ↓ →
    {
      down.add(new Down());
      right.add(new Right());
      spawnDownMax++;
      spawnRightMax++;
    }
    if (combinationsInt[count] == 7) // ↑
    {
      up.add(new Up());
      spawnUpMax++;
    }
    if (combinationsInt[count] == 8) // ↑ →
    {
      up.add(new Up());
      right.add(new Right());
      spawnUpMax++;
      spawnRightMax++;
    }
    if (combinationsInt[count] == 9) // →
    {
      right.add(new Right());
      spawnRightMax++;
    }
  }
  noLoop();
}


void draw() {
  keyReleased();


  // ------------ TITLE SCREEN + INSTRUCTIONS ------------ //
  if (stage == 0)
  {
    background(0);
    player.pause();
    font = createFont("serpentineBoldItalic.ttf", 42);
    textAlign(CENTER, TOP);
    textFont(font);
    fill(#f7f7f7);
    text("DANCE DANCE REVOLUTION", 425 + 5, 403);
    textAlign(CENTER, TOP);
    textFont(font);
    fill(#d130ab);
    text("DANCE DANCE REVOLUTION", 425, 400);

    font = createFont("serpentineBoldItalic.ttf", 18);
    textAlign(CENTER, CENTER);
    textFont(font);
    fill(#f7f7f7);
    text("D or LEFT ARROW KEY  ------ LEFT ARROW", 425, 550);
    textAlign(CENTER, CENTER);
    textFont(font);
    fill(#f7f7f7);
    text("F or DOWN ARROW KEY  ------ DOWN ARROW", 425, 575);
    textAlign(CENTER, CENTER);
    textFont(font);
    fill(#f7f7f7);
    text("J or UP ARROW KEY  ------ UP ARROW", 425, 600);
    textAlign(CENTER, CENTER);
    textFont(font);
    fill(#f7f7f7);
    text("K or RIGHT ARROW KEY  ------ RIGHT ARROW", 425, 625);

    textAlign(CENTER, CENTER);
    textFont(font);
    fill(#f7f7f7);
    text("PERFECT ------ +1000 Points", 425, 675);
    textAlign(CENTER, CENTER);
    textFont(font);
    fill(#f7f7f7);
    text("GREAT ------ +500 Points", width/2, 700);
    textAlign(CENTER, CENTER);
    textFont(font);
    fill(#f7f7f7);
    text("GOOD ------ +200 Points", 425, 725);
    textAlign(CENTER, CENTER);
    textFont(font);
    fill(#f7f7f7);
    text("MISS ------ +0 Points", 425, 750);

    font = createFont("serpentineBoldItalic.ttf", 24);
    textAlign(CENTER, TOP);
    textFont(font);
    fill(#f7f7f7);
    text("PRESS TAB TO PLAY ...", 425 + 2, 828);
    textAlign(CENTER, TOP);
    textFont(font);
    fill(#d130ab);
    text("PRESS TAB TO PLAY ...", 425, 825);
  }

  // ------------ GAME ------------ //
  if (stage == 1)
  {
    background(155);
    imageMode(CENTER);
    image(leftInput, 125, 125, arrowDefaultSize, arrowDefaultSize);
    image(downInput, 325, 125, arrowDefaultSize, arrowDefaultSize);
    image(upInput, 525, 125, arrowDefaultSize, arrowDefaultSize);
    image(rightInput, 725, 125, arrowDefaultSize, arrowDefaultSize);

    spawnLeftCount = 0;
    spawnDownCount = 0;
    spawnUpCount = 0;
    spawnRightCount = 0;

    // Go through the array "spawnInt." 
    // If spawnInt[x] is less than the current frameCount, spawn the appropriate combination of arrows.
    for (int x = 0; x < spawnInt.length; x++)
    {
      if (frameCount > spawnInt[x])
      {
        if (combinationsInt[x] == 0) // ←
        {
          Left l = left.get(spawnLeftCount);
          l.drawLeft();
          l.moveLeft();
          spawnLeftCount++;
        }
        if (combinationsInt[x] == 1) // ← ↓
        {
          Left l = left.get(spawnLeftCount);
          l.drawLeft();
          l.moveLeft();
          Down d = down.get(spawnDownCount);
          d.drawDown();
          d.moveDown();
          spawnLeftCount++;
          spawnDownCount++;
        }
        if (combinationsInt[x] == 2) // ← ↑
        {
          Left l = left.get(spawnLeftCount);
          l.drawLeft();
          l.moveLeft();
          Up u = up.get(spawnUpCount);
          u.drawUp();
          u.moveUp();
          spawnLeftCount++;
          spawnUpCount++;
        }
        if (combinationsInt[x] == 3) // ← →
        {
          Left l = left.get(spawnLeftCount);
          l.drawLeft();
          l.moveLeft();
          Right r = right.get(spawnRightCount);
          r.drawRight();
          r.moveRight();
          spawnLeftCount++;
          spawnRightCount++;
        }
        if (combinationsInt[x] == 4) // ↓
        {
          Down d = down.get(spawnDownCount);
          d.drawDown();
          d.moveDown();
          spawnDownCount++;
        } 
        if (combinationsInt[x] == 5) // ↓ ↑
        {
          Down d = down.get(spawnDownCount);
          d.drawDown();
          d.moveDown();
          Up u = up.get(spawnUpCount);
          u.drawUp();
          u.moveUp();
          spawnDownCount++;
          spawnUpCount++;
        }
        if (combinationsInt[x] == 6) // ↓ →
        {
          Down d = down.get(spawnDownCount);
          d.drawDown();
          d.moveDown();
          Right r = right.get(spawnRightCount);
          r.drawRight();
          r.moveRight();
          spawnDownCount++;
          spawnRightCount++;
        }
        if (combinationsInt[x] == 7) // ↑
        {
          Up u = up.get(spawnUpCount);
          u.drawUp();
          u.moveUp();
          spawnUpCount++;
        }
        if (combinationsInt[x] == 8) // ↑ →
        {
          Up u = up.get(spawnUpCount);
          u.drawUp();
          u.moveUp();
          Right r = right.get(spawnRightCount);
          r.drawRight();
          r.moveRight();
          spawnUpCount++;
          spawnRightCount++;
        }
        if (combinationsInt[x] == 9) // →
        {
          Right r = right.get(spawnRightCount);
          r.drawRight();
          r.moveRight();
          spawnRightCount++;
        }
      }
    }
    move();

    textAlign(CENTER, CENTER);
    textFont(font);
    fill(#ffffff);
    text(score, 428, 28);
    textAlign(CENTER, CENTER);
    textFont(font);
    fill(#b946fc);
    text(score, 425, 25);
    

    textAlign(CENTER, TOP);
    textFont(font);
    fill(#ffffff);
    text(inputStatus, 428, 403);
    textAlign(CENTER, TOP);
    textFont(font);
    fill(#d130ab);
    text(inputStatus, 425, 400);
    // println(spawnInt[spawnRightCount]);
    println(frameRate); 
  }
}


void keyPressed() {
  final int stop = keyCode;


  // Freezes the game by pressing TAB. This includes the display and audio. 
  if (stop == TAB)
  {
    if (looping)
    {
      stage = 0;
      noLoop();
      player.pause();
    } else
    {
      stage = 1;
      loop();
      player.play();
    }
  }
}

void move()
{
  final int left = keyCode; // Enable arrow keys as inputs
  final int down = keyCode;
  final int up = keyCode;
  final int right = keyCode;
  if (activeCombination < perfectInt.length - 1)
  {
    if (frameCount > perfectInt[activeCombination])
    {
      activeCombination++;
      // println(activeCombination);
    }
  } 

  if (keyPressed)
  {

    if ((key == 'D' || key == 'd' || left == LEFT) && press == false)
    {
      if ((frameCount > perfectInt[activeCombination] - 50) && 
         (frameCount < perfectInt[activeCombination] + 50) &&
         (combinationsInt[activeCombination] < 4))
      {
        inputStatus = "PERFECT";
        press = true;
        score += 1000;
      } 
      if ((frameCount > perfectInt[activeCombination] - 75) && 
         (frameCount < perfectInt[activeCombination] - 49) && 
         (combinationsInt[activeCombination] < 4)) 
      {
        inputStatus = "GREAT";
        press = true;
        score += 400;
      }
      if ((frameCount > perfectInt[activeCombination] - 100) && 
         (frameCount < perfectInt[activeCombination] - 74) && 
         (combinationsInt[activeCombination] < 4)) 
      {
        inputStatus = "GOOD";
        press = true;
        score += 200;
      }
      if ((frameCount < perfectInt[activeCombination] - 99) || 
         (combinationsInt[activeCombination] > 3)) 
      {
        inputStatus = "MISS";
      }
    }
    if ((key == 'F' || key == 'f' || down == DOWN) && press == false)
    {
      if ((frameCount > perfectInt[activeCombination] - 50) && 
         (frameCount < perfectInt[activeCombination] + 50))
      {  
        if(((combinationsInt[activeCombination] > 3) && (combinationsInt[activeCombination] < 7)) || (combinationsInt[activeCombination] == 1))
        {
          inputStatus = "PERFECT";
          press = true;
          score += 1000;
        }
      }
      if ((frameCount > perfectInt[activeCombination] - 75) && 
         (frameCount < perfectInt[activeCombination] - 49))
      {  
        if(((combinationsInt[activeCombination] > 3) && (combinationsInt[activeCombination] < 7)) || (combinationsInt[activeCombination] == 1))
        {
          inputStatus = "GREAT";
          press = true;
          score += 400;
        }
      }
      if ((frameCount > perfectInt[activeCombination] - 100) && 
         (frameCount < perfectInt[activeCombination] - 74))
      {  
        if(((combinationsInt[activeCombination] > 3) && (combinationsInt[activeCombination] < 7)) || (combinationsInt[activeCombination] == 1))
        {
          inputStatus = "GOOD";
          press = true;
          score += 200;
        }
      }
      if (frameCount < perfectInt[activeCombination] - 99)
      {
        inputStatus = "MISS";
      }
      if(combinationsInt[activeCombination] > 6)
      {
        inputStatus = "MISS";
      }
      if((combinationsInt[activeCombination] == 0) || (combinationsInt[activeCombination] == 2) || (combinationsInt[activeCombination] == 3))
      {
        inputStatus = "MISS";
      }
    }
    if ((key == 'J' || key == 'j' || up == UP) && press == false)
    {
      if ((frameCount > perfectInt[activeCombination] - 50) && 
         (frameCount < perfectInt[activeCombination] + 50))
      {  
        if((combinationsInt[activeCombination] == 2) || (combinationsInt[activeCombination] == 5) || 
          (combinationsInt[activeCombination] == 7) || (combinationsInt[activeCombination] == 8))
        {
          inputStatus = "PERFECT";
          press = true;
          score += 1000;
        }
      }
      if ((frameCount > perfectInt[activeCombination] - 75) && 
         (frameCount < perfectInt[activeCombination] - 49))
      {  
        if((combinationsInt[activeCombination] == 2) || (combinationsInt[activeCombination] == 5) || 
          (combinationsInt[activeCombination] == 7) || (combinationsInt[activeCombination] == 8))
        {
          inputStatus = "GREAT";
          press = true;
          score += 400;
        }
      }
      if ((frameCount > perfectInt[activeCombination] - 100) && 
         (frameCount < perfectInt[activeCombination] - 74))
      {  
        if((combinationsInt[activeCombination] == 2) || (combinationsInt[activeCombination] == 5) || 
          (combinationsInt[activeCombination] == 7) || (combinationsInt[activeCombination] == 8))
        {
          inputStatus = "GOOD";
          press = true;
          score += 200;
        }
      }
      if (frameCount < perfectInt[activeCombination] - 99)
      {
        inputStatus = "MISS";
      }
      if(combinationsInt[activeCombination] < 2)
      {
        inputStatus = "MISS";
      }
      if((combinationsInt[activeCombination] == 3) || (combinationsInt[activeCombination] == 4) || 
        (combinationsInt[activeCombination] == 6) || (combinationsInt[activeCombination] == 9))
      {
        inputStatus = "MISS";
      }
    }
    if ((key == 'K' || key == 'k' || right == RIGHT) && press == false)
    {
      if ((frameCount > perfectInt[activeCombination] - 50) && 
         (frameCount < perfectInt[activeCombination] + 50))
      {  
        if((combinationsInt[activeCombination] == 3) || (combinationsInt[activeCombination] == 6) || 
          (combinationsInt[activeCombination] == 8) || (combinationsInt[activeCombination] == 9))
        {
          inputStatus = "PERFECT";
          press = true;
          score += 1000;
        }
      }
      if ((frameCount > perfectInt[activeCombination] - 75) && 
         (frameCount < perfectInt[activeCombination] - 49))
      {  
        if((combinationsInt[activeCombination] == 3) || (combinationsInt[activeCombination] == 6) || 
          (combinationsInt[activeCombination] == 8) || (combinationsInt[activeCombination] == 9))
        {
          inputStatus = "GREAT";
          press = true;
          score += 400;
        }
      }
      if ((frameCount > perfectInt[activeCombination] - 100) && 
         (frameCount < perfectInt[activeCombination] - 74))
      {  
        if((combinationsInt[activeCombination] == 3) || (combinationsInt[activeCombination] == 6) || 
          (combinationsInt[activeCombination] == 8) || (combinationsInt[activeCombination] == 9))
        {
          inputStatus = "GOOD";
          press = true;
          score += 200;
        }
      }
      if (frameCount < perfectInt[activeCombination] - 99)
      {
        inputStatus = "MISS";
      }
      if(combinationsInt[activeCombination] < 3)
      {
        inputStatus = "MISS";
      }
      if((combinationsInt[activeCombination] == 4) || (combinationsInt[activeCombination] == 5) || 
        (combinationsInt[activeCombination] == 7))
      {
        inputStatus = "MISS";
      }
    }
  }
}


void keyReleased() 
{
  if (!keyPressed) 
  {
    press = false;
  }
}