package Graphs

import scalafx.beans.property.StringProperty
import scalafx.geometry.Point2D.Zero._
import scalafx.scene.control.{TextArea, TextField}
import scalafx.scene.paint.Color
import scalafx.scene.text.Text

import scala.util.Random

trait Graph {


 /* val data: Data */

  //Generates a random color
  def colorGenerator() = {
    val random = new Random()
    val red = random.nextInt(255)
    val green = random.nextInt(255)
    val blue = random.nextInt(255)

    Color.rgb(red, green, blue)
  }

  def addText(text: String, location: (Double, Double)) = {
    val size = text.length
    var textField = new Text()
    textField.setText(text)

    val textFieldWidth = textField.getBoundsInLocal().getWidth()
    val textFieldHeight = textField.getBoundsInLocal().getHeight()

    textField.resizeRelocate(
      location._1 - textFieldWidth / 2,
      location._2 + textFieldHeight / 2,
      size,
      3
    )
    textField
  }

}
