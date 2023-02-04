package Graphs

import javafx.scene.shape.{Line, Rectangle}
import scalafx.scene.paint.Color
import scala.math.pow

object BarCharProject extends Graph {

  var data: Option[Map[String, Double]] = None

  var title = ""
  var titleY = "y"
  var color = Color.Black
  val yAxis = 30.0
  val xAxis = heightOfUI - 30
  var gridSize = 12
  var matchGridAndStamps = Array[Double]()

  // Set location of each bar so that the graph will appear at the middle of x-axis and so that there is a gap between each bar
  def locationInInterface(key: String) = {
    val index = data.get.keys.toVector.indexOf(key)
    val gap = 30
    val firstXPos = widthOfUI / 2 - width * data.get.size / 2 - gap

    val x = index match {
      case i: Int if index == 0 => firstXPos
      case _: Int =>  (width + gap) * index + firstXPos
    }
    val y = heightOfUI - height(key) - gap

    (x, y)
  }

  //Each bar has equal width
  def width = if(widthOfUI - 30 - (80 + 30) * data.get.size > 0) 80 else (widthOfUI * 1 / 2) / data.get.size

  //Set height of a bar so that key with biggest value has the biggest height. Other bars are made by scaling to the bar of biggest height.
  def height(key: String): Double = {
    val biggestValue: (String, Double) = data.get.maxBy(_._2)
    var height = data.get(key) match {
      case _ if data.get(key) == biggestValue._2 => heightOfUI - 70
      case a: Double => (heightOfUI - 70) * (a / biggestValue._2)
    }
    height
  }


  //Make bars and title below each bar using the methods above
  def doBars(): Array[javafx.scene.Node] = {
    if(data.isEmpty) throw new Exception("File Corrupted.")
    val size = data.get.size

    var bars = new Array[javafx.scene.Node](size)
    var textBoxes = new Array[javafx.scene.Node](size)
    var index = 0

    for(key <- data.get.keys) {
      var bar = new Rectangle {
        setX(locationInInterface(key)._1)
        setY(locationInInterface(key)._2)
        setWidth(width)
        setHeight(height(key))
        setStroke(Color.White)
        setStrokeWidth(2)
        setFill(color)
      }
      bars(index) = bar
      textBoxes(index) = addTextMiddle(key, (locationInInterface(key)._1 + width / 2, 575))

      index += 1
    }
    bars ++ textBoxes
  }

  // Make horizontal grid lines using gridSize
  def addGrid(stampsCoord: Array[Double]) = {
    var gridLines: Array[javafx.scene.Node] = new Array[javafx.scene.Node](stampsCoord.length)

    for(index <- stampsCoord.indices) {
      val yCoord = stampsCoord(index)
      var line = new Line() {
        setStartX(yAxis)
        setStartY(yCoord)
        setEndX(widthOfUI + 100)
        setEndY(yCoord)
        setStroke(Color.rgb(230, 230, 230))
      }
      gridLines(index) = line
    }
    gridLines
  }

  // Add count of each key above each bar
  def info(): Array[javafx.scene.Node] = {
    var textBoxes = new Array[javafx.scene.Node](data.get.size)
    var index = 0

    for(key <- data.get.keys) {
      val text = data.get(key).toString
      textBoxes(index) = addTextMiddle(text, (locationInInterface(key)._1 + width / 2, locationInInterface(key)._2 - 25))

      index += 1
    }
    textBoxes
  }

  // Add stamps on y-axis by using gridSize
  def addStampsOnY(): Unit = {
    val countOfStamps = (xAxis / gridSize).toInt
    val valueHeight = data.get.map(og => og._2 -> height(og._1)).toVector.sortBy{case (x, height) => x}
    val scale = pow((valueHeight.last._2 - valueHeight.head._2) / (valueHeight.last._1 - valueHeight.head._1), -1)
    var stamps: Array[(Double, Double)] = new Array[(Double, Double)](countOfStamps)

    for(index <- 0 until countOfStamps) {
      val text = roundOneDecimal(index * countOfStamps * scale)
      val coord = xAxis - index * countOfStamps

      stamps(index) = (text, coord)
    }

    // To match gridLines to stamps
    matchGridAndStamps = stamps.map(_._2)

    val text: Array[javafx.scene.Node] = stamps.map(x => addTextMiddle(x._1.toString,(yAxis - 20, x._2 - fontSize / 2)))
    val line: Array[javafx.scene.Node] = stamps.map(x => addStampLine(yAxis - 5, x._2, yAxis + 5, x._2))

    stampsOnY = text ++ line
  }

  var stampsOnY = Array[javafx.scene.Node]()
  val axis = addAxis(yAxis, xAxis)
  def grid = addGrid(matchGridAndStamps)
  def addTitle = addGraphTitle(title, (widthOfUI / 2, 10))
  def addTitleY: javafx.scene.Node = addGraphTitleY(yAxis, titleY)

}
