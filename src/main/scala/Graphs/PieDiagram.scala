package Graphs

import javafx.scene.shape.Circle
import scalafx.scene.paint.Color
import scalafx.scene.shape.{Arc, ArcType}

import scala.collection.mutable
import scala.math._

object PieDiagram extends Graph {

  var data: Option[Map[String, Double]] = None

  var title = ""
  var radius = heightOfUI / 2 - 50
  val centerPoint: (Double, Double) = (widthOfUI / 2, heightOfUI / 2)
  val pi = scala.math.Pi

  // Keep colors used on making sectors mapped to a key
  var colorsUsed: Map[String, Color] = Map[String, Color]()

  // Keep a memory of used colors
  var allColorsUsed: mutable.Stack[Map[String, Color]] = mutable.Stack[Map[String, Color]]()

  // Change colors used on making sectors
  def changeColor() = {
    colorsUsed = data.get.keys.map(key => key -> colorGenerator()).toMap
    allColorsUsed = allColorsUsed :+ colorsUsed
  }

  // Unchange colors
  def unChangeColor() = {
    if(allColorsUsed.length > 1) {
      allColorsUsed = allColorsUsed.dropRight(1)
      colorsUsed = allColorsUsed.last
    } else {
      colorsUsed = allColorsUsed.head
    }
  }

  // Count percentage of each keys value
  def percentage(key: String) = data.get(key) / data.get.values.sum

  // Count angle using percentage of a key
  def angle(key: String) = percentage(key) * 360

  // Make sectors and textboxs
  def doSectors() = {
    var data2 = Map[String, Double]()
    if(data.isEmpty) throw new Exception("Data Corrupted.") else data2 = data.get
    val size = data2.size

    var startAngle2: Double = 90.0
    var sectors = new Array[javafx.scene.Node](data2.size)
    var textBox = new Array[javafx.scene.Node](data2.size)
    var index = 0

    // Add sectors
    for(dataPoint <- data2) {
      var sector = new Arc() {
        centerX = centerPoint._1
        centerY = centerPoint._2
        radiusX = radius
        radiusY = radius
        startAngle = startAngle2
        length = angle(dataPoint._1)
        fill = colorsUsed(dataPoint._1)
        stroke = Color.White
        strokeWidth = 2
      }
      sector.setType(ArcType.Round)
      sectors(index) = sector

      // Add textBox
      // Calculate the angle at the middle of the sector
      val angleInBetween = toRadians(startAngle2 + angle(dataPoint._1) / 2)
      // Calculate the x and y coordinates of the middle of the sector
      val textBoxPositionX = centerPoint._1 + radius * cos(angleInBetween) * 1.12
      val textBoxPositionY = centerPoint._2 - radius * sin(angleInBetween) * 1.12 - 10

      textBox(index) = addTextMiddle(dataPoint._1, (textBoxPositionX, textBoxPositionY))

      startAngle2 = startAngle2 + angle(dataPoint._1)
      index += 1
    }
    sectors ++ textBox
  }

  // Add information of which color is which key and percentage and count of a key
  def info() = {
    val size = data.get.size

    var dots = new Array[javafx.scene.Node](size)
    var texts = new Array[javafx.scene.Node](size)
    var yCoord = 20.0
    var xCoord = 20.0
    var stepper = 0

    for(info <- colorsUsed) {
      var circle: javafx.scene.Node = new Circle {
        setCenterX(xCoord)
        setCenterY(yCoord)
        setRadius(5)
        setFill(info._2)
      }
      var text: String = info._1 + ": " + roundOneDecimal(percentage(info._1) * 100) + "%" +" (" + data.get(info._1) + ") "
      var textWithPos: javafx.scene.Node = addTextLeft(text, (xCoord + 10, yCoord))

      dots(stepper) = circle
      texts(stepper) = textWithPos

      yCoord += 30
      stepper += 1
    }

    dots ++ texts
  }

  def addTitle: javafx.scene.Node = addGraphTitle(title, (centerPoint._1, 10))
}
