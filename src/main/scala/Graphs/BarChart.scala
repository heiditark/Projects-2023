package Graphs
import javafx.scene.shape.{Line, Rectangle}
import scalafx.scene.paint.Color

import scala.math.pow

object BarCharProject extends Graph {

  val data: Map[String, Double] = //Map(("Car" -> 7), ("Bike" -> 6), ("Bus" -> 8), ("Train" -> 21), ("Metro" -> 17))
 // Map(("Car" -> 10), ("Bike" -> 20), ("Bus" -> 50), ("Train" -> 19), ("Metro" -> 4),("Airplane" -> 54))
  Map(("Maanantai" -> 100), ("Tiistai" -> 120), ("Keskiviikko" -> 103), ("Torstai" -> 70), ("Perjantai" -> 23), ("Lauantai" -> 85), ("Sunnuntai" -> 180))

  var color = Color.Black
  val yAxis = 30.0
  val xAxis = 570.0

  // Counts percentage of each keys value
  def percentage(key: String) = data(key) / data.values.sum

  def locationInInterface(key: String) = {
    val index = data.keys.toVector.indexOf(key)
    val gap = 30
    val firstXPos = widthOfUI / 2 - width * data.size / 2 - gap

    val x = index match {
      case i: Int if index == 0 => firstXPos
      case _: Int =>  (width + gap) * index + firstXPos
    }
    val y = heightOfUI - height(key) - gap

    (x, y)
  }

  //Each bar has equal width
  val width = ( widthOfUI * 1 / 2 ) / data.size

  //Sets height of a bar so that key with biggest value has the biggest height. Other bars are made by scaling to the bar of biggest height.
  def height(key: String): Double = {
    val biggestValue: (String, Double) = data.maxBy(_._2)
    var height = data(key) match {
      case _ if data(key) == biggestValue._2 => heightOfUI - 50
      case a: Double => (heightOfUI - 50) * (a / biggestValue._2)
    }
    height
  }


  //Makes bars using the methods above
  def doBars(): Array[javafx.scene.Node] = {
    var bars = new Array[javafx.scene.Node](data.size)
    var textBoxes = new Array[javafx.scene.Node](data.size)
    var index = 0

    for(key <- data.keys) {
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
    var textBoxes = new Array[javafx.scene.Node](data.size)
    var index = 0

    for(key <- data.keys) {
      val text = data(key).toString
      textBoxes(index) = addTextMiddle(text, (locationInInterface(key)._1 + width / 2, locationInInterface(key)._2 - 25))

      index += 1
    }
    textBoxes
  }

  val valueHeight = data.map(og => og._2 -> height(og._1)).toVector.sortBy{case (x, height) => x}
  val scale = (valueHeight.last._2 - valueHeight.head._2) / (valueHeight.last._1 - valueHeight.head._1)
  val smallest = data.minBy{case (x, y) => y}._2 -> locationInInterface(data.minBy{case (x, y) => y}._1)._2


  val stampsOnY = addStampsY((0, xAxis), 20, scale, yAxis,3)
  val grid = addGrid(matchGridAndStamps)
  val axis = addAxis(yAxis, xAxis)

}
