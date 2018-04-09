class Down
{
  PImage down;
  int y1 = 1155;
  
  Down()
  {
    down = loadImage("down.png"); 
  }
  
  void drawDown()
  {
    image(down, 325, y1, 150, 150);
  }
  void moveDown()
  {
    y1-=3;
  }
  boolean finished()
  {
    if(y1 < 50)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
}