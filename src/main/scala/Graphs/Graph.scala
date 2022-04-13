package Graphs


import scalafx.scene.paint.Color
import javafx.scene.shape._
import scalafx.scene.text.{Font, Text}
import scala.util.Random

trait Graph {


 /* val data: Data */

  val heightOfUI = 600.0
  val widthOfUI = 1000.0

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

    val textFieldWidth = textField.getBoundsInLocal.getWidth
    val textFieldHeight = textField.getBoundsInLocal.getHeight

    textField.resizeRelocate(
      location._1 - textFieldWidth / 2,
      location._2 + textFieldHeight / 2,
      size,
      3
    )
    textField.setFont(Font.font("Proxima Nova"))

    textField
  }

  def addAxis(x: Double, y: Double) = {
    val axis = new Array[javafx.scene.Node](2)

    //x
    axis(0) = new Line {
      setStartX(0)
      setStartY(y)
      setEndX(widthOfUI + 100)
      setEndY(y)
    }

    //y
    axis(1) = new Line {
      setStartX(x)
      setStartY(0)
      setEndX(x)
      setEndY(heightOfUI + 100)
    }
    println(axis.mkString("\n"))

    axis
  }

  def addGrid(startX1: Double, startY1: Double, scale: Double): Array[javafx.scene.Node] = {
    val countX = (widthOfUI / scale).toInt
    val countY = (heightOfUI / scale).toInt
    var gridLinesHorizontal =
      new Array[javafx.scene.Node]((0 until countX).count(b => b%10 == 0))
    var gridLinesVertical =
      new Array[javafx.scene.Node]((0 until countY).count(a => a%10 == 0))
    var step1 = 0
    var step2 = 0

    //y
    for(index <- (0 until countX).filter(a => a%10 == 0)) {
      var lineY = new Line {
        setStartX(startX1 + index * scale)
        setStartY(0)
        setEndX(startX1 + index * scale)
        setEndY(heightOfUI + 100)
        setStroke(Color.rgb(230, 230, 230))
      }
      gridLinesHorizontal(step1) = lineY
      step1 += 1
    }
    //x
    for(index <- (0 until countY).filter(b => b%10 == 0)) {
      var lineX = new Line {
        setStartX(0)
        setStartY(startY1 + index * scale)
        setEndX(widthOfUI + 100)
        setEndY(startY1 + index * scale)
        setStroke(Color.rgb(230, 230, 230))
      }
      gridLinesVertical(step2) = lineX
      step2 += 1
    }
    println(gridLinesVertical.mkString("\n"))
    println(gridLinesHorizontal.mkString("\n"))

    gridLinesVertical ++ gridLinesHorizontal
  }

}
