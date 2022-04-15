package Graphs
import javafx.scene.shape._
import scalafx.scene.paint.Color

import scala.math.pow


object LineDiagram extends Graph {

  var colorDots = Color.Black
  var colorLines = Color.Black
  var sizing = 1.0
  def widthUI2 = widthOfUI * sizing
  def heightUI2 = heightOfUI * sizing


  // Test dataPoints
  val dataPoints: Map[Double, Double] = //Map((-3.0 -> 2.0), (2.0 -> 5.0), (10.0 -> -11.0), (-12.0, 4.0))
   // Map((0.0 -> 100.0), (100.0 -> 200.0), (200.0 -> 300.0), (300.0 -> 400.0), (350.0 -> 175.0), (-50.0, 80.0))
    Map((9.8 -> 100.0), (13.4 -> -10.0), (76.3 -> 62.3), (300.0 -> 400.0), (-69.0 -> 175.0), (-50.0, 80.0))

  //Flips the y-coordinates
  def flipYCoord(dataPoints2: Map[Double, Double]): Map[Double, Double] = dataPoints2.map{case (x, y) => x -> y * -1}

  // Sorts the data points in ascending order by x-coordinate and adds them in a vector
  def arrangeDataPoints(dataPoints2: Map[Double, Double]) = dataPoints2.toVector.sortWith(_._1 < _._1)

  def yCoordsFlipped = flipYCoord(dataPoints)
  def arrangedDataPoints = arrangeDataPoints(yCoordsFlipped)
  def autoscaledDataPoints = autoscale(arrangedDataPoints)

  // Nää vaa prinnttaa
  println(dataPoints.toVector.sortBy(a => a._1))
  println(autoscaledDataPoints)

  def scalingFactor() = {

    // Scaling factor
    val scaledByX = widthUI2 / (arrangedDataPoints.last._1 - arrangedDataPoints.head._1)
    val scaledByY = heightUI2 / (arrangedDataPoints.maxBy(_._2)._2 - arrangedDataPoints.minBy(_._2)._2)
    val scale = if(scaledByX < scaledByY) scaledByX else scaledByY

    scale
  }

  // Autoscales datapoints to fit the measures of the Interface
  def autoscale(data: Vector[(Double, Double)]): Vector[(Double, Double)] = {
    val scale = scalingFactor()
    val firstY = arrangedDataPoints.minBy(_._2)._2 match {
      case a if a == arrangedDataPoints(0)._2 && a > 0 => 0
      case a if a == arrangedDataPoints(0)._2 && a < 0 => heightUI2
      case a => (arrangedDataPoints(0)._2 - a) * scale
    }


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

  // Adds lines in scalafx
  def doLines() = {
    //sizePercent = size / 100.0
    var lines = new Array[javafx.scene.Node](autoscaledDataPoints.length - 1)
    for( index <- autoscaledDataPoints.drop(1).indices ) {
      var line = new Line {
        setStartX(autoscaledDataPoints(index)._1)
        setStartY(autoscaledDataPoints(index)._2)
        setEndX(autoscaledDataPoints(index + 1)._1)
        setEndY(autoscaledDataPoints(index + 1)._2)
        setStroke(colorLines)
      }
      lines(index) = line
    }
    lines
  }

  // Makes dots in scalafx with radius of 5
  def doDots(): Array[javafx.scene.Node] = {
    var circles = new Array[javafx.scene.Node](autoscaledDataPoints.length)
    for(index <- autoscaledDataPoints.indices) {
      var circle = new Circle {
        setCenterX(autoscaledDataPoints(index)._1)
        setCenterY(autoscaledDataPoints(index)._2)
        setRadius(5)
        setFill(colorDots)
      }
      circles(index) = circle
    }
    circles
  }

  def xAxisYPos(): Double = {
    val pointClosest0: (Double, Double) = arrangedDataPoints.minBy{case (x,y) => y.abs}
    val diff: Double = (0.0 - pointClosest0._2) * scalingFactor()
    val yPos = autoscaledDataPoints(arrangedDataPoints.indexOf(pointClosest0))._2 + diff

    yPos
  }

  def yAxisXPos() = {
    val pointClosest0: (Double, Double) = arrangedDataPoints.minBy{case (x,y) => x.abs}
    val diff: Double = (0.0 - pointClosest0._1) * scalingFactor()
    val xPos = autoscaledDataPoints(arrangedDataPoints.indexOf(pointClosest0))._1 + diff

    xPos
  }



  def addPosYStamps(xAxisYPos: Double, step: Double, yAxisXPos: Double, n: Int): Array[javafx.scene.Node] = {
    var stamps: Array[(Double, Double)] = new Array[(Double, Double)]((xAxisYPos / step).toInt)

    for(index <- 0 until (xAxisYPos / step).toInt) {
      val text = roundOneDecimal(index) //0.0
      val coord = xAxisYPos - step * index //xAxisYPos

      stamps(index) = (text, coord)
    }

    val everyN: Array[(Double, Double)] = stamps.zipWithIndex.filter{case (y, index) => index%n == 0}.map(a => a._1)

    val text: Array[javafx.scene.Node] = everyN.map(x => addTextMiddle(x._1.toString,(yAxisXPos - 20, x._2 - fontSize / 2)))
    val line: Array[javafx.scene.Node] = everyN.map(x => addStampLine(yAxisXPos - 5, x._2, yAxisXPos + 5, x._2))

    text ++ line
  }

  def addNegYStamps(xAxisYPos: Double, step: Double, yAxisXPos: Double, n: Int) = {
    var length = if(heightOfUI - xAxisYPos <= 0) 0 else ((heightOfUI - xAxisYPos) / step).toInt
    var stamps: Array[(Double, Double)] = new Array[(Double, Double)](length)

    for(index <- 0 until length) {
      val distance = - (heightOfUI - xAxisYPos) * 1 / step
      val text = roundOneDecimal(distance + index)
      val coord = heightOfUI - step * index

      stamps(index) = (text, coord)
    }
    var text: Array[javafx.scene.Node] = Array[javafx.scene.Node]()
    var line: Array[javafx.scene.Node] = Array[javafx.scene.Node]()
    length match {
      case a if a > 0 =>
        val everyN: Array[(Double, Double)] = stamps.zipWithIndex.filter{case (y, index) => index%n == 0}.map(a => a._1)
        text = everyN.map(x => addTextMiddle(x._1.toString,(yAxisXPos - 20, x._2 - fontSize / 2)))
        line = everyN.map(x => addStampLine(yAxisXPos - 5, x._2, yAxisXPos + 5, x._2))
      case _ => println("Negatiivisella x-akseli")
    }

    text ++ line
  }

  def grid: Array[javafx.scene.Node] = addGridVertical(autoscaledDataPoints.minBy{case (x,y) => y}._2, scalingFactor()) ++ addGridHorizontal(autoscaledDataPoints(0)._1, scalingFactor())
  def axis: Array[javafx.scene.Node] = addAxis(yAxisXPos(), xAxisYPos())
  def stamps: Array[javafx.scene.Node] = addPosYStamps(xAxisYPos(),
    scalingFactor(), yAxisXPos(), 40) ++ addNegYStamps(xAxisYPos(),
    scalingFactor(), yAxisXPos(), 40)


}

