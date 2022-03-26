
import Graphs.LineDiagram
import scalafx.application.JFXApp
import scalafx.scene.Scene
import scalafx.scene.layout._
import scalafx.Includes._
import scalafx.geometry.Point2D.Zero.x
import scalafx.geometry.{Insets, Pos}
import scalafx.scene.control.Button
import scalafx.scene.paint.Color
import scalafx.scene.paint.Color._
import scalafx.scene.control.MenuItem
import scalafx.scene.control.Menu
import scalafx.scene.control.MenuBar
import scalafx.scene.shape.Circle


object Interface extends JFXApp {

stage = new JFXApp.PrimaryStage {
    title.value = "Visualization of numerical data"
    width = 1291
    height = 693
}
def width() = diagram.width
def height() = diagram.height

// Parts of the interface
val diagram = new Pane
val m = new Menu("File")
val add = new Menu("Add")
val sideBar = new VBox {
  minWidth = 190
}

// Background color of sideBar
sideBar.background = new Background(Array(new BackgroundFill((Color.rgb(186, 188, 190)), CornerRadii.Empty, Insets.Empty)))

 val file = new MenuItem("Yes")

 // To add graphs
 val line = new MenuItem("Line diagram")
 val pie = new MenuItem("Pie diagram")
 val bar = new MenuItem("Bar chart")
 val histo = new MenuItem("Histogram")

  // When chosen what graph to use, calls the method which makes it
  line.onAction = (event) => makeLineDiagram()

  m.items += file
  add.items += (line, pie, bar, histo)

  val mb = new MenuBar()
  mb.menus += (m, add)


val root = new BorderPane {
  center = diagram
  top = mb
  left = sideBar
}

val scene = new Scene(root)
stage.scene = scene







// To make a line diagram
def addDots() = {
    diagram.children ++= LineDiagram.doDots()
}

// To make a line diagram
def addLines() = {
    diagram.children ++= LineDiagram.doLines()
}

def makeLineDiagram() = {
   addDots()
   addLines()
 }

}