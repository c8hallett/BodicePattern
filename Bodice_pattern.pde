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
  calculateMainLandmarks();
  calculateShoulder();
  calculateDart();
  calculateRemainingWaist();
  calculateAnchorsForShoulderCurve();
  calculateMainBackLandmarks();
}

void drawFinalLines() {
  setPatternStroke();
  adjustedNeckArc();
  line(Landmark.COLLAR, Landmark.SHOULDER);
  line(Landmark.ARMPIT, Landmark.OUTER_WAIST);
  line(Landmark.OUTER_WAIST, Landmark.DART_END);
  line(Landmark.DART_START, Landmark.CENTER_WAIST);
  line(Landmark.CENTER_WAIST, Landmark.CENTER_NECKLINE);
  line(Landmark.DART_START, Landmark.DART_TIP);
  line(Landmark.DART_END, Landmark.DART_TIP);
  
  point(Landmark.BUST_APEX);
  circle(Landmark.BUST_APEX, unit / 8);
  curve(0.0, Landmark.SHOULDER_ANCHOR, Landmark.SHOULDER, Landmark.CHEST_ANCHOR, Landmark.ARMPIT, Landmark.ARMPIT_ANCHOR);
}

void calculateMainLandmarks() {
  landmarks.put(Landmark.CENTER_NECKLINE, new Point(0, fullFront - centerFront));
  landmarks.put(Landmark.BUST_APEX, new Point(bustSpan, shoulderToBust));
  landmarks.put(Landmark.CENTER_WAIST, new Point(0,  fullFront));
}

void calculateShoulder() {
  float shoulderDepth = fullFront - getMissingLegOfTriangle(crossFront, shoulderToShoulder);
  float neckWidth = shoulderToShoulder - getMissingLegOfTriangle(shoulderLength, shoulderDepth);
  
  landmarks.put(Landmark.SHOULDER, new Point(shoulderToShoulder, shoulderDepth));
  landmarks.put(Landmark.COLLAR, new Point(neckWidth, 0));
  landmarks.put(Landmark.CHEST_ANCHOR, new Point(acrossChest, shoulderToArmpit));
}


void calculateDart() {
  Point dartTip = new Point(bustSpan, shoulderToBust + 1 * unit);
  Point dartStart = dartTip.getPointOnLine(new Vector(0, fullFront - dartTip.rawY), radians(-15));
  
  float dartLegLength = dartStart.getDistanceBetween(dartTip);
  float dartAngle = -getAngleOfArcLength(dartLegLength, frontBust - frontWaist);
  
  Point dartEnd = dartTip.rotatePoint(dartTip.to(dartStart), dartAngle, dartLegLength);
  
  landmarks.put(Landmark.DART_TIP, dartTip);
  landmarks.put(Landmark.DART_START, dartStart);
  landmarks.put(Landmark.DART_END, dartEnd);
}

void calculateRemainingWaist() {
  Point dartTip = valueOf(Landmark.DART_TIP);
  Point dartStart = valueOf(Landmark.DART_START);
  Point dartEnd = valueOf(Landmark.DART_END);
  Point centerWaist = valueOf(Landmark.CENTER_WAIST);
  
  Point outerWaist = dartEnd.rotatePoint(dartTip, dartStart.getAngleBetween(centerWaist, dartTip), frontWaist - dartStart.rawX);
  Point armpit = outerWaist.rotatePoint(dartEnd, HALF_PI, sideLength);
  
  landmarks.put(Landmark.OUTER_WAIST, outerWaist);
  landmarks.put(Landmark.ARMPIT, armpit);
  
}

void calculateAnchorsForShoulderCurve() {
  Point shoulder = valueOf(Landmark.SHOULDER);
  Point outerWaist = valueOf(Landmark.OUTER_WAIST);
  Point armpit = valueOf(Landmark.ARMPIT);
  Point chestAnchor = valueOf(Landmark.CHEST_ANCHOR);
  
  // connecting shoulder to armpit
  Point lead = armpit.rotatePoint(outerWaist, -HALF_PI, unit);
  Vector shoulderLine = chestAnchor.to(shoulder).scale(unit);
  Point follow = shoulder.translate(shoulderLine);
  
  
  landmarks.put(Landmark.ARMPIT_ANCHOR, lead);
  landmarks.put(Landmark.SHOULDER_ANCHOR, follow);
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
