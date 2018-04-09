class Up
{
  PImage up;
  int y1 = 1155;
  
  Up()
  {
    up = loadImage("up.png"); 
  }
  
  void drawUp()
  {
    image(up, 525, y1, 150, 150);
  }
  void moveUp()
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