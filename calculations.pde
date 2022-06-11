float getAngleOfArcLength(float radius, float arcLength) {
  return arcLength/radius;
}

float getMissingLegOfTriangle(float hypotenuse, float a) {
  return sqrt(sq(hypotenuse) - sq(a));
}

float getAngleOfRise(float w, float h) {
 return atan(w/h); 
}

float getAngleBetweenAnB(float lengthA, float lengthB, float lengthC) {
  float numerator = sq(lengthA) + sq(lengthB) - sq(lengthC);
  float denominator = 2 * lengthA * lengthB;
  return acos(numerator/denominator);
}

Point getIntersection(Point p1, Point p2, Vector v1, Vector v2) {
  float deltaX = p2.x - p1.x;
  float deltaY = p2.y- p1.y;
  
  float d = getDeterminant(v1.x, -v2.x, v1.y, -v2.y);
  float dx = getDeterminant(deltaX, -v2.x, deltaY, -v2.y);
  
  return p1.translate(v1.scaleBy(dx / d));
}

/**
   | a1 a2 |
det| b1 b2 |
*/
float getDeterminant(float a1, float a2, float b1, float b2) {
    return (a1 * b2) - (a2 * b1);
}
