package Graphs
import javafx.scene.shape.Rectangle

object BarCharProject extends Graph {

  val data: Map[String, Int] = Map(("Car" -> 7), ("Bike" -> 6), ("Bus" -> 8), ("Train" -> 21), ("Metro" -> 17))
  val heightOfUI = 650
  val widthOfUI = 1090

  // Counts percentage of each keys value
  def percentage(key: String) = data(key).toDouble / data.values.sum.toDouble


  def locationInInterface(key: String) = {
    val index = data.keys.toVector.indexOf(key)
    val x = width * index + 10
    val y = heightOfUI - height(key) - 30

    println(x+", "+y)

    (x, y)
  }

  //Each bar has equal width
  val width = (widthOfUI.toDouble - 20 ) / data.size

  //Sets height of a bar with using percentage
  def height(key: String): Double = heightOfUI * percentage(key)

  //Makes bars using the methods above
  def doBars(): Array[javafx.scene.Node] = {
    var bars = new Array[javafx.scene.Node](data.size)
    var index = 0
    for(key <- data.keys) {
      var bar = new Rectangle {
        setX(locationInInterface(key)._1)
        setY(locationInInterface(key)._2)
        setWidth(width)
        setHeight(height(key))
      }
      bars(index) = bar
      index += 1
    }
    bars
  }

}
