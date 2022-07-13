Node start;
Node goal;
ArrayList<Obstacle> obst;
RRTStarWithGoal liveTest;
float nR;

void setup() {
  fullScreen();
  //size(640, 480);
  colorMode(HSB, 360, 100, 100);
  background(0, 0, 100);
  start = new Node(null);
  goal = new Node(null);
  obst = new ArrayList<Obstacle>();
  for (int i = 0; i < 300; i++) {
    obst.add(new Circle(new PVector(random(width), random(height)), random(30, 60)));
  }

  boolean collide = true;
  while (collide) {
    collide = false;
    start.loc = new PVector(random(width), random(height));
    for (Obstacle o : obst) {
      if (o.collide(start.loc)) {
        collide = true;
        break;
      }
    }
  }
  collide = true;
  while(collide){
   collide = false;
   goal.loc = new PVector(random(width), random(height));
   for(Obstacle o : obst){
     if(o.collide(goal.loc)){
       collide = true;
       break;
     }
   }
  }

  for (Obstacle o : obst) {
   o.display();
  }

  //RRTStar tree1 = new RRTStar(start, obst);
  //tree1.generateRRT(1000, 10, 15);
  //tree1.display();


  //RRT tree2 = new RRT(first, obst);
  //tree2.generateRRT(1000, 10);
  //tree2.display();

  //RRTWithGoal tree3 = new RRTWithGoal(start, goal, obst);
  //tree3.generateRRT(1000, 10);
  //tree3.display();
  //tree3.displayGoalPaths();
  //fill(360, 100, 100);
  //ellipse(start.loc.x, start.loc.y, 10, 10);
  //fill(240, 100, 100);
  //ellipse(goal.loc.x, goal.loc.y, 10, 10);
  //float avgDist, avgTime;
  //int startTime;
  //int endTime;
  //RRTStarWithGoal tree4 = new RRTStarWithGoal(start, goal, obst);
  //tree4.generateRRT(1000, 10, 100);
  //tree4.display();
  //tree4.displayGoalPaths();
  //tree4.displayBestPath();
  ArrayList<Node> starts = new ArrayList<Node>();
  for(int i = 0; i < 5; i++){
    Node n = new Node(null);
    n.loc = new PVector(random(width), random(height));
    starts.add(n);
  }
  //RRTStarMultiStarts tree5 = new RRTStarMultiStarts(starts, goal, obst);
  //tree5.generateRRT(1000, 10, 30);
  //tree5.display();
  //tree5.displayAllPaths();
  //for(int i = 0; i < 20; i++){
  //  avgDist = 0;
  //  avgTime = 0;
  //  for(int j = 0; j < 10; j++){
  //    if(i < 9){
  //      startTime = millis();
  //      tree4.generateRRT(1000, 10, 10.1*(i+1));
  //      endTime = millis();
  //      avgTime += (endTime - startTime)/1000.0;
  //      avgDist += tree4.getShortestDist();
  //    } else{
  //      startTime = millis();
  //      tree4.generateRRT(1000, 10, 100*((i-10)+1));
  //      endTime = millis();
  //      avgTime += (endTime - startTime)/1000.0;
  //      avgDist += tree4.getShortestDist();
  //    }
  //  }
  //  avgDist /= 5.0;
  //  avgTime /= 5.0;
  //  if(i < 10)
  //    println("For neighbor radius: " + 10.1*(i+1) + "\t->\t" + avgDist + " Distance\t" + avgTime + " seconds\t\tRATIO(d/t): " + avgDist*avgTime);
  //  else
  //    println("For neighbor radius: " + 100*((i-10)+1) + "\t->\t" + avgDist + " Distance\t" + avgTime + " seconds\t\tRATIO(d/t): " + avgDist*avgTime);
  //}
  nR = 40;
  //frameRate(10);
}


void draw() {
  background(0, 0, 100);
  
  //PVector rDir = new PVector(random(-1, 1), random(-1, 1));
  //rDir.add(PVector.sub(goal.loc, new PVector(mouseX, mouseY)));
  //rDir.normalize();
  //PVector origGoal = goal.loc;
  //float goalVel = 12.0;
  
  goal.loc = new PVector(mouseX, mouseY);

  liveTest = new RRTStarWithGoal(start, goal, obst);
  liveTest.generateRRT(1000, 20, nR);
  //goal.loc = PVector.add(goal.loc, PVector.mult(rDir, goalVel));
  //if(goal.loc.x > width || goal.loc.x < 0 || goal.loc.y > height || goal.loc.y < 0){
  //  goal.loc = origGoal;
  //}
  strokeWeight(0);
  for (Obstacle o : obst) {
   o.display();
  }
  liveTest.display();
  Node n = liveTest.displayBestPath();
  if (n.prev != null) {
   while (n.prev.prev != null) {
     n = n.prev;
   }
  }
  PVector wayPoint = n.loc;
  PVector dir;
  if (wayPoint == null) {
   dir = new PVector(0, 0);
  } else {
   dir = PVector.sub(wayPoint, start.loc);
   dir.normalize();
  }
  float vel = 20;
  PVector orig = start.loc;
  start.loc = PVector.add(start.loc, PVector.mult(dir, vel));
  if (liveTest.checkAllCollisions(start.loc)) {
   start.loc = orig;
  }
  fill(240, 100, 100);
  strokeWeight(0);
  ellipse(goal.loc.x, goal.loc.y, 20, 20);
  fill(360, 100, 50);
  ellipse(start.loc.x, start.loc.y, 20, 20);



  println(frameRate);
}