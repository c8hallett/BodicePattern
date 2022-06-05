final Vector xAxis = new Vector(1, 0);
final Vector yAxis = new Vector(0, 1);

class Vector {
  public float x = 0;
  public float y = 0;
  
  public Vector(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  float getMagnitude() {
     return sqrt(sq(x) + sq(y)); 
  }
  
  @Override 
  String toString() {
    return "<" + x + ", " + y + ">";
  }
  
  Vector scale(float newMagnitude) {
    float currentMagnitude = getMagnitude();
    return new Vector(x * newMagnitude/currentMagnitude, y * newMagnitude/currentMagnitude);
  }
  
  Vector rotate(float theta) {
    float rotatedX = cos(theta) * x - sin(theta) * y;
    float rotatedY = sin(theta) * x + cos(theta) * y;
    
    return new Vector(rotatedX, rotatedY);
  }
}
  
