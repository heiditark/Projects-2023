package Graphs
import javafx.scene.shape.Rectangle
import scalafx.scene.paint.Color

object BarCharProject extends Graph {

  val data: Map[String, Int] = Map(("Car" -> 7), ("Bike" -> 6), ("Bus" -> 8), ("Train" -> 21), ("Metro" -> 17))
  val heightOfUI = 600
  val widthOfUI = 1090

  // Counts percentage of each keys value
  def percentage(key: String) = data(key).toDouble / data.values.sum.toDouble

  def locationInInterface(key: String) = {
    val index = data.keys.toVector.indexOf(key)
    val x = width * index + 10
    val y = heightOfUI - height(key) - 30
    (x, y)
  }

  //Each bar has equal width
  val width = (widthOfUI.toDouble - 20 ) / data.size

  //Sets height of a bar so that key with biggest value has the biggest height. Other bars are made by scaling to the bar of biggest height.
  def height(key: String): Double = {
    val biggestValue: (String, Int) = data.maxBy(_._2)
    var height = data(key) match {
      case _ if data(key) == biggestValue._2 => heightOfUI - 50
      case a: Int => (heightOfUI - 50) * (a.toDouble / biggestValue._2.toDouble)
    }
    height
  }


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
        setStroke(Color.rgb(186, 188, 190))
        setFill(Color.Pink)
      }
      bars(index) = bar
      index += 1
    }
    bars
  }

}
