class RRTStarMultiStarts extends RRTStarWithGoal{
  ArrayList<Node> starts;
  ArrayList<Circle> goalAreas;
  Node goal;
  RRTStarMultiStarts(ArrayList<Node> starts, Node goal, ArrayList<Obstacle> obst){
    super(starts.get(0), goal, obst);
    this.starts = starts;
    this.goal = goal;
    net.remove(0);
    net.add(goal);
    goalAreas = new ArrayList<Circle>();
    for(Node s : starts){
      goalAreas.add(new Circle(s.loc, 20));
    }
  }
  
  void generateRRT(int iterations, float stepSize, float nR){
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
      Node temp = q_near;
      for (Node n : net) {
        if (dist(n.loc.x, n.loc.y, q_new.loc.x, q_new.loc.y) < nR) {
          if (n.distToRoot() < shortestDist) {
            boolean collide = false;
            if(!checkAllCollisions(q_new.loc, n.loc)){
              shortestDist = n.distToRoot();
              temp = n;
            }
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
  
  void displayAllPaths(){
    ArrayList<Node> bests = new ArrayList<Node>();
    for(Circle g : goalAreas){
      for(Node n : net){
        if(g.collide(n.loc)){
          bests.add(n);
        }
      }
    }
    for(Node b : bests){
      b.displayBackPath();
    }
  }
}