//Main PackingProject class

public class point
{
  public float X = 0;
  public float Y = 0;
  public float R = 25.0f;
}

point[] circles = new point[5];
point chosen = null;

void setup()
{
  size(500, 500);
  
  //Place circles on the starting line
  float lastPosition = 0;
  for(int i = 0; i < circles.length; i++)
  {
    circles[i] = new point();
    lastPosition += circles[i].R * 2;
    circles[i].X = width / 2;
    circles[i].Y = lastPosition;
  }
}

void draw()
{
  background(255);
  fill(0);
  ellipseMode(CENTER);
  
  //Draw Center Line
  line(width / 2, 0, width / 2, height);
  
  if(mousePressed)
  {

  }
  
  for(int i = 0; i < circles.length; i++)
    ellipse(circles[i].X, circles[i].Y, circles[i].R * 2, circles[i].R * 2);
}

void mouseDragged()
{
  if(chosen != null)
  {
    chosen.X = mouseX;
    chosen.Y = mouseY;
  }
}

void mousePressed()
{    
  chosen = null;
  for(int i = 0; i < circles.length; i++)
  {
    if(dist(mouseX, mouseY, circles[i].X, circles[i].Y) < circles[i].R)
    {
      chosen = circles[i];
      break;
    }
  }
}

void mouseReleased()
{
  chosen = null;
}
