package Graphs


import scalafx.scene.paint.Color
import javafx.scene.shape._
import scalafx.scene.text._

import scala.math.pow
import scala.util.Random

trait Graph {

  var heightOfUI = 613.3333129882812
  var widthOfUI = 1068.6666259765625
  var fontSize = 34

  //Generates a random color
  def colorGenerator() = {
    val random = new Random()
    val red = random.nextInt(255)
    val green = random.nextInt(255)
    val blue = random.nextInt(255)

    Color.rgb(red, green, blue)
  }


  def addTextLeft(text: String, location: (Double, Double)) = {
    val size = text.length
    var textField = new Text(text)

    val textFieldWidth = textField.getBoundsInLocal.getWidth
    val textFieldHeight = textField.getBoundsInLocal.getHeight

    textField.resizeRelocate(
      location._1,
      location._2 - textFieldHeight / 2,
      size,
      3
    )
    textField
  }

  def addTextRight(text: String, location: (Double, Double)) = {
    val size = text.length
    var textField = new Text(text)

    val textFieldWidth = textField.getBoundsInLocal.getWidth
    val textFieldHeight = textField.getBoundsInLocal.getHeight

    textField.resizeRelocate(
      location._1 - textFieldWidth,
      location._2 - textFieldHeight,
      size,
      3
    )
    textField
  }

  def addTextMiddle(text: String, location: (Double, Double)) = {
    val size = text.length
    var textField = new Text(text)

    val textFieldWidth = textField.getBoundsInLocal.getWidth
    val textFieldHeight = textField.getBoundsInLocal.getHeight

    textField.resizeRelocate(
      location._1 - textFieldWidth / 2,
      location._2 + textFieldHeight / 2,
      size,
      3
    )
    textField
  }

  def addGraphTitle(text: String, location: (Double, Double)) = {
    val size = text.length
    var textField = new Text(text)

    textField.setStyle("-fx-font-size: 18;")

    val textFieldWidth = textField.getBoundsInLocal.getWidth

    textField.resizeRelocate(location._1 - 1.5 * textFieldWidth / 2,
      location._2, size, 18)

    textField

  }

  def addGraphTitleY(yAxisXPos: Double, text: String): javafx.scene.Node = {
    addTextLeft(text, (yAxisXPos + 5, 5))
  }

  def addGraphTitleX(xAxisYPos: Double, text: String): javafx.scene.Node  = {
    addTextRight(text, (widthOfUI - 5, xAxisYPos - 5))
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

    axis
  }

  def addGridHorizontal(xAxisYPos: Double, step: Int) = {
    val countY = (heightOfUI / step).toInt
    var gridLinesHorizontal =
      new Array[javafx.scene.Node](countY)
    val start = (xAxisYPos / step) * step - (xAxisYPos / step).floor * step

    //x
    for(index <- (0 until countY)) {
      var lineX = new Line {
        setStartX(0)
        setStartY(index * step + start)
        setEndX(widthOfUI + 100)
        setEndY(index * step + start)
        setStroke(Color.rgb(230, 230, 230))
      }
      gridLinesHorizontal(index) = lineX
    }
    gridLinesHorizontal
  }


  def addGridVertical(yAxisXPos: Double, step: Double): Array[javafx.scene.Node] = {
    val countX = (widthOfUI / step).toInt
    var gridLinesVertical =
      new Array[javafx.scene.Node](countX)
    val start = (yAxisXPos / step) * step - (yAxisXPos / step).floor * step

    //y
    for(index <- (0 until countX)) {
      var lineY = new Line {
        setStartX(index * step + start)
        setStartY(0)
        setEndX(index * step + start)
        setEndY(heightOfUI + 100)
        setStroke(Color.rgb(230, 230, 230))
        //getStrokeDashArray.addAll(5d, 5d)
      }
      gridLinesVertical(index) = lineY
    }

    gridLinesVertical
  }

  def roundOneDecimal(n: Double) = {
    BigDecimal(n).setScale(1, BigDecimal.RoundingMode.HALF_UP).toDouble
  }

  def everyN(array: Array[(Double, Double)], n: Int): Array[(Double, Double)] = {
    array.zipWithIndex.filter{case (y, index) => index%n == 0}.map(a => a._1)
  }




  def addStampLine(startX: Double, startY: Double, endX: Double, endY: Double): javafx.scene.Node = {
    var line = new Line() {
      setStartX(startX)
      setStartY(startY)
      setEndX(endX)
      setEndY(endY)
    }
    line
  }

}
