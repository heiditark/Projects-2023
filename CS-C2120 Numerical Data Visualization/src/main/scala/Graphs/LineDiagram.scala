package Graphs

import javafx.scene.shape._
import scalafx.scene.paint.Color


object LineDiagram extends Graph {

  // Defined as none until a file is added through UI
  var data: Option[Map[String, Double]] = None

  var titleY = "y"
  var titleX = "x"
  var colorDots = Color.Black
  var colorLines = Color.White

  // Sizing defined at first so that the graph will fill the pane fully
  var sizing = 1.0

  // GidSize defined at first
  var gridSize = 50

  // Change scaling depending on sizing
  def widthUI2 = widthOfUI * sizing
  def heightUI2 = heightOfUI * sizing

  // Change count of gridLines so that stamps won't overlap
  def n = gridSize match {
    case a if a > 35 => 1
    case a if a >= 20 => 2
    case a if a == 15 => 3
    case _ => 4
  }

  // Keep modified data saved
  var arrangedDataPoints = Vector[(Double, Double)]()
  var autoscaledDataPoints = Vector[(Double, Double)]()

  // Flip the y-coordinates and sorts the data points in ascending order by x-coordinate
  def flipYCoordAndArrange() = {
    if(data.isEmpty) throw new Exception("Data Corrupted.")

    val yFlipped = data.get.map(xy => xy._1.toDouble -> xy._2).map{case (x, y) => x -> y * -1}
    val arranged = yFlipped.toVector.sortWith(_._1 < _._1)

    arrangedDataPoints = arranged
  }

  // Define a scaling factor so that the datapoints fills UI fully
  def scalingFactor() = {
    val scaledByX = widthUI2 / (arrangedDataPoints.last._1 - arrangedDataPoints.head._1)
    val scaledByY = heightUI2 / (arrangedDataPoints.maxBy(_._2)._2 - arrangedDataPoints.minBy(_._2)._2)
    val scale = if(scaledByX < scaledByY) scaledByX else scaledByY

    scale
  }

  // Autoscale datapoints to fit the measures of the Interface
  def autoscale() = {
    val scale = scalingFactor()
    val firstY = arrangedDataPoints.minBy(_._2)._2 match {
      case a if a == arrangedDataPoints(0)._2 && a > 0 => 0
      case a if a == arrangedDataPoints(0)._2 && a < 0 => heightUI2
      case a => (arrangedDataPoints(0)._2 - a) * scale
    }
    val firstX = arrangedDataPoints(0)._1 match {
      case a if a <= 0 => 0
      case a if a > 0 => arrangedDataPoints(0)._1 * scale
    }

    val autoScaledData = new Array[(Double, Double)](arrangedDataPoints.length)

    // Put the smallest datapoint on the very left
    autoScaledData(0) = (firstX, firstY)

    for(i <- 1 until arrangedDataPoints.length) {
      autoScaledData(i) =
        (autoScaledData(i - 1)._1 + ((arrangedDataPoints(i)._1 - arrangedDataPoints(i - 1)._1) * scale).abs,
          (autoScaledData(i - 1)._2 + ((arrangedDataPoints(i)._2 - arrangedDataPoints(i - 1)._2)) * scale).abs)
    }
    autoscaledDataPoints = autoScaledData.toVector
  }

  // Make lines in scalafx
  def doLines() = {
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

  // Make dots in scalafx with radius of 5
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

  // Define y pos of x-axis
  def xAxisYPos(): Double = {
    val pointClosest0: (Double, Double) = arrangedDataPoints.minBy{case (x,y) => y.abs}
    val diff: Double = (0.0 - pointClosest0._2) * scalingFactor()
    val yPos = autoscaledDataPoints(arrangedDataPoints.indexOf(pointClosest0))._2 + diff

    yPos
  }

  // Define x pos of y-axis
  def yAxisXPos() = {
    val pointClosest0: (Double, Double) = arrangedDataPoints.minBy{case (x,y) => x.abs}
    val diff: Double = (0.0 - pointClosest0._1) * scalingFactor()
    val xPos = autoscaledDataPoints(arrangedDataPoints.indexOf(pointClosest0))._1 + diff

    xPos
  }

  // Make stamps and grid lines match x or y axis
  def startYStamp = (xAxisYPos() / gridSize) * gridSize - (xAxisYPos() / gridSize).floor * gridSize
  def startXStamp = (yAxisXPos() / gridSize) * gridSize - (yAxisXPos() / gridSize).floor * gridSize

  // Make stamps on y-axis
  def addYStamps(step: Double, yAxisXPos: Double, n: Int): Array[javafx.scene.Node] = {
    var stamps: Array[(Double, Double)] = new Array[(Double, Double)]((heightOfUI / step).toInt + 2)

    val biggestY = data.get.maxBy{case (x,y) => y}._2
    val diff: Double = autoscaledDataPoints.minBy{case (x,y) => y}._2
    val text1: Double = roundOneDecimal(biggestY + diff * 1 / scalingFactor())

    stamps(0) = (text1, 0)

    for(index <- 0 to (heightOfUI / step).toInt) {
      val text: Double = roundOneDecimal(biggestY + (diff - startYStamp) * 1 / scalingFactor() - index * step / scalingFactor())
      val coord = startYStamp + step * index

      stamps(index + 1) = (text, coord)
    }

    // Fix largest y stamps not to overlap
    if((stamps(0)._2 - stamps(1)._2).abs < 20) stamps = stamps.tail

    stamps = everyN(stamps, n)

    // Add origin
    if(stamps.indexWhere(a => a._1 == 0.0) == -1) stamps = stamps :+ (0.0, xAxisYPos())

    // Chose the side of y-axis on which the text will be inserted
    var yStampsSide = if((arrangedDataPoints(0)._1 - yAxisXPos).abs >= 20 || arrangedDataPoints(0)._1 > 0) 20 else -20

    val text: Array[javafx.scene.Node] = stamps.map(x => addTextMiddle(x._1.toString,(yAxisXPos + yStampsSide, x._2 - fontSize / 2)))
    val line: Array[javafx.scene.Node] = stamps.map(x => addStampLine(yAxisXPos - 5, x._2, yAxisXPos + 5, x._2))

    text ++ line
  }


  // Make stamps on x-axixs
  def addXStamps(step: Double, xAxisYPos: Double,  n: Int): Array[javafx.scene.Node] = {
    var stamps: Array[(Double, Double)] = new Array[(Double, Double)]((widthOfUI / step).toInt + 2)

    val firstX = if(arrangedDataPoints(0)._1 >= 0) 0.0 else arrangedDataPoints(0)._1
    val text1: Double = roundOneDecimal(firstX)
    stamps(0) = (text1, 0)

    for(index <- 0 to (widthOfUI / step).toInt) {
      val text = roundOneDecimal(firstX + (startXStamp + index * step ) / scalingFactor())
      val coord = startXStamp + step * index

      stamps(index + 1) = (text, coord)
    }

    // Fixe smallest x stamps not to overlap
    if((stamps(0)._2 - stamps(1)._2).abs < 25) stamps = stamps.tail

    stamps = everyN(stamps, n)

    // Remove stamp at origin so that stamps won't overlap
    stamps = stamps.filterNot(a => a._1 == 0.0)

    val text: Array[javafx.scene.Node] = stamps.map(x => addTextMiddle(x._1.toString, (x._2, xAxisYPos)))
    val line: Array[javafx.scene.Node] = stamps.map(x => addStampLine(x._2,  xAxisYPos - 5, x._2, xAxisYPos + 5))

    text ++ line
  }

  def grid: Array[javafx.scene.Node] = addGridVertical(yAxisXPos(), gridSize) ++ addGridHorizontal(xAxisYPos(), gridSize)
  def axis: Array[javafx.scene.Node] = addAxis(yAxisXPos(), xAxisYPos())
  def stamps: Array[javafx.scene.Node] = addYStamps(gridSize, yAxisXPos(), n) ++ addXStamps(gridSize, xAxisYPos(), n)
  def addTitleY = addGraphTitleY(yAxisXPos(), titleY)
  def addTitleX = addGraphTitleX(xAxisYPos(), titleX)


}

