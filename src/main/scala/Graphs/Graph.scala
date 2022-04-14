package Graphs


import scalafx.scene.paint.Color
import javafx.scene.shape._
import scalafx.scene.text.{Font, Text}

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

  def addGrid(startX1: Double, startY1: Double, scale: Double): Array[javafx.scene.Node] = {
    val countX = (widthOfUI / scale).toInt
    val countY = (heightOfUI / scale).toInt
    var gridLinesVertical =
      new Array[javafx.scene.Node]((0 until countX).count(b => b%10 == 0))
    var gridLinesHorizontal =
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
        //getStrokeDashArray.addAll(5d, 5d)
      }
      gridLinesVertical(step1) = lineY
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
        //getStrokeDashArray.addAll(5d, 5d)
      }
      gridLinesHorizontal(step2) = lineX
      step2 += 1
    }

    gridLinesVertical ++ gridLinesHorizontal
  }

  def addStampsX(OGValue: Map[_, Double], data: Vector[Double], xAxisYPos: Double): Vector[javafx.scene.Node] = {
    val everyThree = data.zipWithIndex.filter{case (y, index) => index%3 == 0}
    val value = everyThree.map{case (y, index) => y -> OGValue.toVector(index)._1}
    everyThree.map{case (y, _) => addText("_",(y,xAxisYPos + 3))}
  }

  def addStampsY(data: (Double, Double), step: Double, yAxisXPos: Double): Array[javafx.scene.Node] = {
    var stamps: Array[(Double, Double)] = new Array[(Double, Double)]((heightOfUI - data._2).toInt)
    val step2 = ???

    for(index <- 0 until (heightOfUI - data._2).toInt) {
      val text = data._1 + step2 * index
      val coord = data._2 - step * index

      stamps(index) = (text, coord)
    }

    stamps.map(x => addText(x._1.toString,(yAxisXPos - 10, x._2)))
  }

}
