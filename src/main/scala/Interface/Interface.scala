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
  val sideBar = new VBox {
    minWidth = 190
    spacing = 20
    margin = Insets(5)
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







  val colorPicker = new ColorPicker(Color.Black)
  colorPicker.onAction = (event) => makeLineDiagram()
  sideBar.children += colorPicker


  // MAKES GRAPHS, move to own class
  val width = diagram.getPrefWidth
  val height = diagram.getHeight

  def changeColor() = colorPicker.getValue

  def emptyDiagram() = diagram.getChildren.clear()

  def makePieDiagram() = {
    emptyDiagram()
    diagram.children ++= PieDiagram.doSectors()
  }

  def makeBarChart() = {
    emptyDiagram()
    diagram.children ++= BarCharProject.doBars()
    diagram.children ++= BarCharProject.axis
  }

  // To make a line diagram
  def addDots() =
    diagram.children ++= LineDiagram.doDots()

  def addLines() =
    diagram.children ++= LineDiagram.doLines()

  def addAxis() =
    diagram.children ++= LineDiagram.axis

  def addGrid() =
    diagram.children ++= LineDiagram.grid

  def makeLineDiagram() = {
    LineDiagram.color = changeColor()
    emptyDiagram()
    addGrid()
    addAxis()
    addLines()
    addDots()
  }


}
