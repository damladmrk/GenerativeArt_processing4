/* * CMPE49G Project 3: Interactive Vortex Flow
 */

ArrayList<StreamLine> lines;
ArrayList<PVector> attractors; 
float noiseScale = 0.003;
int totalLines = 50000;

void setup() {
  size(1200, 800, P2D);
  colorMode(HSB, 360, 100, 100, 100);
  background(260, 20, 5); 
  
  lines = new ArrayList<StreamLine>();
  attractors = new ArrayList<PVector>();
  
  attractors.add(new PVector(width/2, height/2));

  for (int i = 0; i < totalLines; i++) {
    lines.add(new StreamLine());
  }
}

void draw() {
  fill(260, 20, 5, 10); 
  noStroke();
  rect(0, 0, width, height);

  for (StreamLine l : lines) {
    l.applyForces();
    l.update();
    l.display();
  }
}

void mousePressed() {
  attractors.add(new PVector(mouseX, mouseY));
  // Çok fazla merkez olursa sistemi yormasın (son 10 merkezi tut)
  if (attractors.size() > 10) {
    attractors.remove(0);
  }
}

class StreamLine {
  PVector pos, vel, acc, prevPos;
  float maxSpeed = 2.5;

  StreamLine() {
    pos = new PVector(random(width), random(height));
    prevPos = pos.copy();
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
  }

  void update() {
    prevPos = pos.copy();
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0);
    
    if (pos.x > width || pos.x < 0 || pos.y > height || pos.y < 0) {
      pos.set(random(width), random(height));
      prevPos.set(pos);
      vel.mult(0);
    }
  }

  void applyForces() {
    float angle = noise(pos.x * noiseScale, pos.y * noiseScale, frameCount * 0.002) * TWO_PI;
    PVector noiseF = PVector.fromAngle(angle).mult(0.08);
    acc.add(noiseF);

    for (PVector a : attractors) {
      float d = dist(pos.x, pos.y, a.x, a.y);
      if (d < 400) {
        PVector steer = new PVector(a.y - pos.y, pos.x - a.x);
        float strength = map(d, 0, 400, 0.6, 0);
        steer.setMag(strength);
        acc.add(steer);
      }
    }
  }

  void display() {
    float speed = vel.mag();
    float hue = map(pos.x, 0, width, 190, 340); // Ekranın solundan sağına Mavi -> Pembe
    hue = (hue + frameCount * 0.2) % 360; // Zamanla renklerin kayması (Dreamy effect)
    
    float bright = map(speed, 0, maxSpeed, 60, 100);
    
    stroke(hue, 80, bright, 25); 
    strokeWeight(1.2);
    line(pos.x, pos.y, prevPos.x, prevPos.y);
  }
}

void keyPressed() {
  if (key == 's' || key == 'S') saveFrame("interactive_vortex_####.png");
  if (key == 'c' || key == 'C') attractors.clear(); // 'c' tuşu ekranı/merkezleri temizler
}
