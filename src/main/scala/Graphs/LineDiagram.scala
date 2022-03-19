package Graphs
import javafx.scene.shape._


object LineDiagram extends Graph {

  // Test dataPoints
  val dataPoints = Map((0 -> 100), (100 -> 200), (200 -> 300))

  // Arranged data points
  var arrangedDataPoints = arrangeDataPoints(dataPoints)

  // Sorts the data points in ascending order by x-coordinate and adds them in a vector
  def arrangeDataPoints(dataPoints: Map[Int, Int]) = dataPoints.toVector.sortWith(_._1 < _._1)

  // Adds lines in scalafx
  def doLines() = {
    for( index <- arrangedDataPoints.drop(1).indices ) {
      var line = new Line()
      line.setStartX( arrangedDataPoints(index)._1 )
      line.setStartY( arrangedDataPoints(index)._2 )
      line.setEndX( arrangedDataPoints(index + 1)._1 )
      line.setEndY( arrangedDataPoints(index + 1)._2 )
    }
  }

  // Makes dots in scalafx with radius of 10
  def doDots(): Array[javafx.scene.Node] = {
    var circles = new Array[javafx.scene.Node](arrangedDataPoints.length)
    for( index <- arrangedDataPoints.indices ) {
      var circle = new Circle {
        setCenterX(arrangedDataPoints(index)._1)
        setCenterY(arrangedDataPoints(index)._2)
        setRadius(10)
      }
      circles(index) = circle
    }
    circles
}


}

