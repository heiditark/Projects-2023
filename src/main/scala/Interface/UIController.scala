package Interface

import Graphs.{BarCharProject, LineDiagram, PieDiagram}
import scalafx.Includes.observableList2ObservableBuffer

object UIController {

/*
  def emptyDiagram() = diagram.getChildren.clear()

  def makePieDiagram() = {
    emptyDiagram()
    Interface.diagram.children ++= PieDiagram.doSectors()
  }

  def makeBarChart() = {
    emptyDiagram()
    diagram.children ++= BarCharProject.doBars()
  }

  // To make a line diagram
  def addDots() =
    diagram.children ++= LineDiagram.doDots()


  // To make a line diagram
  def addLines() =
    diagram.children ++= LineDiagram.doLines()

  def addAxis() =
    diagram.children ++= LineDiagram.doAxis()

  def makeLineDiagram() = {
    emptyDiagram()
    addAxis()
    addLines()
    addDots()
  }




  val sizeSlider = new Slider() {
    min = 10
    max = 100
    value = 100
  }
  val resizeBtn = new Button("Resize")
  resizeBtn.onAction = (event) => makeLineDiagram()
  sideBar.children += sizeSlider
  sideBar.children += resizeBtn

  // var fileChooser = new FileChooser()
  // file.onAction = (event) => selectedFile = fileChooser.showOpenDialog(stage)

  */

}
