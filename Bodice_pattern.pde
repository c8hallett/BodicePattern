void settings() {
  size(int(gridWidth), int(gridHeight));
  noLoop();
}

void draw() {
  background(250);
  drawGrid();
  calculateLandmarks();
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
  Alignment leftAlign = new LeftAlignment(this);
  leftAlign.line(Landmark.COLLAR, Landmark.SHOULDER);
  leftAlign.line(Landmark.ARMPIT, Landmark.OUTER_WAIST);
  leftAlign.line(Landmark.OUTER_WAIST, Landmark.DART_END);
  leftAlign.line(Landmark.DART_START, Landmark.CENTER_WAIST);
  leftAlign.line(Landmark.CENTER_WAIST, Landmark.CENTER_NECKLINE);
  leftAlign.line(Landmark.DART_START, Landmark.DART_TIP);
  leftAlign.line(Landmark.DART_END, Landmark.DART_TIP);
  
  leftAlign.arc(Landmark.COLLAR, Landmark.CENTER_NECKLINE);
  leftAlign.point(Landmark.BUST_APEX);
  leftAlign.circle(Landmark.BUST_APEX, unit / 8);
  leftAlign.curve(Landmark.SHOULDER, Landmark.CHEST_ANCHOR, Landmark.ARMPIT);
  
  leftAlign.drawLandmarks(
    Landmark.CENTER_NECKLINE,
    Landmark.CENTER_WAIST,
    Landmark.OUTER_WAIST,
    Landmark.COLLAR,
    Landmark.SHOULDER,
    Landmark.BUST_APEX,
    Landmark.ARMPIT,
    Landmark.CHEST_ANCHOR,
    Landmark.DART_TIP,
    Landmark.DART_START,
    Landmark.DART_END
  );
  
  Alignment rightAlign = new RightAlignment(this);
  rightAlign.line(Landmark.BACK_COLLAR, Landmark.BACK_SHOULDER);
  rightAlign.line(Landmark.BACK_ARMPIT, Landmark.BACK_OUTER_WAIST);
  rightAlign.line(Landmark.BACK_OUTER_WAIST, Landmark.BACK_CENTER_WAIST);
  rightAlign.line(Landmark.BACK_CENTER_WAIST, Landmark.BACK_CENTER_NECKLINE);
  rightAlign.line(Landmark.BACK_SHOULDER_DART_TIP, Landmark.BACK_SHOULDER_DART_START);
  rightAlign.line(Landmark.BACK_SHOULDER_DART_TIP, Landmark.BACK_SHOULDER_DART_END);
  
  rightAlign.arc(Landmark.BACK_COLLAR, Landmark.BACK_CENTER_NECKLINE);
  rightAlign.curve(Landmark.BACK_SHOULDER, Landmark.BACK_CHEST_ANCHOR, Landmark.BACK_ARMPIT);
  
  rightAlign.drawLandmarks(
    Landmark.BACK_CENTER_NECKLINE,
    Landmark.BACK_CENTER_WAIST,
    Landmark.BACK_OUTER_WAIST,
    Landmark.BACK_COLLAR,
    Landmark.BACK_SHOULDER,
    Landmark.BACK_ARMPIT,
    Landmark.BACK_CHEST_ANCHOR,
    Landmark.SHOULDER_BLADE,
    Landmark.BACK_SHOULDER_DART_TIP,
    Landmark.BACK_SHOULDER_DART_START,
    Landmark.BACK_SHOULDER_DART_END
    //Landmark.BACK_WAIST_DART_TIP,
    //Landmark.BACK_WAIST_DART_START,
    //Landmark.BACK_WAIST_DART_END
  );
  
}

void calculateFrontLandmarks() {
  float boobBuffer = 1 * unit;
  float dartOffset = radians(-10);
  float shoulderDepth = fullFront - getMissingLegOfTriangle(crossFront, shoulderToShoulder);
  
  Point outerWaist = new Point(frontWaist, fullFront);
  Point centerWaist = new Point(0, fullFront);
  newPoint(Landmark.CENTER_NECKLINE, 0, fullFront - centerFront);
  newPoint(Landmark.BUST_APEX, bustSpan, shoulderToBust);
  newPoint(Landmark.COLLAR, shoulderToShoulder - getMissingLegOfTriangle(shoulderLength, shoulderDepth), 0);
  landmarks.put(Landmark.CENTER_WAIST, centerWaist);
  landmarks.put(Landmark.OUTER_WAIST, outerWaist);
  
  // shoulder & chest anchors
  Point shoulder = new Point(shoulderToShoulder, shoulderDepth);
  Point chestAnchor = new Point(acrossChest, shoulderToArmpit);
  landmarks.put(Landmark.SHOULDER, shoulder);
  landmarks.put(Landmark.CHEST_ANCHOR, chestAnchor);
  
  // dart landmarks
  Point dartTip = new Point(bustSpan, shoulderToBust + boobBuffer);
  Point dartStart = dartTip.getPointOnLine(new Vector(0, fullFront - dartTip.y), dartOffset);
  
  landmarks.put(Landmark.DART_TIP, dartTip);
  landmarks.put(Landmark.DART_START, dartStart);
  landmarks.put(Landmark.DART_END, dartStart);
  
  // armpit & armpit anchors
  float armpitAngle = HALF_PI + getAngleOfRise(frontBust-frontWaist, fullFront-shoulderToArmpit);
  landmarks.put(Landmark.ARMPIT, outerWaist.rotatePoint(centerWaist, armpitAngle, sideLength));
}

void insertFrontDart() {
  Point bustPoint = valueOf(Landmark.BUST_APEX);
  float dartAngle = -getAngleOfArcLength(fullFront - bustPoint.y, frontBust - frontWaist);
  
  rotateLandmark(bustPoint, Landmark.DART_END, dartAngle);
  rotateLandmark(bustPoint, Landmark.OUTER_WAIST, dartAngle);
  rotateLandmark(bustPoint, Landmark.ARMPIT, dartAngle);
}

void rotateLandmark(Point anchor, Landmark landmark, float angle) {
  Point toRotate = valueOf(landmark);
  landmarks.put(landmark, anchor.rotatePoint(toRotate, angle, anchor.getDistanceBetween(toRotate)));  
}

void calculateMainBackLandmarks() {  
  float shoulderDartOffset = radians(-10);
  
  Point centerWaist = new Point(0, fullBack);
  Point outerWaist = new Point(backWaist, fullBack);
  Point backShoulder = valueOf(Landmark.SHOULDER);
  Point backCollar = valueOf(Landmark.COLLAR);
  
  newPoint(Landmark.BACK_CENTER_NECKLINE, 0, fullBack - centerBack);
  newPoint(Landmark.BACK_CHEST_ANCHOR, acrossBack, shoulderToBackPit);
  landmarks.put(Landmark.BACK_CENTER_WAIST, centerWaist);
  landmarks.put(Landmark.BACK_OUTER_WAIST, outerWaist);
  landmarks.put(Landmark.BACK_SHOULDER, backShoulder);
  landmarks.put(Landmark.BACK_COLLAR, backCollar);
  
  float backArmpitAngle = HALF_PI + getAngleOfRise(backBust - backWaist, fullBack - shoulderToBackPit);
  
  float shoulderBladeAngle = -getAngleBetweenAnB(backShoulder.getDistanceBetween(backCollar), shoulderToShoulderBlade, collarToShoulderBlade);
  Vector shoulderVector = backShoulder.to(backCollar);
  Vector vectorTangentToShoulder = shoulderVector.rotate(HALF_PI).scaleTo(3 * unit);
  
  Point shoulderBlade = backShoulder.rotatePoint(backCollar, shoulderBladeAngle, shoulderToShoulderBlade);
  Point shoulderDartTip = shoulderBlade.translate(vectorTangentToShoulder.scaleTo(1 * unit));
  Point shoulderDartStart = getIntersection(backShoulder, shoulderBlade, shoulderVector, vectorTangentToShoulder.rotate(shoulderDartOffset));
  
  landmarks.put(Landmark.BACK_ARMPIT, outerWaist.rotatePoint(centerWaist, backArmpitAngle, sideLength));
  landmarks.put(Landmark.SHOULDER_BLADE, shoulderBlade);
  landmarks.put(Landmark.BACK_SHOULDER_DART_TIP, shoulderDartTip);
  landmarks.put(Landmark.BACK_SHOULDER_DART_START, shoulderDartStart);
  landmarks.put(Landmark.BACK_SHOULDER_DART_END, shoulderDartStart);
  
}

Point getDartStart(Point edgeStart, Point edgeEnd, Point dartHinge, float dartOffset){
  Vector edgeDirection = edgeStart.to(edgeEnd);
  // positive radians == clockwise
  Vector dartDirection;
  if(edgeStart.getAngleBetween(edgeEnd, dartHinge) > 0) {
    dartDirection = edgeDirection.rotate(HALF_PI);
  } else {
    dartDirection = edgeDirection.rotate(-HALF_PI);
  }
  
  
}

void newPoint(Landmark landmark, float x, float y) {
  landmarks.put(landmark, new Point(x, y));
}
