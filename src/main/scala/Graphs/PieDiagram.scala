package Graphs

import scalafx.scene.paint.Color
import scalafx.scene.shape.{Arc, ArcType}

import scala.math._

object PieDiagram extends Graph {

  var heightOfUI = 600.0
  var widthOfUI = 1000.0

  val data: Map[String, Int] = Map(("Car" -> 7), ("Bike" -> 6), ("Bus" -> 8), ("Train" -> 21), ("Metro" -> 17))
  val radius = heightOfUI / 2 - 50
  val centerPoint: (Double, Double) = (widthOfUI / 2, heightOfUI / 2)
  val pi = scala.math.Pi

  // Counts percentage of each keys value
  def percentage(key: String) = data(key).toDouble / data.values.sum.toDouble

  //Counts angle using percentage of a key
  def angle(key: String) = percentage(key) * 360

  //Makes sectors and textboxs
  def doSectors() = {
    var startAngle2: Double = 90.0
    var sectors = new Array[javafx.scene.Node](data.size)
    var textBox = new Array[javafx.scene.Node](data.size)
    var index = 0

    //Adds sectors
    for(dataPoint <- data) {
      var sector = new Arc() {
        centerX = centerPoint._1
        centerY = centerPoint._2
        radiusX = radius
        radiusY = radius
        startAngle = startAngle2
        length = angle(dataPoint._1)
        fill = colorGenerator()
        stroke = Color.White
        strokeWidth = 2
      }
      sector.setType(ArcType.Round)
      sectors(index) = sector

      //Adds textBox
      // Calculate the angle at the middle of the sector
      val angleInBetween = toRadians(startAngle2 + angle(dataPoint._1) / 2)
      // Calculate the x and y coordinates of the middle of the sector
      val textBoxPositionX = centerPoint._1 + radius * cos(angleInBetween) * 0.5
      val textBoxPositionY = centerPoint._2 - radius * sin(angleInBetween) * 0.5

      textBox(index) = addText(dataPoint._1, (textBoxPositionX, textBoxPositionY))

      startAngle2 = startAngle2 + angle(dataPoint._1)
      index += 1
    }
    sectors ++ textBox
  }

}
