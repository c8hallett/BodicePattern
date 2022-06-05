static float unit = 50;
static float rows = 25;
static float cols = 25;
static float subdivisions = 8;
final float gridWidth = cols * unit;
final float gridHeight = rows * unit;

void drawGrid() {
  setGridStroke();
  
  for(int col = 0; col < cols; col++) {
    setHighlightedGridStroke();
    float colWidth = col * unit;
    line(colWidth, 0, colWidth, gridHeight); 
    setGridStroke();
    for(int sub = 1; sub < subdivisions; sub++) {
      float subColWidth = colWidth + (sub * unit / subdivisions);
      line(subColWidth, 0, subColWidth, gridHeight);
      // for a good time: line(subColWidth, 0, gridHeight, subColWidth);
    }
  }
  
  for(int row = 0; row < rows; row++) {
    setHighlightedGridStroke();
    float rowHeight = row * unit;
    line(0, rowHeight, gridWidth, rowHeight);
    
    setGridStroke();
    for(int sub = 1; sub < subdivisions; sub++) {
      float subRowHeight = rowHeight + (sub * unit / subdivisions);
      line(0, subRowHeight, gridWidth, subRowHeight);
    }
  }
}


void drawLandmarks() {
  setLandmarkStroke();
  for (HashMap.Entry<Landmark, Point> landmark: landmarks.entrySet()) {
    Point p = landmark.getValue();
    point(p.x, p.y);      
   
    text(landmark.getKey().name(), p.x + (0.1 * unit), p.y);
  }
}

// point and circle methods ===============================================================================
void point(Landmark landmark) {
  Point p = valueOf(landmark);
  point(p.x, p.y);
}

void circle(Landmark landmark, float radius) {
  Point center = valueOf(landmark);
  circle(center.x, center.y, radius);
}


// Straight line methods =================================================================================
void line(Point p1, Point p2) {
  line(p1.x, p1.y, p2.x, p2.y);
}

void line(Landmark start, Landmark end) {
  Point one = valueOf(start);
  Point two = valueOf(end);
  line(one, two);
}

// curve methods =========================================================================================
void adjustedNeckArc() {
  Point collar = valueOf(Landmark.COLLAR);
  Point centerNeck = valueOf(Landmark.CENTER_NECKLINE);
  
  float neckWidth = abs(centerNeck.x - collar.x) * 2;
  float neckHeight = abs(centerNeck.y - collar.y) * 2;
  Point center = new Point(min(centerNeck.rawX, collar.rawY), min(centerNeck.rawY, collar.rawY), collar.alignment);
  
  if(collar.x < centerNeck.x) {
    arc(center.x, center.y, neckWidth, neckHeight, HALF_PI, PI, OPEN);
  } else { 
    arc(center.x, center.y, neckWidth, neckHeight, 0, HALF_PI, OPEN);
  }
}

void curve(Landmark start, Landmark middle, Landmark end) {
  Point p1 = valueOf(start);
  Point c1 = valueOf(middle);
  Point p2 = valueOf(end);
  beginShape();
  vertex(p1.x, p1.y);
  quadraticVertex(c1.x - unit, c1.y, p2.x, p2.y);
  endShape();
}

void curve(float intensity, Landmark... landmarks ) {
  curveTightness(intensity);
  
  beginShape();
  for(Landmark landmark: landmarks) {
    Point point = valueOf(landmark);
    curveVertex(point.x, point.y);
  }
  endShape();
}
