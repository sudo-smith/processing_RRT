class RRT {
  ArrayList<Node> net;
  ArrayList<Obstacle> obst;
  RRT(Node start, ArrayList<Obstacle> obst) {
    this.obst = obst;
    net = new ArrayList<Node>();
    net.add(start);
  }

  boolean checkAllCollisions(PVector p) {
    for (Obstacle o : obst) {
      if (o.collide(p)) {
        return true;
      }
    }
    return false;
  }

  boolean checkAllCollisions(PVector s, PVector e) {
    for (Obstacle o : obst) {
      if (o.collide(s, e)) {
        return true;
      }
    }
    return false;
  }

  void generateRRT(int iterations, float stepSize) {
    for (int i = 0; i < iterations-1; i++) {
      PVector q_rand = new PVector(random(width), random(height));
      float nearDist = MAX_FLOAT;
      Node q_near = null;
      for (Node n : net) {
        if (dist(q_rand.x, q_rand.y, n.loc.x, n.loc.y) < nearDist) {
          q_near = n;
          nearDist = dist(q_rand.x, q_rand.y, n.loc.x, n.loc.y);
        }
      }
      Node q_new = new Node(q_near);
      if (dist(q_rand.x, q_rand.y, q_near.loc.x, q_near.loc.y) <= stepSize) {
        q_new.loc = q_rand;
      } else {
        PVector dir = PVector.sub(q_rand, q_near.loc);
        dir.normalize();
        q_new.loc = PVector.add(q_near.loc, PVector.mult(dir, stepSize));
      }
      if (checkAllCollisions(q_new.loc, q_new.prev.loc)) {
        i--;
        continue;
      }
      net.add(q_new);
    }
  }

  void display() {
    
    for (Node n : net) {
      n.display();
    }
    fill(360, 100, 100);
    ellipse(net.get(0).loc.x, net.get(0).loc.y, 10, 10);
  }
  
  
  
  void display(color c){
    for (Node n : net) {
      n.display(c);
    }
  }
}