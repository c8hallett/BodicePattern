class Point {
  public float x = 0;
  public float y = 0;
  public float rawX = 0;
  public float rawY = 0;
  public Alignment alignment = Alignment.LEFT;
  
  public Point(float x, float y, Alignment alignment) {
    this.x = adjustX(x, alignment);
    this.y = adjustY(y, alignment);
    this.rawX = x;
    this.rawY = y;
    this.alignment = alignment;
  }
  
  void drawSelf() {
    point(x, y);
  }
  
  float getDistanceBetween(Point other) {
    return sqrt(sq(other.x - this.x) + sq(other.y - this.y));
  }
  
  Vector to(Point other) {
    return new Vector(other.rawX - this.rawX, other.rawY - this.rawY);
  }
  
  float getAngleBetween(Point p1, Point p2) {
    return getAngleBetween(this.to(p1), this.to(p2));
  }
  
  float getAngleBetween(Vector ray, Point p1) {
    return getAngleBetween(this.to(p1), ray);
  }
  
  float getAngleBetween(Vector u, Vector v) {
    float crossProduct = (u.x * v.x) + (u.y * v.y);
    float denominator = u.getMagnitude() * v.getMagnitude();
    return acos(crossProduct / denominator);
  }
  
  @Override 
  final String toString() {
    return "(" + rawX / unit + ", " + rawY / unit + ")";
  }
  
  float adjustX(float point, Alignment alignment) {
    switch(alignment){
      case LEFT:
        return point + unit;
      case RIGHT:
        return gridWidth - (point + unit);
      default:
        return point;
    }  
  }
  
  float adjustY(float point, Alignment alignment) {
    switch(alignment){
      case LEFT:
        return point + unit;
      case RIGHT:
        return point + unit;
      default:
        return point;
    }
  }
  
  /**
  @param centerPoint: center of circle
  @param radius: radius of circle
  @param theta: expected to be in radians
  */
  Point translate(Vector direction) {
    return new Point(this.rawX + direction.x, this.rawY + direction.y, this.alignment);
  }
   
  /**
  known: angle from initial vector, total distance from vector
  unknown: end coordinates
  
  @param anchor location of initial vector
  @param ray initial vector
  @param theta angle from initial vector, in radians
  */
  Point rotatePoint(Vector ray, float theta, float distance) {
    Vector transform = ray.rotate(theta).scale(distance);
    return new Point(this.rawX + transform.x, this.rawY+ transform.y, this.alignment);
  }
  /**
  known: angle from initial vector, total distance from vector
  unknown: end coordinates
  
  @param anchor location of initial vector
  @param ray initial vector
  @param theta angle from initial vector, in radians
  */
  Point rotatePoint(Point end, float theta, float distance) {
    return rotatePoint(this.to(end), theta, distance);
  }
  
  /**
     anchor o
            |\ <- theta = angle between lines
            | \
  direction |  \
            |   \
            v____o returned point
            
  known: angle from some inital vector, y distance from point
  unknown: x distance from point, end coordinates
  
  @param anchor location of inital vector
  @param ray inital vector
  @param theta angle from inital vector, in radians 
  */
  Point getPointOnLine(Vector ray, float theta) {
    float distance = ray.getMagnitude();
    return new Point(this.rawX + distance * tan(theta), this.rawY + ray.y, this.alignment);
  }
}

enum Alignment{
  LEFT, 
  RIGHT
}
