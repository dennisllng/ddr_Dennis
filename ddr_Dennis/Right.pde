class Right
{
  PImage right;
  int y1 = 1155;
  
  Right()
  {
    right = loadImage("right.png"); 
  }
  
  void drawRight()
  {
    image(right, 725, y1, 150, 150);
  }
  void moveRight()
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