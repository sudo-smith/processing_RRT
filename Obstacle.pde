abstract class Obstacle {
  PVector loc;
  abstract void display();
  abstract void display(color c);
  abstract boolean collide(PVector s, PVector e);
  abstract boolean collide(PVector p);
}

class Circle extends Obstacle {
  float r;
  Circle(PVector loc, float d) {
    this.r = d/2.0;
    this.loc = loc;
  }
  void display() {
    fill(0, 100, 0);
    ellipse(loc.x, loc.y, r*2, r*2);
  }
  
  void display(color c){
    fill(c);
    ellipse(loc.x, loc.y, r*2, r*2);
  }
  
  boolean collide(PVector p) {
    return (dist(p.x, p.y, loc.x, loc.y) < r);
  }
  boolean collide(PVector sLoc, PVector eLoc) {
    PVector d = PVector.sub(eLoc, sLoc);
    PVector e = sLoc;
    PVector c = loc;
    float vR = r;
    float dis = sq(PVector.dot(d, PVector.sub(e, c))) - ((PVector.dot(d, d) * (PVector.dot(PVector.sub(e, c), PVector.sub(e, c)) - sq(vR))));  
    if (dis < 0) {
      return false;
    }
    float t_1 = (PVector.dot(PVector.mult(d, -1), PVector.sub(e, c)) + sqrt(dis)) / PVector.dot(d, d);
    if (t_1 > 0 && t_1 < 1) {
      return true;
    }
    float t_2 = (PVector.dot(PVector.mult(d, -1), PVector.sub(e, c)) - sqrt(dis)) / PVector.dot(d, d);
    if (t_2 > 0 && t_2 < 1) {
      return true;
    }
    return false;
  }
}