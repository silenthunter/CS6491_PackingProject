//Main PackingProject class

public class point
{
  public float X = 0;
  public float Y = 0;
  public float R = 25.0f;
}

point[] circles = new point[5];
point chosen = null;
boolean rMouse = false;

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
    
  if(rMouse)
    drawBounds();
}

void drawBounds()
{
  println("test");
      
  float leftB = width, rightB = 0,
  topB = 0, bottomB = height;
  
  for(int i = 0; i < circles.length; i++)
  {
    if(circles[i].X - circles[i].R < leftB)
      leftB = circles[i].X - circles[i].R;
    if(circles[i].X + circles[i].R > rightB)
      rightB = circles[i].X + circles[i].R;
    if(circles[i].Y - circles[i].R < bottomB)
      bottomB = circles[i].Y - circles[i].R;
    if(circles[i].Y + circles[i].R > topB)
      topB = circles[i].Y + circles[i].R;;
  }
  
  line(0, topB, width, topB);
  line(0, bottomB, width, bottomB);
  line(leftB, 0, leftB, height);
  line(rightB, 0, rightB, height);
  
  float centerX = leftB + (rightB - leftB) / 2;
  float centerY = bottomB + (topB - bottomB) / 2;
  
  float greatestDist = 0;
  point D1 = null, D2 = null;
  for(int i = 0; i < circles.length; i++)
    for(int j = 0; j < circles.length; j++)
    {
      float distance = abs(dist(circles[i].X, circles[i].Y,
        circles[j].X, circles[j].Y)) + circles[i].R + circles[j].R;
        
      if(distance > greatestDist)
      {
        D1 = circles[i];
        D2 = circles[j];
        greatestDist = distance;
      }
    }
   
  centerX = (D1.X + D2.X) / 2;
  centerY = (D1.Y + D2.Y) / 2;
  float radius = greatestDist / 2;  
  
  stroke(0);
  fill(0, 0, 0, 0);
  ellipse(centerX, centerY, radius * 2, radius * 2);
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
  //rMouse = false;
  
  if(mouseButton == LEFT)
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
  else
  {
    rMouse = true;
  }
}

void mouseReleased()
{
  chosen = null;
}
