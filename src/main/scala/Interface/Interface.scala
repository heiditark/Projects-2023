package Interface

import Graphs.{BarCharProject, LineDiagram, PieDiagram}
import scalafx.Includes._
import scalafx.application.JFXApp
import scalafx.geometry.Insets
import scalafx.scene.Scene
import scalafx.scene.control._
import scalafx.scene.layout._
import scalafx.scene.paint.Color
import scalafx.geometry.{Insets, Pos}
import scalafx.scene.control.MenuItem
import scalafx.scene.control.Menu
import scalafx.scene.control.MenuBar
import scalafx.scene.text.Text
import scalafx.stage.FileChooser



object Interface extends JFXApp {

  stage = new JFXApp.PrimaryStage {
    title.value = "Visualization of numerical data"
    width = 1291
    height = 693
  }

  // Parts of the interface
  val diagram = new Pane

  val file2 = new Menu("File")
  val add = new Menu("Add")
  val sideBar = new GridPane {
    minWidth = 190
    maxWidth = 190
    margin = Insets(5)
    padding = Insets(5)
    vgap = 15
    hgap = 5
  }

  // Background color of sideBar
  sideBar.background = new Background(Array(new BackgroundFill(Color.rgb(186, 188, 190), CornerRadii.Empty, Insets.Empty)))



  val file = new MenuItem("Add file")

  // To add graphs
  val line = new MenuItem("Line diagram")
  val pie = new MenuItem("Pie diagram")
  val bar = new MenuItem("Bar chart")

  // When chosen what graph to use, calls the method which makes it
  line.onAction = (event) => makeLineDiagram()
  bar.onAction = (event) => makeBarChart()
  pie.onAction = (event) => makePieDiagram()

  file2.items += file
  add.items += (line, pie, bar)

  val menubar = new MenuBar()
  menubar.menus += (file2, add)



  val root = new BorderPane {
    center = diagram
    top = menubar
    left = sideBar
  }

  val scene = new Scene(root)
  stage.scene = scene








  // MAKES GRAPHS, move to own class
  val width = diagram.getBoundsInLocal
  println(width)
  val height = diagram.getHeight

  def emptyDiagram() = {
    diagram.getChildren.clear()
    sideBar.getChildren.clear()
  }




  //To make a bar chart

  val cbPieInfo = new CheckBox("Info")
  cbPieInfo.setIndeterminate(false)
  cbPieInfo.onAction = (event) => makePieDiagram()

  def doPieInfo() =
    diagram.children ++= PieDiagram.info()

  def makePieDiagram() = {
    emptyDiagram()

    diagram.children ++= PieDiagram.doSectors()
    if(cbPieInfo.isSelected) doPieInfo()

    sideBar.add(new Text("Show Info:"),0,6)
    sideBar.add(cbPieInfo, 0, 7)
  }

  //To make a bar chart

  val colorPickerBar = new ColorPicker(Color.rgb(204,51,51))
  colorPickerBar.onAction = (event) => makeBarChart()

  val cbGridBar = new CheckBox("Grid")
  cbGridBar.setIndeterminate(false)
  cbGridBar.onAction = (event) => makeBarChart()

  val cbBarInfo = new CheckBox("Info")
  cbBarInfo.setIndeterminate(false)
  cbBarInfo.onAction = (event) => makeBarChart()

  def doBarInfo() = {
    diagram.children ++= BarCharProject.info()
  }

  def addGridBar() =
    diagram.children ++= BarCharProject.grid

  def makeBarChart() = {
    emptyDiagram()

    BarCharProject.color = colorPickerBar.getValue

    if(cbGridBar.isSelected) addGridBar()
    if(cbBarInfo.isSelected) doBarInfo()
    diagram.children ++= BarCharProject.doBars()
    diagram.children ++= BarCharProject.axis
    diagram.children ++= BarCharProject.stampsOnY

    sideBar.add(new Text("Color of Bar:"),0,1)
    sideBar.add(colorPickerBar, 0, 2)
    sideBar.add(new Text("Show Info:"),0,6)
    sideBar.add(cbBarInfo, 0, 7)
    sideBar.add(new Text("Add Grid:"),0,11)
    sideBar.add(cbGridBar, 0, 12)

  }



  // To make a line diagram

  val colorPickerDot = new ColorPicker(Color.Black)
  colorPickerDot.onAction = (event) => makeLineDiagram()

  val colorPickerLine = new ColorPicker(Color.Black)
  colorPickerLine.onAction = (event) => makeLineDiagram()

  val cbGridLine = new CheckBox("Grid")
  cbGridLine.setIndeterminate(false)
  cbGridLine.onAction = (event) => makeLineDiagram()

  val sizeSliderLine = new Slider() {
    min = 0.6
    max = 1.0
    value = 1.0
    minorTickCount = 5
  }

  val resizeBtn = new Button("OK")
  resizeBtn.onAction = (event) => makeLineDiagram()

  def addDotsLinesAxis() =
    diagram.children ++= LineDiagram.axis  ++ LineDiagram.doLines() ++ LineDiagram.doDots()


  def addGridLine() =
    diagram.children ++= LineDiagram.grid


  def makeLineDiagram() = {
    emptyDiagram()

    LineDiagram.colorDots = colorPickerDot.getValue
    LineDiagram.colorLines = colorPickerLine.getValue
    LineDiagram.sizing = sizeSliderLine.getValue

    sideBar.add(new Text("Color of Dot:"),0,1)
    sideBar.add(colorPickerDot, 0, 2)
    sideBar.add(new Text("Color of Line:"),0,6)
    sideBar.add(colorPickerLine, 0, 7)
    sideBar.add(new Text("Resize:"),0,11)
    sideBar.add(sizeSliderLine, 0, 12)
    sideBar.add(resizeBtn, 1, 12)
    sideBar.add(new Text("Add Grid:"),0,16)
    sideBar.add(cbGridLine, 0, 17)

    if(cbGridLine.isSelected) addGridLine()
    addDotsLinesAxis()
  }


}
