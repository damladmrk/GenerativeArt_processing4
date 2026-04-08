/* * CMPE49G Project 3: Typographic Mycelium Network
 */

ArrayList<Hyphae> network;
float noiseScale = 0.005;
int maxHyphae = 800; 
String chars = "abcdefghijklmnopqrstuvwxyz";

void keyPressed() {
  if (key == 's' || key == 'S') {
    String fileName = "generative_art_" + hour() + minute() + second() + ".png";
    saveFrame(fileName);
    println("Saved: " + fileName);
  }
}

void setup() {
  size(1000, 800);
  background(10);
  network = new ArrayList<Hyphae>();
  
  for (int i = 0; i < 15; i++) {
    network.add(new Hyphae(random(width), random(height)));
  }
}

void draw() {
  for (int i = network.size()-1; i >= 0; i--) {
    Hyphae h = network.get(i);
    h.update();
    h.display();
    
    if (random(1) < 0.008 && network.size() < maxHyphae) {
      network.add(new Hyphae(h.pos.x, h.pos.y));
    }
    
    if (h.isDead()) network.remove(i);
  }
}

class Hyphae {
  PVector pos, vel;
  float life = 255;
  float noiseOffset;

  Hyphae(float x, float y) {
    pos = new PVector(x, y);
    vel = PVector.random2D();
    noiseOffset = random(1000);
  }

  void update() {
    float n = noise(pos.x * noiseScale, pos.y * noiseScale, noiseOffset);
    float angle = n * TWO_PI * 4;
    
    PVector steer = PVector.fromAngle(angle);
    vel.add(steer);
    vel.limit(1.2);
    pos.add(vel);
    
    life -= 0.4; 
  }

  void display() {
    char currentChar = chars.charAt((int)random(chars.length()));
    
    float r = map(pos.x, 0, width, 180, 255);
    float g = map(pos.y, 0, height, 180, 255);
    float b = map(dist(pos.x, pos.y, width/2, height/2), 0, 500, 255, 150);
    
    fill(r, g, b, life * 0.15); 
    textSize(random(5, 10));
    textAlign(CENTER, CENTER);
    
    text(currentChar, pos.x, pos.y);
  }

  boolean isDead() {
    return (life <= 0 || pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > height);
  }
}
