package Interface

import Graphs.{BarCharProject, LineDiagram, PieDiagram}
import javafx.beans.value.ChangeListener
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








  // MAKES GRAPHS, move to own class
  val width = diagram.getPrefWidth
  val height = diagram.getHeight

  def emptyDiagram() = {
    diagram.getChildren.clear()
    sideBar.getChildren.clear()
  }

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

  val colorPickerDot = new ColorPicker(Color.Black)
  colorPickerDot.onAction = (event) => makeLineDiagram()

  val cbGrid = new CheckBox("Add Grid")
  cbGrid.setIndeterminate(true)
  cbGrid.onAction = (event) => makeLineDiagram()

  val sizeSliderLine = new Slider() {
    min = 0.6
    max = 1.0
    value = 1.0
  }

  val resizeBtn = new Button("Resize")
  resizeBtn.onAction = (event) => makeLineDiagram()

  def addDotsLinesAxis() =
    diagram.children ++= LineDiagram.axis  ++ LineDiagram.doLines() ++ LineDiagram.doDots()


  def addGrid() =
    diagram.children ++= LineDiagram.grid


  def makeLineDiagram() = {
    emptyDiagram()

    LineDiagram.colorDots = colorPickerDot.getValue
    LineDiagram.sizing = sizeSliderLine.getValue

    sideBar.children += (colorPickerDot, cbGrid, sizeSliderLine, resizeBtn)

    if(cbGrid.isSelected) addGrid()
    addDotsLinesAxis()
  }


}
