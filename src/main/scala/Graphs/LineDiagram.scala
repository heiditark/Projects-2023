package Graphs
import javafx.scene.shape._


object LineDiagram extends Graph {

  val heightOfUI = 450
  val widthOfUI = 1000

  // Test dataPoints
  val dataPoints = Map((0 -> 100), (100 -> 200), (200 -> 300), (300 -> 400), (350 -> 175))

  // Arranged data points
  var arrangedDataPoints = arrangeDataPoints(dataPoints)

  // Sorts the data points in ascending order by x-coordinate and adds them in a vector
  def arrangeDataPoints(dataPoints: Map[Int, Int]) = dataPoints.toVector.sortWith(_._1 < _._1)

  // Arranged and autoscaled data points
  val autoscaledDataPoints = autoscale(arrangedDataPoints)


  // Autoscales datapoints to fit the measures of the Interface
  def autoscale(data: Vector[(Int, Int)]) = {

    // Scaling factor
    val scaleXBy = widthOfUI.toDouble / (arrangedDataPoints.last._1 - arrangedDataPoints.head._1).toDouble
    val scaleYBy = heightOfUI.toDouble / (arrangedDataPoints.maxBy(_._2)._2 - arrangedDataPoints.minBy(_._2)._2).toDouble
    val scale = if(scaleXBy < scaleYBy) scaleXBy else scaleYBy

    println(scale)

    val autoScaledData = new Array[(Double, Double)](data.length)

    // Puts the smallest datapoint on the very left
    autoScaledData(0) = (data(0)._1 * 0, (data(0)._2 * scale))

    for(i <- 1 until data.length) {
      autoScaledData(i) = (data(i)._1 * scale, (data(i)._2 * scale))
      println(autoScaledData(i))
    }
    autoScaledData.toVector
  }

  // Adds lines in scalafx
  def doLines() = {
    var lines = new Array[javafx.scene.Node](autoscaledDataPoints.length - 1)
    for( index <- autoscaledDataPoints.drop(1).indices ) {
      var line = new Line {
        setStartX(autoscaledDataPoints(index)._1)
        setStartY(autoscaledDataPoints(index)._2)
        setEndX(autoscaledDataPoints(index + 1)._1)
        setEndY(autoscaledDataPoints(index + 1)._2)
      }
      lines(index) = line
    }
    lines
  }

  // Makes dots in scalafx with radius of 5
  def doDots(): Array[javafx.scene.Node] = {
    var circles = new Array[javafx.scene.Node](autoscaledDataPoints.length)
    for( index <- autoscaledDataPoints.indices ) {
      var circle = new Circle {
        setCenterX(autoscaledDataPoints(index)._1)
        setCenterY(autoscaledDataPoints(index)._2)
        setRadius(5)
      }
      circles(index) = circle
    }
    circles
 }


// (autoScaledData(i - 1)._1 + ((data(i)._1 - data(i - 1)._1) * scale), (autoScaledData(i - 1)._2 + ((data(i)._2 - data(i - 1)._2)) * scale))

}

