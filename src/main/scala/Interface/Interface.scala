package Interface


import Graphs.PieDiagram.colorGenerator
import Graphs._
import scalafx.Includes._
import scalafx.application.JFXApp
import scalafx.geometry.Insets
import scalafx.scene.Scene
import scalafx.scene.control._
import scalafx.scene.layout.{HBox, _}
import scalafx.scene.paint.Color
import scalafx.scene.control.Menu
import scalafx.scene.control.MenuBar
import scalafx.scene.text.Text
import scalafx.stage.FileChooser
import scalafx.stage.FileChooser.ExtensionFilter


object Interface extends JFXApp {

  stage = new JFXApp.PrimaryStage {
    title.value = "Visualization of Numerical Data"
    maximized = true
  }

  // Parts of the interface
  val diagram = new Pane {
    margin = Insets(5)
  }


  val file2 = new Menu("File")
  val add = new Menu("Add Graph")
  val sideBar = new VBox {
    background = new Background(Array(new BackgroundFill(Color.rgb(186, 188, 190), CornerRadii.Empty, Insets.Empty)))
    minWidth = 190
    maxWidth = 190
    margin = Insets(5)
    padding = Insets(5)
    spacing = 30
  }

//File management


  val file = new MenuItem("Add File")
  file.onAction = (event) => {
    val fileChooser = new FileChooser()
    fileChooser.getExtensionFilters.add(new ExtensionFilter("Text Files", "*.txt"))
    val selectedFile = fileChooser.showOpenDialog(stage)

    if(selectedFile != null) {
      emptyDiagram()

      val filePath = selectedFile.getAbsolutePath

      fileManagement.file = filePath
      fileManagement.getData

      val text = new Text("File Added: " + filePath)
      text.relocate(0, 600)
      diagram.children += text
    }
  }

  // To add graphs
  val line = new MenuItem("Line Diagram")
  val pie = new MenuItem("Pie Diagram")
  val bar = new MenuItem("Bar Chart")

  // When chosen what graph to use, calls the method which makes it
  line.onAction = (event) => LineDiagramUI.makeLineDiagram()
  bar.onAction = (event) => BarChartUI.makeBarChart()
  pie.onAction = (event) => PieDiagramUI.makePieDiagram()

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




  // MAKES GRAPHS, move to own classes?

  def emptyDiagram() = {
    diagram.getChildren.clear()
    sideBar.getChildren.clear()
  }

  def vbox() = new VBox { spacing = 10 }

  def hbox() = new HBox {
    spacing = 8
    margin = Insets(10)
  }

  def titleBox() = new TextField() { maxWidth = 120 }
}
