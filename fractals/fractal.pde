/* * CMPE49G Project 3: Biological Fractal (Mandelbulb-inspired)
 */

float a = 0;
int pointDensity = 250; 

void setup() {
  size(1000, 1000, P3D); 
  pixelDensity(displayDensity());
  smooth(8); 
void draw() {
  background(15);
  translate(width/2, height/2, 0);
  rotateX(a);
  rotateY(a * 0.4);
  
  float r = 250; 
  for (int i = 0; i < pointDensity; i++) {
    float lat = map(i, 0, pointDensity, -HALF_PI, HALF_PI);
    for (int j = 0; j < pointDensity; j++) {
      float lon = map(j, 0, pointDensity, -PI, PI);
      
      float x = r * cos(lat) * cos(lon);
      float y = r * cos(lat) * sin(lon);
      float z = r * sin(lat);
      
      float noiseVal = noise(x * 0.008 + a*0.5, y * 0.008, z * 0.008);
      float offset = map(noiseVal, 0.2, 0.8, -120, 120); 
      float rD = r + offset;
      float xD = rD * cos(lat) * cos(lon);
      float yD = rD * cos(lat) * sin(lon);
      float zD = rD * sin(lat);
      
      float red = map(noiseVal, 0.3, 0.7, 100, 255);
      float green = map(noiseVal, 0.3, 0.7, 0, 50);
      float blue = map(noiseVal, 0.3, 0.7, 10, 30);  
      
      stroke(red, green, blue, 180); // Yüksek opaklık, yoğun doku için
      strokeWeight(map(noiseVal, 0, 1, 0.5, 2.0)); // Çıkıntılarda noktalar daha kalın
      point(xD, yD, zD);
    }
  }
  
  a += 0.005;
}

void keyPressed() {
  if (key == 's' || key == 'S') saveFrame("neural_fractal_####.png");
}
