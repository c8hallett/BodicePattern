void settings() {
  size(int(gridWidth), int(gridHeight));
  noLoop();
}

void draw() {
  background(250);
  drawGrid();
  calculateLandmarks();
  drawLandmarks();
  drawFinalLines();
}


void calculateLandmarks() {
  landmarks.clear();
  calculateFrontLandmarks();
  insertFrontDart();
  calculateMainBackLandmarks();
}

void drawFinalLines() {
  setPatternStroke();
  line(Landmark.COLLAR, Landmark.SHOULDER);
  line(Landmark.ARMPIT, Landmark.OUTER_WAIST);
  line(Landmark.OUTER_WAIST, Landmark.DART_END);
  line(Landmark.DART_START, Landmark.CENTER_WAIST);
  line(Landmark.CENTER_WAIST, Landmark.CENTER_NECKLINE);
  line(Landmark.DART_START, Landmark.DART_TIP);
  line(Landmark.DART_END, Landmark.DART_TIP);
  
  adjustedNeckArc();
  point(Landmark.BUST_APEX);
  circle(Landmark.BUST_APEX, unit / 8);
  curve(Landmark.SHOULDER, Landmark.CHEST_ANCHOR, Landmark.ARMPIT);
  
}

void calculateFrontLandmarks() {
  float boobBuffer = 1 * unit;
  float dartOffset = radians(-10);
  float shoulderDepth = fullFront - getMissingLegOfTriangle(crossFront, shoulderToShoulder);
  
  Point outerWaist = new Point(frontWaist, fullFront, Alignment.LEFT);
  newLeftPoint(Landmark.CENTER_NECKLINE, 0, fullFront - centerFront);
  newLeftPoint(Landmark.BUST_APEX, bustSpan, shoulderToBust);
  newLeftPoint(Landmark.COLLAR, shoulderToShoulder - getMissingLegOfTriangle(shoulderLength, shoulderDepth), 0);
  newLeftPoint(Landmark.CENTER_WAIST, 0, fullFront);
  landmarks.put(Landmark.OUTER_WAIST, outerWaist);
  
  // shoulder & chest anchors
  Point shoulder = new Point(shoulderToShoulder, shoulderDepth, Alignment.LEFT);
  Point chestAnchor = new Point(acrossChest, shoulderToArmpit, Alignment.LEFT);
  landmarks.put(Landmark.SHOULDER, shoulder);
  landmarks.put(Landmark.CHEST_ANCHOR, chestAnchor);
  
  // dart landmarks
  Point dartTip = new Point(bustSpan, shoulderToBust + boobBuffer, Alignment.LEFT);
  Point dartStart = dartTip.getPointOnLine(new Vector(0, fullFront - dartTip.rawY), dartOffset);
  Point dartEnd = dartStart;
  
  landmarks.put(Landmark.DART_TIP, dartTip);
  landmarks.put(Landmark.DART_START, dartStart);
  landmarks.put(Landmark.DART_END, dartEnd);
  
  // armpit & armpit anchors
  float armpitAngle = HALF_PI + getAngleOfRise(frontBust-frontWaist, fullFront-shoulderToArmpit);
  landmarks.put(Landmark.ARMPIT, outerWaist.rotatePoint(dartEnd, armpitAngle, sideLength));
}

void insertFrontDart() {
  Point bustPoint = valueOf(Landmark.BUST_APEX);
  float dartAngle = -getAngleOfArcLength(fullFront - bustPoint.rawY, frontBust - frontWaist);
  
  rotateLandmark(bustPoint, Landmark.DART_END, dartAngle);
  rotateLandmark(bustPoint, Landmark.OUTER_WAIST, dartAngle);
  rotateLandmark(bustPoint, Landmark.ARMPIT, dartAngle);
}

void rotateLandmark(Point anchor, Landmark landmark, float angle) {
  Point toRotate = valueOf(landmark);
  landmarks.put(landmark, anchor.rotatePoint(toRotate, angle, anchor.getDistanceBetween(toRotate)));  
}



void calculateMainBackLandmarks() {
  Point collar = valueOf(Landmark.COLLAR);
  Point shoulder = valueOf(Landmark.SHOULDER);
  
  newRightPoint(Landmark.BACK_CENTER_WAIST, 0, fullBack);
  newRightPoint(Landmark.BACK_CENTER_NECKLINE, 0, fullBack - centerBack);
  newRightPoint(Landmark.BACK_COLLAR, collar.rawX, collar.rawY);
}

void newLeftPoint(Landmark landmark, float x, float y) {
  landmarks.put(landmark, new Point(x, y, Alignment.LEFT));
}

void newRightPoint(Landmark landmark, float x, float y) {
  landmarks.put(landmark, new Point(x, y, Alignment.RIGHT));
}
