class RRTStar extends RRT {
  RRTStar(Node start, ArrayList<Obstacle> obst) {
    super(start, obst);
  }

  void generateRRT(int iterations, float stepSize, float nR) {
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
      float shortestDist = MAX_FLOAT;
      Node temp = new Node(null);
      for (Node n : net) {
        if (dist(n.loc.x, n.loc.y, q_new.loc.x, q_new.loc.y) < nR) {
          if (n.distToRoot() < shortestDist) {
            shortestDist = n.distToRoot();
            temp = n;
          }
        }
      }
      q_new.prev = temp;
      if (checkAllCollisions(q_new.loc, q_new.prev.loc)) {
        i--;
        continue;
      }
      net.add(q_new);
    }
  }
}