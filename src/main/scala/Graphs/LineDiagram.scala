package Graphs
import javafx.scene.shape._


object LineDiagram extends Graph {

  val heightOfUI = 600
  val widthOfUI = 1000
  val color = colorGenerator()

  // Test dataPoints
  val dataPoints:Map[Double,Double] = Map((-3.0 -> 2.0), (2.0 -> 5.0), (10.0 -> -11.0), (-12.0, 4.0))
   // Map((0.0 -> 100.0), (100.0 -> 200.0), (200.0 -> 300.0), (300.0 -> 400.0), (350.0 -> 175.0), (-50.0, 80.0))

  //Flips the y-coordinates
  def flipYCoord(dataPoints2: Map[Double, Double]): Map[Double, Double] = dataPoints2.map{case (x, y) => x -> y * -1}

  // Sorts the data points in ascending order by x-coordinate and adds them in a vector
  def arrangeDataPoints(dataPoints2: Map[Double, Double]) = dataPoints2.toVector.sortWith(_._1 < _._1)

  val yCoordsFlipped = flipYCoord(dataPoints)
  val arrangedDataPoints = arrangeDataPoints(yCoordsFlipped)
  val autoscaledDataPoints = autoscale(arrangedDataPoints)

  // Nää vaa prinnttaa
  println(arrangedDataPoints)
  println(autoscaledDataPoints)

  def scalingFactor() = {
    // Scaling factor
    val scaledByX = widthOfUI.toDouble / (arrangedDataPoints.last._1 - arrangedDataPoints.head._1)
    val scaledByY = heightOfUI.toDouble / (arrangedDataPoints.maxBy(_._2)._2 - arrangedDataPoints.minBy(_._2)._2)
    val scale = if(scaledByX < scaledByY) scaledByX else scaledByY

    scale
  }

  // Autoscales datapoints to fit the measures of the Interface
  def autoscale(data: Vector[(Double, Double)]): Vector[(Double, Double)] = {
    val scale = scalingFactor()
    val firstY = arrangedDataPoints.minBy(_._2)._2 match {
      case a if a == arrangedDataPoints(0)._2 && a > 0 => 20
      case a if a == arrangedDataPoints(0)._2 && a < 0 => heightOfUI
      case a => (arrangedDataPoints(0)._2 - a) * scale  - 20
    }

    println(scale)

    val autoScaledData = new Array[(Double, Double)](data.length)

    // Puts the smallest datapoint on the very left
    autoScaledData(0) = (20, firstY)

    for(i <- 1 until data.length) {
      autoScaledData(i) =
        (autoScaledData(i - 1)._1 + ((arrangedDataPoints(i)._1 - arrangedDataPoints(i - 1)._1) * scale).abs,
          (autoScaledData(i - 1)._2 + ((arrangedDataPoints(i)._2 - arrangedDataPoints(i - 1)._2)) * scale).abs)
    }
    autoScaledData.toVector
  }

  def xAxisYPos() = {
    val pointClosest0: (Double, Double) = arrangedDataPoints.minBy{case (x,y) => y.abs}
    val diff: Double = (0.0 - pointClosest0._2) * scalingFactor()
    val yPos = autoscaledDataPoints(arrangedDataPoints.indexOf(pointClosest0))._2 + diff

    yPos
  }

  def yAxisXPos() = {
    val pointClosest0: (Double, Double) = arrangedDataPoints.minBy{case (x,y) => x.abs}
    val diff: Double = (0.0 - pointClosest0._1) * scalingFactor()
    val yPos = autoscaledDataPoints(arrangedDataPoints.indexOf(pointClosest0))._1 + diff

    yPos
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
        setFill(color)
      }
      circles(index) = circle
    }
    circles
  }

  def doAxis() = {
    val axis = new Array[javafx.scene.Node](2)

    //x
    axis(0) = new Line {
      setStartX(0)
      setStartY(xAxisYPos())
      setEndX(widthOfUI + 100)
      setEndY(xAxisYPos())
    }

    //y
    axis(1) = new Line {
      setStartX(yAxisXPos())
      setStartY(0)
      setEndX(yAxisXPos())
      setEndY(heightOfUI + 100)
    }
    axis
  }

}

