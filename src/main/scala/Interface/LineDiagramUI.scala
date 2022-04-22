package Interface

import Graphs.LineDiagram
import scalafx.scene.layout.HBox
import scalafx.scene.text.Text
import Interface._
import scalafx.Includes.observableList2ObservableBuffer
import scalafx.scene.control.{Button, CheckBox, ColorPicker}
import scalafx.scene.paint.Color
import scalafx.Includes._



//noinspection FieldFromDelayedInit
object LineDiagramUI extends UIController {

  val colorPickerDot = new ColorPicker(Color.Black)
  colorPickerDot.onAction = (event) => LineDiagramUI.makeLineDiagram()

  val colorPickerLine = new ColorPicker(Color.Black)
  colorPickerLine.onAction = (event) => makeLineDiagram()

  val cbGridLine = new CheckBox("Grid")
  cbGridLine.setIndeterminate(false)
  cbGridLine.onAction = (event) => makeLineDiagram()


  val resizePlus = new Button("+")
  resizePlus.onAction = (event) => {
    if(LineDiagram.sizing <= 0.9) {
      LineDiagram.sizing += 0.1
      LineDiagram.autoscale()
      makeLineDiagram()
    }
  }

  val resizeMinus = new Button("-")
  resizeMinus.onAction = (event) => {
    if(LineDiagram.sizing >= 0.7) {
      LineDiagram.sizing -= 0.1
      LineDiagram.autoscale()
      makeLineDiagram()
    }
  }

  val resizeGridPlus = new Button("+")
  resizeGridPlus.onAction = (event) => {
    if(LineDiagram.gridSize <= 115) {
      LineDiagram.gridSize += 5
      LineDiagram.autoscale()
      makeLineDiagram()
    }
  }

  val resizeGridMinus = new Button("-")
  resizeGridMinus.onAction = (event) => {
    if(LineDiagram.gridSize >= 15) {
      LineDiagram.gridSize -= 5
      LineDiagram.autoscale()
      makeLineDiagram()
    }
  }

  val lineTitleX = titleBox()

  val changeTitleXLine = new Button("OK")
  changeTitleXLine.onAction = (event) => {
    LineDiagram.titleX = lineTitleX.getText
    LineDiagramUI.makeLineDiagram()
    lineTitleX.setText("")
  }

  val lineTitleY = titleBox()

  val changeTitleYLine = new Button("OK")
  changeTitleYLine.onAction = (event) => {
    LineDiagram.titleY = lineTitleY.getText
    LineDiagramUI.makeLineDiagram()
    lineTitleY.setText("")
  }


  def addDotsLinesAxis() =
    diagram.children ++= LineDiagram.axis ++ LineDiagram.stamps ++ LineDiagram.doLines() ++ LineDiagram.doDots()


  //noinspection FieldFromDelayedInit
  def addGridLine() =
    diagram.children ++= LineDiagram.grid


  def makeLineDiagram() = {
    emptyDiagram()

    LineDiagram.colorDots = colorPickerDot.getValue
    LineDiagram.colorLines = colorPickerLine.getValue

    val colorDotVbox = vbox()
    sideBar.getChildren.add(colorDotVbox)
    colorDotVbox.getChildren.add(new Text("Color of Dot:"))
    colorDotVbox.getChildren.add(colorPickerDot)

    val colorLineVbox = vbox()
    sideBar.getChildren.add(colorLineVbox)
    colorLineVbox.getChildren.add(new Text("Color of Line:"))
    colorLineVbox.getChildren.add(colorPickerLine)


    val resizeVbox = vbox()
    sideBar.getChildren.add(resizeVbox)
    resizeVbox.getChildren.add(new Text("Resize Graph:"))
    val resizeBox = hbox()
    resizeBox.getChildren.add(resizeMinus)
    resizeBox.getChildren.add(resizePlus)
    resizeVbox.getChildren.add(resizeBox)

    val resizeGridBox = vbox()
    sideBar.getChildren.add(resizeGridBox)
    resizeGridBox.getChildren.add(new Text("Add Grid:"))
    resizeGridBox.getChildren.add(cbGridLine)

    if(cbGridLine.isSelected) {
      val resizeGridHBox = hbox()
      resizeGridHBox.getChildren.add(resizeGridMinus)
      resizeGridHBox.getChildren.add(resizeGridPlus)
      resizeGridBox.getChildren.add(resizeGridHBox)
      addGridLine()
    }

    val changeName = vbox()
    sideBar.getChildren.add(changeName)
    changeName.getChildren.add(new Text("Change Title of Axis:"))

    val titleXHBox = new HBox {  spacing = 5  }
    changeName.getChildren.add(titleXHBox)
    titleXHBox.getChildren.add(new Text("x: "))
    titleXHBox.getChildren.add(lineTitleX)
    titleXHBox.getChildren.add(changeTitleXLine)

    val titleYHBox = new HBox {  spacing = 5  }
    changeName.getChildren.add(titleYHBox)
    titleYHBox.getChildren.add(new Text("y: "))
    titleYHBox.getChildren.add(lineTitleY)
    titleYHBox.getChildren.add(changeTitleYLine)

    addDotsLinesAxis()

    diagram.children += LineDiagram.addTitleY
    diagram.children += LineDiagram.addTitleX
  }



}
