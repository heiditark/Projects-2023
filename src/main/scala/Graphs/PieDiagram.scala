package Graphs

import scalafx.scene.paint.Color
import scalafx.scene.shape.{Arc, ArcType}


object PieDiagram extends Graph {

  val heightOfUI = 600
  val widthOfUI = 1000

  val data: Map[String, Int] = Map(("Car" -> 7), ("Bike" -> 6), ("Bus" -> 8), ("Train" -> 21), ("Metro" -> 17))
  val radius = heightOfUI / 2 - 100
  val centerPoint: (Int, Int) = (widthOfUI / 2, heightOfUI / 2)
  val pi = scala.math.Pi

  // Counts percentage of each keys value
  def percentage(key: String) = data(key).toDouble / data.values.sum.toDouble

  def arcLength(key: String) = percentage(key)  * 2 * pi * radius

  def angle(key: String) = percentage(key) * 360

  def doSectors() = {
    var startAngle2: Double = 90.0
    var sectors = new Array[javafx.scene.Node](data.size)
    var index = 0

    for(dataPoint <- data) {
      var sector = new Arc() {
        centerX = centerPoint._1
        centerY = centerPoint._2
        radiusX = radius
        radiusY = radius
        startAngle = startAngle2
        length = angle(dataPoint._1)
        fill = Color.rgb(186, 188, 190)
        stroke = Color.Pink
        strokeWidth = 3
      }
      sector.setType(ArcType.Round)
      sectors(index) = sector
      startAngle2 = startAngle2 + angle(dataPoint._1)
      index += 1
    }
    sectors
  }
}
