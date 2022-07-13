class Node {
  Node prev;
  PVector loc;
  Node(Node prev) {
    this.prev = prev;
  }

  void display() {
    fill(0);
    stroke(0);
    ellipse(loc.x, loc.y, 2, 2);
    if (prev != null) {
      line(loc.x, loc.y, prev.loc.x, prev.loc.y);
    }
  }
  
  void display(color c){
    fill(c);
    stroke(c);
    ellipse(loc.x, loc.y, 2, 2);
    if (prev != null) {
      line(loc.x, loc.y, prev.loc.x, prev.loc.y);
    }
  }
  
  void displayBackPath(){
    displayBackPath(this);
  }
  
  void displayBackPath(Node n){
    if(n.prev != null){
      n.display(color(360, 100, 100));
      displayBackPath(n.prev);
    }
  }


  float distToRoot() {
    return distToRoot(this, 0);
  }

  private float distToRoot(Node n, float dist) {
    if (n.prev != null) {
      dist += dist(n.loc.x, n.loc.y, n.prev.loc.x, n.prev.loc.y);
      return distToRoot(n.prev, dist);
    }
    return dist;
  }
}