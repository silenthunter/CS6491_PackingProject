// Computer Graphics Course Project 1: Packing Disk
// Authors: Bo Pang
// Subject:



//Global Variables
float centerX,centerY;
int[] radiusSet={50,30,40,70,20};
int diskNum=5;
Disks diskSet1= new Disks();
int curDisk=-1;
int overIndex=-1;
Circle smallest = null;

//Intialization
void setup(){
  size(800,600);
  centerX=width/2; centerY=height/2;
  float y=0;
  for (int i=0;i<diskNum;i++){
        y+=radiusSet[i];
        diskSet1.add_disk(centerX,y,radiusSet[i]);
        y+=radiusSet[i];
    }
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
        diskSet1.disks[curDisk].set_center_to_nearest_position(diskSet1.disks[overIndex].x,diskSet1.disks[overIndex].y,diskSet1.disks[overIndex].r);
      }
    }
    else{
      diskSet1.disks[curDisk].set_center(diskSet1.disks[curDisk].x+mouseX-pmouseX, diskSet1.disks[curDisk].y+mouseY-pmouseY);
    }
  }
  diskSet1.show();
  
  if(smallest != null)
  {
    fill(100, 100);
    ellipse((float)smallest.getX(), (float)smallest.getY(), (float)smallest.radius * 2, (float)smallest.radius * 2);
  }
}

void mousePressed(){
  curDisk=-1;
  for (int i=0;i<diskNum;i++){
    if(diskSet1.disks[i].dis_ctr_to_mouse()<radiusSet[i]) {curDisk=i;}
  }
  
  if(mouseButton == RIGHT)
  {
    DrawMinimalBounds();
  }
}

boolean overlap(){
  Disk d1=diskSet1.disks[curDisk];
  Disk d2;
  //d1.set_center_to_mouse();
  for (int i=0;i<diskNum;i++){
    if (i==curDisk){
      continue;
    }
    d2=diskSet1.disks[i];
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
  Disk d1=new Disk(diskSet1.disks[curDisk].x,diskSet1.disks[curDisk].y,diskSet1.disks[curDisk].r);
  d1.set_center_to_nearest_position(diskSet1.disks[overIndex].x,diskSet1.disks[overIndex].y,diskSet1.disks[overIndex].r);
  Disk d2;
  for (int i=0;i<diskNum;i++){
    if (i==curDisk||i==overIndex){
      continue;
    }
    d2=diskSet1.disks[i];
    //if(sqrt(sq(d1.x+mouseX-pmouseX-d2.x)+sq(d1.y+mouseY-pmouseY-d2.y))<(d1.r+d2.r)){
    if(sqrt(sq(d1.x-d2.x)+sq(d1.y-d2.y))<(d1.r+d2.r)){
      return true;
    }
  }
  return false;
}

void DrawMinimalBounds()
{
  smallest = null;
  for(int i = 0; i < diskSet1.n; i++)
    for(int j = 0; j < diskSet1.n; j++)
      for(int k = 0; k < diskSet1.n; k++)
      {
        if(i == j || j == k || i == k) continue;
        
        Circle c1 = new Circle(diskSet1.disks[i].x, diskSet1.disks[i].y, diskSet1.disks[i].r);
        Circle c2 = new Circle(diskSet1.disks[j].x, diskSet1.disks[j].y, diskSet1.disks[j].r);
        Circle c3 = new Circle(diskSet1.disks[k].x, diskSet1.disks[k].y, diskSet1.disks[k].r);
        
        try
        {
          Shape[] solutions = Apollonius.solutionForShapes(c1, c2, c3);
        
          for (Shape shape : solutions) {
            if (shape != null) {
                // whatever you do with the solutions, always check for this
                
                if(shape.getShapeType() != ShapeType.CIRCLE) continue;
                
                Circle res = (Circle)shape;
                boolean allIn = true;
                for(int l = 0; l < diskSet1.n; l++)
                {
                  float distance = abs(dist((float)res.getX(), (float)res.getY(), diskSet1.disks[l].x, diskSet1.disks[l].y)) + diskSet1.disks[l].r;
                  if(distance > res.radius + 5)
                    allIn = false;
                }
                
                if(allIn && res.getX() > 0 && (smallest == null || res.radius <= smallest.radius))
                {
                  println("yay");
                  smallest = res;
                  println(smallest.getX() + ", " + smallest.getY() + ", " + smallest.radius);
                }
            }
          }
        }catch(ArrayIndexOutOfBoundsException e){continue;}
      }
}

class Disk {
  float x=0,y=0,r=5;
  Disk () {}
  Disk (float px, float py, float pr)  {x=px;y=py;r=pr;}
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
  Disk show() {ellipse(x,y,2*r,2*r); /*fill(0,0,0); text(x+","+y+","+r,x,y);fill(0,255,0);*/ return this;}
  float dis_ctr_to_mouse() {return sqrt(sq(x-mouseX)+sq(y-mouseY));}
  float dis_border_to_mouse() {return abs(dis_ctr_to_mouse()-r);}
}

class Disks{
  int n=0, maxNum=30;
  Disk[] disks= new Disk[maxNum];
  Disks() {}
  Disks declare() {for (int i=0; i<maxNum; i++) disks[i]=new Disk(); return this;}
  Disks add_disk(float px,float py,float pr) {disks[n++]=new Disk(px,py,pr); return this;}
  //Disks add_disk(float pr) {disks[n++]=new Disk(px,pr,pr); return this;}
  Disks show() {for (int i=0;i<n;i++) disks[i].show(); return this;} 
}




