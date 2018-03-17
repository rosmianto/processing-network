ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Line> lines = new ArrayList<Line>();
boolean mutex = true;
PFont font;

final int NODE_NUMBER = 10;
final int NODE_RADIUS = 140;

void setup() {
  font = loadFont("SourceCodePro-Regular-13.vlw");
  textFont(font);
  
  size(600, 600);
  background(0);
  frame.setTitle("Mesh Network Simulation Using Processing");
  
  drawHelp();
  
  // Generate nodes
  for(int i = 0; i < NODE_NUMBER; i++) {
    nodes.add(new Node(i, random(50, width - 50), random(150, height - 50), 35));
  }
}

void draw() {
  background(0);
  drawHelp();
  
  // Render connection lines
  calculateConnectionLines();
  drawConnectionLines();
  
  // Render nodes
  for(Node n : nodes) {
    n.draw();
  }
}

void mousePressed() {
  for(Node n : nodes) {
    n.checkMousePressed();
  }
}

void mouseReleased() {
  mutex = true;
  for(Node n : nodes) {
    n.checkMouseReleased();
  }
}

void mouseDragged() {
  for(Node n : nodes) {
    boolean canMove = n.checkMouseDragged(mutex);
    if(canMove) {
      mutex = false;
      break;
    }
  }
}

void keyTyped() {
  if(key == 'R' || key == 'r') {
    regenerateNodes();
  }
  else if(key == 'S' || key == 's') {
    toggleRange();
  }
}

void regenerateNodes() {
  nodes.clear();
  // Generate nodes
  for(int i = 0; i < NODE_NUMBER; i++) {
    nodes.add(new Node(i, random(50, width - 50), random(150, height - 50), 35));
  }
}

void toggleRange() {
  for(Node n : nodes) {
    n.outerCircle = !n.outerCircle;
  }
}

void calculateConnectionLines() {
  // O(n^2)
  
  lines.clear();  
  for(Node n1 : nodes) {
    for(Node n2 : nodes) {
      if(n1.index == n2.index)
        continue;
      else {
        if(dist(n1.x, n1.y, n2.x, n2.y) < NODE_RADIUS) {
          lines.add(new Line(n1.x, n1.y, n2.x, n2.y));
        }
      }
    }
  }
}

void drawConnectionLines() {
  stroke(255);
  strokeWeight(2);
  for(Line l : lines) {
    //float distance = dist(l.x1, l.y1, l.x2, l.y2);
    
    //if(distance < 50)
    //  stroke(0x03, 0xFA, 0x0C);
    //else if(distance > 50 && distance < 100)
    //  stroke(255, 255, 0);
    //else
    //  stroke(255, 0, 0);
      
    line(l.x1, l.y1, l.x2, l.y2);
  }
}

void drawHelp() {
  fill(255);
  textAlign(LEFT);
  text("R: Regenerate network\nA: Add Node\nS: Toggle Range", 10, 10, width - 10, 100);
}

class Node {
  int index;
  float x;
  float y;
  float radius;
  int fillColor = 255;
  boolean outerCircle = false;
  boolean movable = false;
  
  public Node(int index, float x, float y, float radius) {
    this.index = index;
    this.x = x;
    this.y = y;
    this.radius = radius;
  }
  
  public void draw() {
    noStroke();
    fill(this.fillColor);
    ellipse(this.x, this.y, this.radius, this.radius);
    fill(0);
    textAlign(CENTER, CENTER);
    text(index, this.x, this.y);
    if(outerCircle) {
      noStroke();
      fill(this.fillColor, 50);
      ellipse(this.x, this.y, this.radius * 4, this.radius * 4);
    }
  }
  
  public void checkMousePressed() {
    //outerCircle = (dist(mouseX, mouseY, this.x, this.y) < this.radius);
  }
  
  public void checkMouseReleased() {
    //outerCircle = false;
    this.movable = false;
  }
  
  public boolean checkMouseDragged(boolean mutex) {
    if(mutex && (dist(mouseX, mouseY, this.x, this.y) < this.radius)) {
      this.movable = true;
      //outerCircle = true;
      return true;
    }
      
    if(this.movable) {
      if(dist(mouseX, mouseY, this.x, this.y) < this.radius) {
        this.x = mouseX;
        this.y = mouseY;
      }
    }
    return false;
  }
}

class Line {
  float x1;
  float y1;
  float x2;
  float y2;
  
  public Line(float x1, float y1, float x2, float y2){
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
  }
}
