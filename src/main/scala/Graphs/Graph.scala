package Graphs


import scalafx.scene.paint.Color
import javafx.scene.shape._
import scalafx.scene.text.{Font, Text, TextAlignment}

import scala.math.pow
import scala.util.Random

trait Graph {


 /* val data: Data */

  var heightOfUI = 600.0
  var widthOfUI = 1060.0

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
  //  textField.setFont(Font.font("Proxima Nova"))
    textField.setTextAlignment(TextAlignment.Left)

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

  def addGridHorizontal(startY1: Double, scale: Double) = {
    val countY = (heightOfUI / scale).toInt
    var gridLinesHorizontal =
      new Array[javafx.scene.Node]((0 until countY).count(a => a%10 == 0))
    var step = 0

    //x
    for(index <- (0 until countY).filter(b => b%10 == 0)) {
      var lineX = new Line {
        setStartX(0)
        setStartY(startY1 + index * scale)
        setEndX(widthOfUI + 100)
        setEndY(startY1 + index * scale)
        setStroke(Color.rgb(230, 230, 230))
        //getStrokeDashArray.addAll(5d, 5d)
      }
      gridLinesHorizontal(step) = lineX
      step += 1
    }
    gridLinesHorizontal
  }


  def addGridVertical(startX1: Double, scale: Double): Array[javafx.scene.Node] = {
    val countX = (widthOfUI / scale).toInt
    var gridLinesVertical =
      new Array[javafx.scene.Node]((0 until countX).count(b => b%10 == 0))

    var step = 0
    //y
    for(index <- (0 until countX).filter(a => a%10 == 0)) {
      var lineY = new Line {
        setStartX(startX1 + index * scale)
        setStartY(0)
        setEndX(startX1 + index * scale)
        setEndY(heightOfUI + 100)
        setStroke(Color.rgb(230, 230, 230))
        //getStrokeDashArray.addAll(5d, 5d)
      }
      gridLinesVertical(step) = lineY
      step += 1
    }

    gridLinesVertical
  }

  def roundOneDecimal(n: Double) = {
    BigDecimal(n).setScale(1, BigDecimal.RoundingMode.HALF_UP).toDouble
  }

  def addStampsX(first: (Double, Double), step: Double, scale: Double, xAxisYPos: Double): Array[javafx.scene.Node] = {
    var stamps: Array[(Double, Double)] = new Array[(Double, Double)]( (heightOfUI / step).toInt)
    val stepOG = step * pow(scale, -1)

    for(index <- 0 until (widthOfUI / step).toInt) {
      val text = roundOneDecimal(first._1 + stepOG * index)
      val coord = first._2 + 20 - step * index

      stamps(index) = (text, coord)
    }

    val everyThree: Array[(Double, Double)] = stamps.zipWithIndex.filter{case (y, index) => index%3 == 0}.map(a => a._1)

    everyThree.map(x => addText(x._1.toString,(x._2, xAxisYPos + 10)))
  }

  def addStampsY(first: (Double, Double), step: Double, scale: Double, yAxisXPos: Double): Array[javafx.scene.Node] = {
    var stamps: Array[(Double, Double)] = new Array[(Double, Double)]( (heightOfUI / step).toInt)
    val stepOG = step * pow(scale, -1)

    for(index <- 0 until (heightOfUI / step).toInt) {
      val text = roundOneDecimal(first._1 + stepOG * index)
      val coord = first._2 - 15 - step * index

      stamps(index) = (text, coord)
    }

    val everyThree: Array[(Double, Double)] = stamps.zipWithIndex.filter{case (y, index) => index%3 == 0}.map(a => a._1)

    val text: Array[javafx.scene.Node] = everyThree.map(x => addText(x._1.toString,(yAxisXPos - 20, x._2)))
    val line: Array[javafx.scene.Node] = everyThree.map(x => addStampLine(yAxisXPos - 5, x._2 + 17, yAxisXPos + 5, x._2 + 17))

    text ++ line
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
