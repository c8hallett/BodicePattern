float getAngleOfArcLength(float radius, float arcLength) {
  return arcLength/radius;
}

float getMissingLegOfTriangle(float hypotenuse, float a) {
  return sqrt(sq(hypotenuse) - sq(a));
}

float getAngleOfRise(float w, float h) {
 return atan(w/h); 
}
