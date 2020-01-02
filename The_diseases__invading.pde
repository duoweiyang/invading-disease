/* 
Something that has stood out to me in my academic years of learning the sciences
was the interactive animations used to demonstrate a chemical or biological phenomenon.
I thought this project was a good opportunity to let me see how much I could emulate them.

This particular "metaphor for drawing" demonstrates cells being invaded by pathogens.

Move mouse to create tapeworm of your desired length. Press 'g' or 'G'
to create green spherical germs or press 'o' or 'O' to create blue or mint-green
oval germs. Press 's' or 'S' to reset the program.

You are now an invader of the cells.
*/

int num = 100;
int peas = 35;
float mx[] = new float[num];
float my[] = new float[num];
boolean drawG = false;
boolean drawO = false;

int numCells = 110;
float spring = 0.03;
float gravity = 0.08;
float friction = -0.9;
Cell[] Cells = new Cell[numCells]; 

void setup() 
{
  size(600, 600); 
  smooth();
  noCursor();
  frameRate(50);
  for (int i = 0; i < numCells; i++) {
    int size = (int) random(30, 90);
    Cells[i] = new Cell(random(width), random(height), size, i, Cells);
  }
}

void draw() {
  background(225, 159, 61);
 
 for(int i = 1; i < num; i++) {    //tapeworm
   mx[i-1] = mx[i];
   my[i-1] = my[i];
   
    if (i > 10) {
      float weight = constrain(20, 7, 20);
      strokeWeight(weight);
      stroke(204, 102, 0);
      curve(mx[i-3], my[i-3],mx[i-2],my[i-2],mx[i-1],my[i-1],mx[i],my[i]);
      
      float weight2 = constrain(1, 5, 15);
      strokeWeight(weight2);
      stroke(255);
      curve(mx[i-3], my[i-3],mx[i-2],my[i-2],mx[i-1],my[i-1],mx[i],my[i]);
    }  
  } 

  for (Cell Cell : Cells) {     // call class to create cells
    strokeWeight(3);
    stroke(255, 90);
    fill(204, 0, 0, 80); 
    Cell.collide();
    Cell.move();
    Cell.display();
  }
  
    if (drawG == true) {   // green bacteria
    float w1 = random(width);
    float h1 = random(height);
    float w2 = random(width);
    float h2 = random(height); 
    float w3 = random(width);
    float h3 = random(height); 
   
    ellipseMode(RADIUS);
    fill(81, 168, 59);
    ellipse(w1, h1, 20, 20);
    ellipse(w2, h2, 10, 10);
    ellipse(w3, h3, 40, 40);
    
    ellipseMode(CENTER);
    fill(168, 102, 235);
    ellipse(w1, h1, 20, 20);
    ellipse(w2, h2, 10, 10); 
    ellipse(w3, h3, 40, 40);
    
    drawG = false; // so it can be repeated
  }
  
  if (drawO == true) {   // oval bacteria
    float w1 = random(width);
    float h1 = random(height);
    float w2 = random(width);
    float h2 = random(height); 
    float w3 = random(width);
    float h3 = random(height); 
    
    float angle1 = random(TWO_PI);
    float angle2 = random(TWO_PI);
    float angle3 = random(TWO_PI);
    
    strokeWeight(3);
    stroke(255);
    
    fill(128, 219, 134);
    rotate(angle1);
    ellipse(w1, h1, 20, 60);
    
    fill(0, 107, 132);
    rotate(angle2);
    ellipse(w2, h2, 30, 100);
    rotate(angle3);
    ellipse(w3, h3, 40, 150);
    
    drawO = false; // so it can be repeated
  }
}

class Cell {
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  Cell[] others;
 
  Cell(float xin, float yin, float din, int idin, Cell[] oin) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    others = oin;
  } 
  
  void collide() {
    for (int i = id + 1; i < numCells; i++) {
      float dx = others[i].x - x;
      float dy = others[i].y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others[i].diameter/2 + diameter/2; // if you add /2 it will eventually sink
      
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others[i].x) * spring;
        float ay = (targetY - others[i].y) * spring;
        vx -= ax;
        vy -= ay;
        others[i].vx += ax;
        others[i].vy += ay;
      }
    }   
  }
  
  void move() {
    vy += gravity;
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction; 
    }
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= friction; 
    } 
    else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
    }
  }
  
  void display() {
    ellipse(x, y, diameter, diameter);
  }
}
  
void keyPressed() {            
  if ((key == 'G') || (key == 'g')) {      //repeatedly press for green germs
    drawG = true;
  }

  if ((key == 'O') || (key == 'o')) {      //repeatedly press for oval blue/white germs
    drawO = true;
  }

  if ((key == 'S') || (key == 's')) {      //restart program
    setup();
  } 
}

void mouseMoved()
{
  mx[num-1] = mouseX;
  my[num-1] = mouseY;   
}