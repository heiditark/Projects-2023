package Graphs

import scalafx.scene.shape.{Arc, ArcType}


object PieDiagram extends Graph {

  val heightOfUI = 600
  val widthOfUI = 1000

  val data: Map[String, Int] = Map(("Car" -> 7), ("Bike" -> 6), ("Bus" -> 8), ("Train" -> 21), ("Metro" -> 17))
  val radius = heightOfUI / 2 - 100
  val centerPoint: (Int, Int) = (widthOfUI / 2, heightOfUI / 2)
  val pi = scala.math.Pi

  // Counts percentage of each keys value
  def percentage(key: String) = (data(key).toDouble / data.values.sum.toDouble) * 100.toDouble

  def arcLength(key: String) = percentage(key) * 2 * pi

  def angle(key: String) = arcLength(key) / radius

  def doSectors() = {
    var startAngle2: Double = 360
    println(startAngle2)
    var sectors = new Array[javafx.scene.Node](data.size)
    var index = 0

    for(dataPoint <- data) {
      var sector = new Arc {
        centerX = centerPoint._1
        centerY = centerPoint._2
        radiusY = radius
        radiusY = radius
        startAngle = startAngle2
        length = arcLength(dataPoint._1)
      }
      sector.setType(ArcType.Round)
      sectors(index) = sector
      startAngle2 = startAngle2 - angle(dataPoint._1)
      index += 1
    }
    sectors
  }
}
