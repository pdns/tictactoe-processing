int w, h, x, y, lineLen, turnCount;
float xY, oY;
int player=0;
Tile[][] tile = new Tile[3][3];
boolean gameOver, tie;
PFont fLarge;
PFont fMedium;
PFont fSmall;
PImage ximg, oimg;

void setup()
{
  orientation(PORTRAIT);
  lineLen = displayWidth*10/12;
  smooth();
  w = displayWidth;
  h = displayHeight;
  fLarge = createFont("coolveticarg.ttf", h*8/100, true);
  fMedium = createFont("coolveticarg.ttf", h*6/100, true);
  fSmall = createFont("coolveticarg.ttf", h*4/100, true);
  textAlign(CENTER);
  rectMode(CENTER);
  ximg = createImage(w, (h-lineLen)/2, ARGB);
  oimg = createImage(w, (h-lineLen)/2, ARGB);
  ximg.loadPixels();
  oimg.loadPixels();
  float pc = 0;
  for (int i=0; i<(h-lineLen)/2; i++)
  {
    pc = i*255/((h-lineLen)/2);
    for (int j=0; j<w; j++)
    {
      ximg.pixels[j+i*w] = color(96,96,255, pc*2);
      oimg.pixels[j+i*w] = color(255,96,96, pc*2);//(255-pc)*2);
    }
  }
  ximg.updatePixels();
  oimg.updatePixels();
  
  restartGame();
}

void draw()
{
  drawBoard();
  
  
  drawText();
  
  if (gameOver)
  {
    GameOver();
    if ( oY < h/2 )
    {
      oY = oY + 5;
    }
    if ( xY < h/2 )
    {
      xY = xY + 5;
    }
  }
}

void drawBoard()
{
  background(255);
  strokeWeight(lineLen/48);
  stroke(0);
  fill(255);
  for (int i=1; i<3; i++)
  {
    line ( (w-lineLen)/2+lineLen*i/3, h/2-lineLen/2, (w-lineLen)/2+lineLen*i/3, h/2+lineLen/2 );
    line ( w/2-lineLen/2, h/2-lineLen/2+lineLen*i/3, w/2+lineLen/2, h/2-lineLen/2+lineLen*i/3 );
  }
  
  for (int b=0; b<3; b++)
  {
    for (int a=0; a<3; a++)
    {
      x = w/2-lineLen/3+lineLen*a/3;
      y = h/2-lineLen/3+lineLen*b/3;
      if (tile[a][b].value==0)
      {
        drawX(x,y,lineLen);
      }
      else if (tile[a][b].value==1)
      {
        drawCircle(x,y,lineLen);
      }
    }
  }
}

void drawText()
{ 
  float pcO = (h-lineLen)/2;
  float pcX = (h-lineLen)/2;
  pcX = 1 - (xY-(h-lineLen)/2)/pcX;
  pcO = 1 - (oY-(h-lineLen)/2)/pcO;
  fill(0);
  
  pushMatrix();
  translate(w/2,h/2);
  
  image(ximg,-w/2,xY);
  rotate(PI);
  image(oimg,-w/2,oY);//-(h-lineLen)/2);//+(h-lineLen)/2);
  rotate(PI);
  
  textFont(fLarge);
  fill(255,96,96, pcO*255 - pcO*765*(1-pcO));
  text("Your turn", 0, -oY+lineLen*4/3);
  textFont(fMedium);
  fill(255,255,255, pcX*255 - pcX*765*(1-pcX));
  text("Opponent's turn . . .", 0, xY+lineLen/3);
  
  rotate(PI);
  
  fill(255,255,255, pcO*255 - pcO*765*(1-pcO));
  text("Opponent's turn . . .", 0, oY+lineLen/3);
  textFont(fLarge);
  fill(96,96,255, pcX*255 - pcX*765*(1-pcX));
  text("Your turn", 0, -xY+lineLen*4/3);
  
  
  /*
  pcX = (h-xY)/pcX;
  pcO = -oY/pcO;
  textFont(fMedium);
  fill(0,0,0, pcX*255 - 255*(1-pcX));
  text("Opponent's turn . . .", w/2, xY+(h-lineLen)/3);//h-lineLen/6);
  
  fill(255,96,96, (1-pcO)*255);
  textFont(fLarge);
  text("Your turn", w/2, h*6/8+(oY+lineLen*3/4)/2);
  //pushMatrix();
  translate(w/2,h/2);
  rotate(PI);
  fill(96,96,255, pcX*255);
  //text("Your turn", -w/2, ((h-xY)-lineLen*3/4)/2);//-lineLen/6);
  text("Your turn", 0, h*6/8+(xY+lineLen*3/4)/2);
  fill(0,0,0, (1-pcO)*255 - 255*pcO);
  textFont(fMedium);
  //text("Opponent's turn . . .", -w/2, -oY-(h-lineLen)/6);//-lineLen/6);
  text("Opponent's turn . . .", 0, -oY-lineLen/3);//-(h-lineLen));//h-lineLen/6);
  */
  /*
  pcX = (h-xY)/pcX;
  pcO = -oY/pcO;
  textFont(fMedium);
  fill(0,0,0, pcX*255 - 255*(1-pcX));
  text("Opponent's turn . . .", w/2, xY+(h-lineLen)/3);//h-lineLen/6);
  
  fill(255,96,96, (1-pcO)*255);
  textFont(fLarge);
  text("Your turn", w/2, h*6/8+(oY+lineLen*3/4)/2);
  rotate(PI);
  fill(96,96,255, pcX*255);
  text("Your turn", -w/2, ((h-xY)-lineLen*3/4)/2);//-lineLen/6);
  fill(0,0,0, (1-pcO)*255 - 255*pcO);
  textFont(fMedium);
  text("Opponent's turn . . .", -w/2, -oY-(h-lineLen)/6);//-lineLen/6);
  */
  
  //Colour background and transition
  if (player == 0 && !gameOver)
  {
    if (xY > h/2-(h-lineLen)/2)//h-(h-lineLen)/2)
    {
      xY = xY - 5;
    }
    if (oY < h/2)//-(h-lineLen)/2)
    {
      oY = oY + 5;
    }
  }
  else if (player == 1 && !gameOver)
  {
    if (oY > h/2-(h-lineLen)/2)
    {
      oY = oY - 5;
    }
    if (xY < h/2)
    {
      xY = xY + 5;
    }
  }
}

void drawCircle(int x, int y, int len)
{
  len = len/3;
  strokeWeight(len/6);
  stroke(255,96,96);
  ellipse(x, y, len*2/3, len*2/3);
}

void drawX(int x, int y, int len)
{
  len = len/3;
  strokeWeight(len/6);
  stroke(96,96,255);
  line(x-len/3, y-len/3, x+len/3, y+len/3);
  line(x-len/3, y+len/3, x+len/3, y-len/3);
}

void restartGame()
{
  // Create and initialize tile objects
  for (int b=0; b<3; b++)
  {
    for (int a=0; a<3; a++)
    {
      tile[a][b] = new Tile(a+b*3);
    }
  }
  turnCount = 0;
  gameOver = false;
  tie = true;
  
  oY = h/2;//-(h-lineLen)/2;
  xY = h/2;
}

void mousePressed()
{
  if (gameOver)
  {
    restartGame();
  }
  else
  {
    for (int b=0; b<3; b++)
    {
      for (int a=0; a<3; a++)
      {
        if ( mouseX > (w/2-lineLen/2 + lineLen*a/3) && mouseX < (w/2-lineLen/2 + lineLen*(a+1)/3) && mouseY > (h/2-lineLen/2 + lineLen*b/3) && mouseY < (h/2-lineLen/2 + lineLen*(b+1)/3) && tile[a][b].value == -1 && !gameOver)
        {
          tile[a][b].value = player;
          player = 1 - player;
          turnCount++;
        }
      }
    }
    checkScore();
  }
}
  
//Check score
void checkScore()
{
  for (int b=0; b<3; b++)
  {
    for (int a=0; a<3; a++)
    {
      if ( a==1 )
      {
        if ( tile[a][b].value == tile[a-1][b].value && tile[a][b].value == tile[a+1][b].value && tile[a][b].value != -1 )
        {
          tile[a][b].hori = true;
          println("Hori: " + tile[a][b].hori);
          gameOver = true;
          tie = false;
        }
      }
      if ( b==1 )
      {
        if ( tile[a][b].value == tile[a][b-1].value && tile[a][b].value == tile[a][b+1].value && tile[a][b].value != -1 )
        {
          tile[a][b].vert = true;
          println("Vert: " + tile[a][b].vert);
          gameOver = true;
          tie = false;
        }
      }
      if ( a==1 && b==1 )
      {
        if ( (tile[a][b].value == tile[a-1][b-1].value && tile[a][b].value == tile[a+1][b+1].value && tile[a][b].value != -1) || (tile[a][b].value == tile[a+1][b-1].value && tile[a][b].value == tile[a-1][b+1].value && tile[a][b].value != -1) )
        {
          tile[a][b].diag = true;
          println("Diag: " + tile[a][b].diag);
          gameOver = true;
          tie = false;
        }
      }
    }
  }
  if (turnCount >= 9)
  {
    gameOver = true;
  }
}

void GameOver()
{
  noStroke();
  //stroke(100,100,100,150);
  fill(250,250,250,150);
  rect(0, 0, lineLen*6/5, lineLen*6/5);
  
  fill(96,96,255);//,150);
  rect(0, lineLen, w, (h-lineLen)/2);
  
  fill(255,96,96);//,150);
  rect(0, -lineLen, w, (h-lineLen)/2);
  
  fill(255);
  textFont(fLarge);
  textFont(fSmall);
  text("Tap screen to play again", 0, lineLen*5/6);
  if (tie)
  {
    textFont(fLarge);
    fill(96,96,255);
    text("Tie!", 0, lineLen*2/3);
    rotate(PI);
    fill(255,96,96);
    text("Tie!", 0, lineLen*2/3);
  }
  else if (1-player == 1)
  {
    textFont(fLarge);
    fill(96,96,255);
    text("You lose!", 0, lineLen*2/3);
    rotate(PI);
    fill(255,96,96);
    text("You win!", 0, lineLen*2/3);
  }
  else if (1-player == 0)
  {
    textFont(fLarge);
    fill(96,96,255);
    text("You win!", 0, lineLen*2/3);
    rotate(PI);
    fill(255,96,96);
    text("You lose!", 0, lineLen*2/3);
  }
  textFont(fSmall);
  fill(255);
  text("Tap screen to play again", 0, lineLen*5/6);
}

class Tile
{
  int pos;
  int value;
  boolean diag;
  boolean vert;
  boolean hori;
  
  Tile(int p)
  {
    pos = p;
    value = -1;
    diag = false;
    vert = false;
    hori = false;
  }
}
