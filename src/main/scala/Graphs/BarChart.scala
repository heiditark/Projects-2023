package Graphs

import javafx.scene.shape.{Line, Rectangle}
import scalafx.scene.paint.Color

object BarCharProject extends Graph {

  var data: Option[Map[String, Double]] =  //Map(("Car" -> 7), ("Bike" -> 6), ("Bus" -> 8), ("Train" -> 21), ("Metro" -> 17))
 // Map(("Car" -> 10), ("Bike" -> 20), ("Bus" -> 50), ("Train" -> 19), ("Metro" -> 4),("Airplane" -> 54))
  // Map(("Maanantai" -> 100), ("Tiistai" -> 120), ("Keskiviikko" -> 103), ("Torstai" -> 70), ("Perjantai" -> 23), ("Lauantai" -> 85), ("Sunnuntai" -> 180))
   None

  var title = "Test"
  var titleY = "y"
  var color = Color.Black
  val heightOfUI2 = heightOfUI - 30
  val yAxis = 30.0
  val xAxis = 570.0
  var n = 0.0

  def defineN() = {
    val sorted = data.get.toVector.sortBy(_._2).map(a => a._2)
    var diffs = Vector[Double]()
    for (index <- sorted.indices.dropRight(1)) {
      diffs = diffs :+ (sorted(index) - sorted(index + 1)).abs
    }
    n = diffs.sum / diffs.size
  }

  // Counts percentage of each keys value
  def percentage(key: String) = data.get(key) / data.get.values.sum

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
  def width = (widthOfUI * 1 / 2) / data.get.size

  //Sets height of a bar so that key with biggest value has the biggest height. Other bars are made by scaling to the bar of biggest height.
  def height(key: String): Double = {
    val biggestValue: (String, Double) = data.get.maxBy(_._2)
    var height = data.get(key) match {
      case _ if data.get(key) == biggestValue._2 => heightOfUI2 - 50
      case a: Double => (heightOfUI2 - 50) * (a / biggestValue._2)
    }
    height
  }


  //Makes bars using the methods above
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

  def addStampsOnY(): Unit = {
    val valueHeight = data.get.map(og => og._2 -> height(og._1)).toVector.sortBy{case (x, height) => x}
    val scale = (valueHeight.last._2 - valueHeight.head._2) / (valueHeight.last._1 - valueHeight.head._1)
    val smallest = data.get.minBy{case (x, y) => y}._2 -> locationInInterface(data.get.minBy{case (x, y) => y}._1)._2

    stampsOnY = addStampsY((0, xAxis), n, scale, yAxis, 2)
  }

  var stampsOnY = Array[javafx.scene.Node]()
  val axis = addAxis(yAxis, xAxis)
  def grid = addGrid(matchGridAndStamps)
  def addTitle = addGraphTitle(title, (widthOfUI / 2, 10))
  def addTitleY: javafx.scene.Node = addGraphTitleY(yAxis, titleY)

}
