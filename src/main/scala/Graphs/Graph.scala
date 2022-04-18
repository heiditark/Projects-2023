package Graphs


import scalafx.scene.paint.Color
import javafx.scene.shape._
import scalafx.scene.text.{Font, Text, TextAlignment}

import scala.math.pow
import scala.util.Random

trait Graph {


  var heightOfUI = 600.0
  var widthOfUI = 1060.0
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
  //  textField.setFont(Font.font("Proxima Nova"))
    textField
  }

  def addTextMiddle(text: String, location: (Double, Double)) = {
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
  //  textField.setFont(Font.font("Proxima Nova"))

    textField
  }

  def addGraphTitle(text: String, location: (Double, Double)) = {
    val size = text.length
    var textField = new Text()

    textField.setText(text)
    textField.setStyle("-fx-font-size: 18;-fx-alignment: left;")

    val textFieldWidth = textField.getBoundsInLocal.getWidth

    textField.resizeRelocate(location._1 - textFieldWidth / 2,
      location._2, size, 18)

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
        //getStrokeDashArray.addAll(5d, 5d)
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

  def addStampsY(first: (Double, Double), step: Double, scale: Double, yAxisXPos: Double, n: Int): Array[javafx.scene.Node] = {
    var stamps: Array[(Double, Double)] = new Array[(Double, Double)]((heightOfUI / step).toInt)
    val stepOG = step * pow(scale, -1)

    for(index <- 0 until (heightOfUI / step).toInt) {
      val text = roundOneDecimal(first._1 + stepOG * index)
      val coord = first._2 - step * index

      stamps(index) = (text, coord)
    }

    val every: Array[(Double, Double)] = everyN(stamps,n)
    matchGridAndStamps = every.map{case (x, y) => y}

    val text: Array[javafx.scene.Node] = every.map(x => addTextMiddle(x._1.toString,(yAxisXPos - 20, x._2 - fontSize / 2)))
    val line: Array[javafx.scene.Node] = every.map(x => addStampLine(yAxisXPos - 5, x._2, yAxisXPos + 5, x._2))

    text ++ line
  }

  var matchGridAndStamps = Array[Double]()

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
