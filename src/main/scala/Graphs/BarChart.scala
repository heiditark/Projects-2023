package Graphs
import scala.math._

class BarChart extends Graph {

  val data = Map(("Car" -> 7), ("Bike" -> 6), ("Bus" -> 8), ("Train" -> 21), ("Metro" -> 17))
  val heightOfUI = 600
  val widthOfUI = 1000

  // Counts percentage of each keys value
  def percentage(key: String) = data(key).toDouble / data.values.sum.toDouble

  def locationInInterface(key: String) = {
    val index: Double = data.toVector.indexOf((key, data(key))).toDouble
    val x = width * index + 10
    val y = 20

    (x, y)
  }

  //Sets height of a key by using percentage
  def height(key: String): Double = heightOfUI * percentage(key)

  def width(key: String): Double = (widthOfUI.toDouble - 20 ) / data.size
}
