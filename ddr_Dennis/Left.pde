class Left
{
  PImage left;
  int y1 = 1155;
  
  Left()
  {
    left = loadImage("left.png"); 
  }
  
  void drawLeft()
  {
    image(left, 125, y1, 150, 150);
  }
  void moveLeft()
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