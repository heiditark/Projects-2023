package Graphs
import javafx.scene.shape.Rectangle
import scalafx.geometry.Rectangle2D

import scala.math._

class BarChart extends Graph {

  val data = Map(("Car" -> 7), ("Bike" -> 6), ("Bus" -> 8), ("Train" -> 21), ("Metro" -> 17))
  val heightOfUI = 600
  val widthOfUI = 1000
  val color = ???

  // Counts percentage of each keys value
  def percentage(key: String) = data(key).toDouble / data.values.sum.toDouble

  def locationInInterface(index: Int) = {
    val x = width * index + 10
    val y = 20

    (x, y)
  }

  //Each key has equal width
  val width = (widthOfUI.toDouble - 20 ) / data.size

  //Sets height of a key by using percentage
  def height(key: String): Double = heightOfUI * percentage(key)

  //Makes bars using the methods above
  def doBars(): Array[javafx.scene.Node] = {
    var bars = new Array[javafx.scene.Node](data.size)
    var index = 0
    for(key <- data.keys) {
      var bar = new Rectangle(
        locationInInterface(index)._1,
        locationInInterface(index)._2,
        width,
        height(key))

      bars(index) = bar
      index += 1
    }
    bars
  }

}
