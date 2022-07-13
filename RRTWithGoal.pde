class RRTWithGoal extends RRT{
  Circle goalArea;
  Node goal;
  RRTWithGoal(Node start, Node goal, ArrayList<Obstacle> obst){
    super(start, obst);
    this.goal = goal;
    goalArea = new Circle(goal.loc, 20);
  }
  
  void generateRRT(int iterations, float stepSize) {
    for (int i = 0; i < iterations-1; i++) {
      PVector q_rand = new PVector(random(width), random(height));
      if(floor(random(10)) == 0){
        q_rand = goal.loc;
      }
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
  
  void displayGoalPaths(){
    for(Node n : net){
      if(goalArea.collide(n.loc)){
        n.displayBackPath();
      }
    }
  }
  
  boolean seeGoal(PVector loc){
    return !checkAllCollisions(loc, goal.loc);
  }
  
  Node displayBestPath(){
    Node best = new Node(null);
    float shortestDist = MAX_FLOAT;
    for(Node n : net){
      if(goalArea.collide(n.loc)){
        if(n.distToRoot() < shortestDist){
          shortestDist = n.distToRoot();
          best = n;
        }
      }
    }
    strokeWeight(5);
    best.displayBackPath();
    return best;
  }
  
  float getShortestDist(){
    float shortestDist = MAX_FLOAT;
    for(Node n : net){
      if(goalArea.collide(n.loc)){
        if(n.distToRoot() < shortestDist){
          shortestDist = n.distToRoot();
        }
      }
    }
    return shortestDist;
  }
  
  void display(){
    super.display();
    goalArea.display(color(240, 100, 100));
  }
  
}