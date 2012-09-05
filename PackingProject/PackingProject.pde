// Computer Graphics Course Project 1: Packing Disk
// Authors: Bo Pang
// Subject:



//Global Variables
float centerX,centerY;
int[] radiusSet={50,30,40,70,20,20,10};
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
  
void computeP2()
{
  diskSet2 = placeDisks(diskSet2);
  currentDisks = diskSet2;
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
  
  //drawIntersections();
}

void mousePressed(){
  curDisk=-1;
  for (int i=0;i<diskNum;i++){
    if(currentDisks.disks[i].dis_ctr_to_mouse()<radiusSet[i]) {curDisk=i;}
  }
  
  if(mouseButton == RIGHT)
  {
   
    DrawMinimalBounds(null);
     println((float)smallestPlayer1.getX());
    println((float)smallestPlayer1.getY());
    println((float)smallestPlayer1.radius);
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

void DrawMinimalBounds(Disks diskSet)
{
  Disks last = currentDisks;
  if(diskSet != null) currentDisks = diskSet;
  if(currentDisks == diskSet1) smallestPlayer1 = null;
  else smallestPlayer2 = null;
  
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
                
                //special cases
                float x1, x2, x3, y1, y2, y3, r1, r2, r3;
                x1=(float)c1.getX(); x2=(float)c2.getX(); x3=(float)c3.getX();
                y1=(float)c1.getY(); y2=(float)c2.getY(); y3=(float)c3.getY();
                r1=(float)c1.radius; r2=(float)c2.radius; r3=(float)c3.radius;
                float dist12=abs(dist(x1,y1,x2,y2));
                float dist13=abs(dist(x1,y1,x3,y3));
                float dist23=abs(dist(x2,y2,x3,y3));
                float distSP;
                float tmpX,tmpY,tmpR;
                if(dist12>=dist13&&dist12>=dist23){
                  tmpR=(dist12+r1+r2)/2;
                  tmpX=x1+(tmpR-r1)*(x2-x1)/dist12;
                  tmpY=y1+(tmpR-r1)*(y2-y1)/dist12;
                  distSP=abs(dist(tmpX,tmpY,x3,y3));
                  if(distSP<(tmpR-r3)){
                    res=new Circle(tmpX,tmpY,tmpR);
                  }
                }
                else if(dist13>=dist12&&dist13>=dist23){
                  tmpR=(dist13+r1+r3)/2;
                  tmpX=(x1+(tmpR-r1)*(x3-x1)/dist13);
                  tmpY=(y1+(tmpR-r1)*(y3-y1)/dist13);
                  distSP=abs(dist(tmpX,tmpY,x2,y2));
                  if(distSP<(tmpR-r2)){
                    res=new Circle(tmpX,tmpY,tmpR);
                  }
                }
                else{
                  tmpR=(dist23+r2+r3)/2;
                  tmpX=(x2+(tmpR-r2)*(x3-x2)/dist23);
                  tmpY=(y2+(tmpR-r2)*(y3-y2)/dist23);
                  distSP=abs(dist(tmpX,tmpY,x1,y1));
                  if(distSP<(tmpR-r1)){
                    res=new Circle(tmpX,tmpY,tmpR);
                  }
                }
                
                boolean allIn = true;
                //See if all the discs are within this circle
                for(int l = 0; l < currentDisks.n; l++)
                {
                  float distance = abs(dist((float)res.getX(), (float)res.getY(), currentDisks.disks[l].x, currentDisks.disks[l].y)) + currentDisks.disks[l].r;
                  if(distance > res.radius+1)
                    allIn = false;
                }
                
                //Update to a new circle only if it has a smaller radius
                Circle currentMin = currentDisks == diskSet1 ? smallestPlayer1 : smallestPlayer2;
                if(allIn && res.getX() > 0 && (currentMin == null || res.radius <= currentMin.radius))
                {
                  if(currentDisks == diskSet1)smallestPlayer1 = res;
                  else smallestPlayer2 = res;
                }
            }
          }
        }catch(ArrayIndexOutOfBoundsException e){continue;}
      }
      
      currentDisks = last;
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
  else if(key == 'c' && drawPlayer2)
  {
    computeP2();
    DrawMinimalBounds(null);
  }
}

//http://paulbourke.net/geometry/2circle/
float[] getIntersection(Disk a, Disk b, float ext)
{
  float distance = sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2));
  float a_len = (pow(a.r + ext, 2) - pow(b.r + ext, 2) + pow(distance, 2)) / (2 * distance);
  float h = sqrt(pow(a.r + ext, 2) - pow(a_len, 2));
  
  float CX = a.x + a_len * (b.x - a.x) / distance;
  float CY = a.y + a_len * (b.y - a.y) / distance;
  
  float X1 = CX + h * (b.y - a.y) / distance;
  float Y1 = CY - h * (b.x - a.x) / distance;
  
  float[] retn = new float[2];
  retn[0] = X1;
  retn[1] = Y1;
  return retn;
}

void drawIntersections()
{
  for(int i = 0; i < currentDisks.n; i++)
    for(int j = 0; j < currentDisks.n; j++)
    {
      if( i == j) continue;
      Disk a = currentDisks.disks[i];
      Disk b = currentDisks.disks[j];
      float distance = sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2));
      if(distance < a.r + b.r + 1)
      {
        float[] arr = getIntersection(a, b, 5);
        ellipse(arr[0], arr[1], 10, 10);
      }
    }
}

Disks placeDisks(Disks diskSet)
{
  Disks tmp = new Disks();
  int[] tracker = new int[diskSet.n];
  D_Struct bestSolution = new D_Struct();
  bestSolution.radius = 1000000;
  
  //Order from largest to smallest
  for(int i = 0; i < diskSet.n; i++)
  {
    Disk highest = diskSet.disks[0];
    float curMax = 0f;
    int idx = 0;
    for(int j = 0; j < diskSet.n; j++)
    {
      if(diskSet.disks[j].r > curMax && tracker[j] != 1)
      {
        curMax = diskSet.disks[j].r;
        highest = diskSet.disks[j];
        idx = j;
      }
    }
    tracker[idx] = 1;
    tmp.add_disk(highest.x, highest.y, highest.r, highest.colour);
  }
  
  //place first two disks
  tmp.disks[0].x = width * .75;
  tmp.disks[0].y = height / 2 - tmp.disks[0].r;
  tmp.disks[1].x = width * .75;
  tmp.disks[1].y = height / 2 + tmp.disks[1].r;
  
  ArrayList<D_Struct> openStructs = new ArrayList<D_Struct>();
  Disks root = new Disks();
  root.add_disk(tmp.disks[0].x, tmp.disks[0].y, tmp.disks[0].r, tmp.disks[0].colour);
  root.add_disk(tmp.disks[1].x, tmp.disks[1].y, tmp.disks[1].r, tmp.disks[1].colour);
  
  D_Struct root_struct = new D_Struct();
  root_struct.state = root;
  root_struct.radius = root.disks[0].r + root.disks[1].r;
  root_struct.level = 2;
  
  openStructs.add(root_struct);
  
  //Dijkstra iteration
  while(!openStructs.isEmpty())
  {
    //Get the smallest queue'd radius
    float smallest = 100000f;
    int smallestIdx = 0;
    for(int i = 0; i < openStructs.size(); i++)
    {
      if(smallest > openStructs.get(i).radius)
      {
        smallest = openStructs.get(i).radius;
        smallestIdx = i;
      }
    }
    D_Struct curr = openStructs.get(smallestIdx);
    openStructs.remove(smallestIdx);
    //println(curr.level + "(" + curr.radius + ")");
    
    //Place the next disk
    for(int i = 0; i < curr.state.n; i++)
    for(int j = 0; j < curr.state.n; j++)
    {
      //println("ij: " + i + ", " + j);
      if(i == j) continue;
      Disk nextDisk = tmp.disks[curr.level];
      
      //skip if these disks aren't touching
      float distance = sqrt(pow(curr.state.disks[i].x - curr.state.disks[j].x, 2) + pow(curr.state.disks[i].y - curr.state.disks[j].y, 2));
      if(distance > curr.state.disks[i].r + curr.state.disks[j].r + 1) continue;
      float[] intr = getIntersection(curr.state.disks[i], curr.state.disks[j], nextDisk.r);
      nextDisk.x = intr[0];
      nextDisk.y = intr[1];
      
      //println("Testing: " + i + ", " + j);
      
      //Ignore this placement if it collides with another disk
      if(!isColliding(nextDisk, curr.state))
      {
        D_Struct newLeaf = new D_Struct();
        newLeaf.state = curr.state.clone();
        newLeaf.state.add_disk(nextDisk.x, nextDisk.y, nextDisk.r, nextDisk.colour);
        
        newLeaf.level = curr.level + 1;
        DrawMinimalBounds(newLeaf.state);
        newLeaf.radius = (float)smallestPlayer2.radius;
        //println("Test");
        //println(newLeaf.radius);

        if(newLeaf.level == tmp.n || newLeaf.radius > bestSolution.radius)
        {
          if(newLeaf.radius < bestSolution.radius)
          {
            //println("Solution?");
            bestSolution.state = newLeaf.state.clone();
            bestSolution.radius = newLeaf.radius;
          }
        }
        else
        {
          //println("Adding L" + curr.level + " (" + newLeaf.radius + ")");
          openStructs.add(newLeaf);
        }
        
      }
    }
  }
  
  return bestSolution.state;
}

boolean isColliding(Disk nextDisk, Disks current)
{
  for(int i = 0; i < current.n; i++)
  {
    float distance = sqrt(pow(nextDisk.x - current.disks[i].x, 2) + pow(nextDisk.y - current.disks[i].y, 2));
    if(distance <= nextDisk.r + current.disks[i].r - 1)
    {
      //println("Distance: " + distance + ", Radius: " + (nextDisk.r + current.disks[i].r));
      return true;
    }
  }
  //println("OK!");
  return false;
}

class D_Struct
{
  Disks state;
  int level = 0;
  float radius = 0;
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




