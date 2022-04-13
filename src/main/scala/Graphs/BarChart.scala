package Graphs
import javafx.scene.shape.Rectangle
import scalafx.scene.paint.Color

object BarCharProject extends Graph {

  val data: Map[String, Int] = Map(("Car" -> 7), ("Bike" -> 6), ("Bus" -> 8), ("Train" -> 21), ("Metro" -> 17))
 // Map(("Car" -> 10), ("Bike" -> 20), ("Bus" -> 50), ("Train" -> 19), ("Metro" -> 4),("Airplane" -> 54))
  val color = colorGenerator()

  // Counts percentage of each keys value
  def percentage(key: String) = data(key).toDouble / data.values.sum.toDouble

  def locationInInterface(key: String) = {
    val index = data.keys.toVector.indexOf(key)
    val x = index match {
      case i: Int if index == 0 => 20
      case _: Int =>  width * index + 20
    }
    val y = heightOfUI - height(key) - 30

    (x, y)
  }

  //Each bar has equal width
  val width = (widthOfUI - 20 ) / data.size

  //Sets height of a bar so that key with biggest value has the biggest height. Other bars are made by scaling to the bar of biggest height.
  def height(key: String): Double = {
    val biggestValue: (String, Int) = data.maxBy(_._2)
    var height = data(key) match {
      case _ if data(key) == biggestValue._2 => heightOfUI - 50
      case a: Int => (heightOfUI - 50) * (a / biggestValue._2.toDouble)
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
      textBoxes(index) = addText(key, (locationInInterface(key)._1 + width / 2, 575))

      index += 1
    }
    bars ++ textBoxes
  }

  val axis = addAxis(20, 570)

}
