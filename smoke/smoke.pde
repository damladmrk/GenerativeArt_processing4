/* * CMPE49G Project 3: Cosmic Smoke Flow
 */

ArrayList<FlowParticle> particles;
float noiseScale = 0.004;
int totalParticles = 2000;

PVector v1, v2, v3; 

void setup() {
  size(1000, 800);
  background(10);
  particles = new ArrayList<FlowParticle>();
  
  v1 = new PVector(width * 0.3, height * 0.4);
  v2 = new PVector(width * 0.7, height * 0.6);
  v3 = new PVector(width * 0.5, height * 0.2);

  for (int i = 0; i < totalParticles; i++) {
    particles.add(new FlowParticle());
  }
}

void draw() {
  for (FlowParticle p : particles) {
    p.applyForces();
    p.update();
    p.display();
    p.checkEdges();
  }
}

class FlowParticle {
  PVector pos, vel, acc, prevPos;
  float maxSpeed = 1.2;

  FlowParticle() {
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
  }

  void applyForces() {
    float angle = noise(pos.x * noiseScale, pos.y * noiseScale, frameCount * 0.001) * TWO_PI * 2;
    PVector noiseForce = PVector.fromAngle(angle);
    noiseForce.mult(0.05);
    acc.add(noiseForce);

    applyVortex(v1, 150, 0.08);
    applyVortex(v2, 200, -0.06); 
  }

  void applyVortex(PVector center, float radius, float strength) {
    float d = dist(pos.x, pos.y, center.x, center.y);
    if (d < radius) {
      PVector steer = new PVector(center.y - pos.y, pos.x - center.x);
      steer.setMag(strength);
      acc.add(steer);
    }
  }

  void display() {
    float n = noise(pos.x * 0.005, pos.y * 0.005, frameCount * 0.002);
    float r = map(n, 0, 1, 180, 255);
    float g = map(n, 0, 1, 150, 220);
    float b = map(n, 0, 1, 220, 255);
    
    stroke(r, g, b, 4);
    strokeWeight(1);
    line(pos.x, pos.y, prevPos.x, prevPos.y);
  }

  void checkEdges() {
    if (pos.x > width || pos.x < 0 || pos.y > height || pos.y < 0) {
      pos.set(random(width), random(height));
      prevPos.set(pos);
      vel.mult(0);
    }
  }
  
  void keyPressed() {
  if (key == 's' || key == 'S') saveFrame("smoke_####.png");
  }
}
