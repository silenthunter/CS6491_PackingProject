// Computer Graphics Course Project 1: Packing Disk
// Authors: Bo Pang
// Subject:



//Global Variables
float centerX,centerY;
int[] radiusSet={50,30,40,70,20};
int diskNum=5;
Disks diskSet1= new Disks();
Disks diskSet2;
Disks currentDisks = diskSet1;
int curDisk=-1;
int overIndex=-1;
Circle smallestPlayer1 = null;
Circle smallestPlayer2 = null;
boolean drawPlayer2 = false;

//Intialization
void setup(){
  curDisk=-1;
  overIndex=-1;
  smallestPlayer1 = null;
  smallestPlayer2 = null;
  
  size(800,600);
  centerX=width/2; centerY=height/2;
  float y=0;
  for (int i=0;i<diskNum;i++){
        y+=radiusSet[i];
        diskSet1.add_disk(centerX,y,radiusSet[i], color((int)random(255),(int)random(255),(int)random(255)));
        y+=radiusSet[i];
    }
    
  diskSet2 = diskSet1.clone();
  }


//Display Loop
void draw(){
  background(255);
  fill(0,255,0); text("Packing Game",10,20);
  if(mousePressed&&curDisk!=-1){
    if(overlap()){
      text("overlap",10,50);
      if(overlap2()){
        ;
      }
      else{
        currentDisks.disks[curDisk].set_center_to_nearest_position(currentDisks.disks[overIndex].x,currentDisks.disks[overIndex].y,currentDisks.disks[overIndex].r);
      }
    }
    else{
      currentDisks.disks[curDisk].set_center(currentDisks.disks[curDisk].x+mouseX-pmouseX, currentDisks.disks[curDisk].y+mouseY-pmouseY);
    }
  }
  diskSet1.show();
  
  if(drawPlayer2)
    diskSet2.show();
  
  if(smallestPlayer1 != null)
  {
    fill(100, 100);
    ellipse((float)smallestPlayer1.getX(), (float)smallestPlayer1.getY(), (float)smallestPlayer1.radius * 2, (float)smallestPlayer1.radius * 2);
  }
  if(smallestPlayer2 != null)
  {
    fill(100, 100);
    ellipse((float)smallestPlayer2.getX(), (float)smallestPlayer2.getY(), (float)smallestPlayer2.radius * 2, (float)smallestPlayer2.radius * 2);
  }
}

void mousePressed(){
  curDisk=-1;
  for (int i=0;i<diskNum;i++){
    if(currentDisks.disks[i].dis_ctr_to_mouse()<radiusSet[i]) {curDisk=i;}
  }
  
  if(mouseButton == RIGHT)
  {
    DrawMinimalBounds();
  }
}

boolean overlap(){
  Disk d1=currentDisks.disks[curDisk];
  Disk d2;
  //d1.set_center_to_mouse();
  for (int i=0;i<diskNum;i++){
    if (i==curDisk){
      continue;
    }
    d2=currentDisks.disks[i];
    if(sqrt(sq(d1.x+mouseX-pmouseX-d2.x)+sq(d1.y+mouseY-pmouseY-d2.y))<(d1.r+d2.r)){
     //if(sqrt(sq(mouseX-d2.x)+sq(mouseY-d2.y))<(d1.r+d2.r)){
      text(sqrt(sq(d1.x-d2.x)+sq(d1.y-d2.y)),10,60);
      overIndex=i;
      return true;
    }
  }
  overIndex=-1;
  return false;
}

boolean overlap2(){
  Disk d1=new Disk(currentDisks.disks[curDisk].x,currentDisks.disks[curDisk].y,currentDisks.disks[curDisk].r,currentDisks.disks[curDisk].colour);
  d1.set_center_to_nearest_position(currentDisks.disks[overIndex].x,currentDisks.disks[overIndex].y,currentDisks.disks[overIndex].r);
  Disk d2;
  for (int i=0;i<diskNum;i++){
    if (i==curDisk||i==overIndex){
      continue;
    }
    d2=currentDisks.disks[i];
    //if(sqrt(sq(d1.x+mouseX-pmouseX-d2.x)+sq(d1.y+mouseY-pmouseY-d2.y))<(d1.r+d2.r)){
    if(sqrt(sq(d1.x-d2.x)+sq(d1.y-d2.y))<(d1.r+d2.r)){
      return true;
    }
  }
  return false;
}

void DrawMinimalBounds()
{
  if(currentDisks == diskSet1) smallestPlayer1 = null;
  if(currentDisks == diskSet2) smallestPlayer2 = null;
  
  //Get all triplets and run the Apollonius solver on them
  for(int i = 0; i < currentDisks.n; i++)
    for(int j = 0; j < currentDisks.n; j++)
      for(int k = 0; k < currentDisks.n; k++)
      {
        if(i == j || j == k || i == k) continue;
        
        Circle c1 = new Circle(currentDisks.disks[i].x, currentDisks.disks[i].y, currentDisks.disks[i].r);
        Circle c2 = new Circle(currentDisks.disks[j].x, currentDisks.disks[j].y, currentDisks.disks[j].r);
        Circle c3 = new Circle(currentDisks.disks[k].x, currentDisks.disks[k].y, currentDisks.disks[k].r);
        
        try
        {
          Shape[] solutions = Apollonius.solutionForShapes(c1, c2, c3);
        
          for (Shape shape : solutions) {
            if (shape != null) {
                // whatever you do with the solutions, always check for this
                
                if(shape.getShapeType() != ShapeType.CIRCLE) continue;
                
                Circle res = (Circle)shape;
                boolean allIn = true;
                //See if all the discs are within this circle
                for(int l = 0; l < currentDisks.n; l++)
                {
                  float distance = abs(dist((float)res.getX(), (float)res.getY(), currentDisks.disks[l].x, currentDisks.disks[l].y)) + currentDisks.disks[l].r;
                  if(distance > res.radius + 5)
                    allIn = false;
                }
                
                //Update to a new circle only if it has a smaller radius
                Circle currentMin = currentDisks == diskSet1 ? smallestPlayer1 : smallestPlayer2;
                if(allIn && res.getX() > 0 && (currentMin == null || res.radius <= currentMin.radius))
                {
                  if(currentDisks == diskSet1)smallestPlayer1 = res;
                  if(currentDisks == diskSet2)smallestPlayer2 = res;
                }
            }
          }
        }catch(ArrayIndexOutOfBoundsException e){continue;}
      }
}

void keyPressed()
{
  if(key == '2')
  {
    drawPlayer2 = true;
    currentDisks = diskSet2;
  }
  else if(key == '1')
  {
    drawPlayer2 = false;
    diskSet1 = new Disks();
    currentDisks = diskSet1;
    setup();
  }
}

class Disk {
  float x=0,y=0,r=5;
  color colour = 0;
  Disk () {}
  Disk (float px, float py, float pr, color colour)  {x=px;y=py;r=pr;this.colour=colour;}
  Disk set_center(float px, float py)  {x=px;y=py; return this;}
  Disk set_center_to_mouse() {x=mouseX; y=mouseY; return this;}
  Disk set_center_to_nearest_position(float Ox, float Oy,float Or)  {
    float tmpx=x+mouseX-pmouseX-Ox;
    float tmpy=y+mouseY-pmouseY-Oy;
    float sc=sqrt(sq(Or+r)/(tmpx*tmpx+tmpy*tmpy));
    x=Ox+tmpx*sc;
    y=Oy+tmpy*sc;
    return this;
  }
  Disk show() {fill(colour); ellipse(x,y,2*r,2*r); /*fill(0,0,0); text(x+","+y+","+r,x,y);fill(0,255,0);*/ return this;}
  float dis_ctr_to_mouse() {return sqrt(sq(x-mouseX)+sq(y-mouseY));}
  float dis_border_to_mouse() {return abs(dis_ctr_to_mouse()-r);}
}

class Disks{
  int n=0, maxNum=30;
  Disk[] disks= new Disk[maxNum];
  Disks() {}
  Disks declare() {for (int i=0; i<maxNum; i++) disks[i]=new Disk(); return this;}
  Disks add_disk(float px,float py,float pr,color colour) {disks[n++]=new Disk(px,py,pr,colour); return this;}
  //Disks add_disk(float pr) {disks[n++]=new Disk(px,pr,pr); return this;}
  Disks show() {for (int i=0;i<n;i++) disks[i].show(); return this;} 
  
  Disks clone()
  {
    Disks retn = new Disks();
    for(int i = 0; i < n; i++)
    {
      retn.add_disk(disks[i].x, disks[i].y, disks[i].r, disks[i].colour);
    }
    
    return retn;
  }
}




