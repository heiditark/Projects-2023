package Interface

import Graphs.PieDiagram.{changeColor, colorGenerator}
import Graphs.{BarCharProject, LineDiagram, PieDiagram}
import javafx.scene.shape.Rectangle
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
  val diagram = new Pane {
    margin = Insets(5)
  }

  val file2 = new Menu("File")
  val add = new Menu("Add")
  val sideBar = new VBox {
    background = new Background(Array(new BackgroundFill(Color.rgb(186, 188, 190), CornerRadii.Empty, Insets.Empty)))
    minWidth = 190
    maxWidth = 190
    margin = Insets(5)
    padding = Insets(5)
    spacing = 30
  }




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
  scene.fill = Color.rgb(4, 5, 7)








  // MAKES GRAPHS, move to own class
  val width = diagram.getBoundsInLocal
  val height = diagram.getHeight

  def emptyDiagram() = {
    diagram.getChildren.clear()
    sideBar.getChildren.clear()
  }

  def vbox() =  new VBox { spacing = 10 }

  def titleBox() = new TextField()



  //To make a bar chart

  val cbPieInfo = new CheckBox("Info")
  cbPieInfo.setIndeterminate(false)
  cbPieInfo.onAction = (event) => makePieDiagram()

  val pieColor = new Button("Change")
  pieColor.onAction = (event) => {
    PieDiagram.changeColor()
    makePieDiagram()
  }

  val backPieColor = new Button("Back")
  backPieColor.onAction = (event) => {
    PieDiagram.unChangeColor()
    makePieDiagram()
  }

  val pieTitle = titleBox()

  val changeTitle = new Button("OK")
  changeTitle.onAction = (event) => {
    PieDiagram.title = pieTitle.getText
    pieTitle.setText("")
    makePieDiagram()
  }

  def doPieInfo() =
    diagram.children ++= PieDiagram.info()

  def makePieDiagram() = {
    emptyDiagram()

    diagram.children ++= PieDiagram.doSectors()
    diagram.children += PieDiagram.addTitle

    if(cbPieInfo.isSelected) doPieInfo()

    val colorVbox = vbox()
    sideBar.getChildren.add(colorVbox)
    colorVbox.getChildren.add(new Text("Color of Sector:"))
    val colorbox = new HBox {  spacing = 5  }
    colorbox.getChildren.add(pieColor)
    colorbox.getChildren.add(backPieColor)
    colorVbox.getChildren.add(colorbox)

    val infoVbox = vbox()
    sideBar.getChildren.add(infoVbox)
    infoVbox.getChildren.add(new Text("Show Info:"))
    infoVbox.getChildren.add(cbPieInfo)

    val changeTitleBox = vbox()
    sideBar.getChildren.add(changeTitleBox)
    changeTitleBox.getChildren.add(new Text("Change Title:"))
    val titleHBox = new HBox {  spacing = 5  }
    changeTitleBox.getChildren.add(titleHBox)
    titleHBox.getChildren.add(pieTitle)
    titleHBox.getChildren.add(changeTitle)
  }

  //To make a bar chart

  val colorPickerBar = new ColorPicker(colorGenerator())
  colorPickerBar.onAction = (event) => makeBarChart()

  val cbGridBar = new CheckBox("Grid")
  cbGridBar.setIndeterminate(false)
  cbGridBar.onAction = (event) => makeBarChart()

  val cbBarInfo = new CheckBox("Value")
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

    val colorVbox = vbox()
    sideBar.getChildren.add(colorVbox)
    colorVbox.getChildren.add(new Text("Color of Bar:"))
    colorVbox.getChildren.add(colorPickerBar)

    val valueVbox = vbox()
    sideBar.getChildren.add(valueVbox)
    valueVbox.getChildren.add(new Text("Show Values:"))
    valueVbox.getChildren.add(cbBarInfo)

    val infoVbox = vbox()
    sideBar.getChildren.add(infoVbox)

    val gridVbox = vbox()
    sideBar.getChildren.add(gridVbox)
    gridVbox.getChildren.add(new Text("Add Grid:"))
    gridVbox.getChildren.add(cbGridBar)
  }


  // To make a line diagram

  val colorPickerDot = new ColorPicker(Color.Black)
  colorPickerDot.onAction = (event) => makeLineDiagram()

  val colorPickerLine = new ColorPicker(Color.Black)
  colorPickerLine.onAction = (event) => makeLineDiagram()

  val cbGridLine = new CheckBox("Grid")
  cbGridLine.setIndeterminate(false)
  cbGridLine.onAction = (event) => makeLineDiagram()


  val resizePlus = new Button("+")
  resizePlus.onAction = (event) => {
    if(LineDiagram.sizing <= 0.9) {
      LineDiagram.sizing += 0.1
      makeLineDiagram()
    }
  }

  val resizeMinus = new Button("-")
  resizeMinus.onAction = (event) => {
    if(LineDiagram.sizing >= 0.7) {
      LineDiagram.sizing -= 0.1
      makeLineDiagram()
    }
  }

  val resizeGridPlus = new Button("+")
  resizeGridPlus.onAction = (event) => {
    if(LineDiagram.gridSize <= 115) {
      LineDiagram.gridSize += 5
      makeLineDiagram()
    }
  }

  val resizeGridMinus = new Button("-")
  resizeGridMinus.onAction = (event) => {
    if(LineDiagram.gridSize >= 15) {
      LineDiagram.gridSize -= 5
      makeLineDiagram()
    }
  }

  def addDotsLinesAxis() =
    diagram.children ++= LineDiagram.axis ++ LineDiagram.stamps ++ LineDiagram.doLines() ++ LineDiagram.doDots()


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
    resizeVbox.getChildren.add(new Text("Resize:"))
    val resizeBox = new HBox {  spacing = 5  }
    resizeBox.getChildren.add(resizeMinus)
    resizeBox.getChildren.add(resizePlus)
    resizeVbox.getChildren.add(resizeBox)

    val resizeGridBox = vbox()
    sideBar.getChildren.add(resizeGridBox)
    resizeGridBox.getChildren.add(new Text("Add Grid:"))
    resizeGridBox.getChildren.add(cbGridLine)

    if(cbGridLine.isSelected) {
      val resizeGridHBox = new HBox {  spacing = 5  }
      resizeGridHBox.getChildren.add(resizeGridMinus)
      resizeGridHBox.getChildren.add(resizeGridPlus)
      sideBar.getChildren.add(resizeGridHBox)
      addGridLine()
    }

    addDotsLinesAxis()
  }


}
