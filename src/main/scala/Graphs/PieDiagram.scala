package Graphs

import javafx.scene.shape.Circle
import scalafx.scene.paint.Color
import scalafx.scene.shape.{Arc, ArcType}

import scala.math._

object PieDiagram extends Graph {
 //val file = "esim1.txt"


  var data: Map[String, Double] = //Map(("Car" -> 7), ("Bike" -> 6), ("Bus" -> 8), ("Train" -> 21), ("Metro" -> 17))
   //Map(("Car" -> 10), ("Bike" -> 20), ("Bus" -> 50), ("Train" -> 19), ("Metro" -> 4),("Airplane" -> 54))
   // Map(("Maanantai" -> 100), ("Tiistai" -> 120), ("Keskiviikko" -> 103), ("Torstai" -> 70), ("Perjantai" -> 23), ("Lauantai" -> 85), ("Sunnuntai" -> 180))
    Map[String, Double]()

  var title = "Test"
  var radius = heightOfUI / 2 - 50
  val centerPoint: (Double, Double) = (widthOfUI / 2, heightOfUI / 2 + 30)
  val pi = scala.math.Pi
  var colorsUsed: Map[String, Color] = data.keys.map(key => key -> colorGenerator()).toMap
  var allColorsUsed: LazyList[Map[String, Color]] = LazyList[Map[String, Color]](colorsUsed)

  def changeColor() = {
    colorsUsed = data.keys.map(key => key -> colorGenerator()).toMap
    allColorsUsed = allColorsUsed :+ colorsUsed
  }

  def unChangeColor() = {
    if(allColorsUsed.length > 1) {
      allColorsUsed = allColorsUsed.dropRight(1)
      colorsUsed = allColorsUsed.last
    } else {
      colorsUsed = allColorsUsed.head
    }
  }

  // Counts percentage of each keys value
  def percentage(key: String) = data(key) / data.values.sum

  //Counts angle using percentage of a key
  def angle(key: String) = percentage(key) * 360

  //Makes sectors and textboxs
  def doSectors() = {
    println(data)
    if(data.isEmpty) throw new Exception("File Corrupted.")

    var startAngle2: Double = 90.0
    var sectors = new Array[javafx.scene.Node](data.size)
    var textBox = new Array[javafx.scene.Node](data.size)
    var index = 0

    //Adds sectors
    for(dataPoint <- data) {
      var color = colorGenerator()
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

      //Adds textBox
      // Calculate the angle at the middle of the sector
      val angleInBetween = toRadians(startAngle2 + angle(dataPoint._1) / 2)
      // Calculate the x and y coordinates of the middle of the sector
      val textBoxPositionX = centerPoint._1 + radius * cos(angleInBetween) * 1.1
      val textBoxPositionY = centerPoint._2 - radius * sin(angleInBetween) * 1.1 - 15

      textBox(index) = addTextMiddle(dataPoint._1, (textBoxPositionX, textBoxPositionY))

      startAngle2 = startAngle2 + angle(dataPoint._1)
      index += 1
    }
    sectors ++ textBox
  }

  def info() = {
    var dots = new Array[javafx.scene.Node](data.size)
    var texts = new Array[javafx.scene.Node](data.size)
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
      var text: String = info._1 + ": " + roundOneDecimal(percentage(info._1) * 100) + "%" +" (" + data(info._1) + ") "
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
