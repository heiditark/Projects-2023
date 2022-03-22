
import Graphs.LineDiagram
import scalafx.application.JFXApp
import scalafx.scene.Scene
import scalafx.scene.layout._
import scalafx.Includes._
import scalafx.geometry.{Insets, Pos}
import scalafx.scene.control.Button
import scalafx.scene.paint.Color
import scalafx.scene.paint.Color._
import scalafx.scene.control.MenuItem
import scalafx.scene.control.Menu
import scalafx.scene.control.MenuBar


object Interface extends JFXApp {

stage = new JFXApp.PrimaryStage {
    title.value = "Visualization of numerical data"
    width = 1291
    height = 693
}

// Parts of the interface
val diagram = new Pane
// val topMenu = new VBox(20)
val m = new Menu("Open")
val add = new Menu("Add")
val sideBar = new VBox {
  minWidth = 190
}

// Background color of topMenu and sideBar
// topMenu.background = new Background(Array(new BackgroundFill((Color.rgb(215, 215, 215)), CornerRadii.Empty, Insets.Empty)))
sideBar.background = new Background(Array(new BackgroundFill((Color.rgb(186, 188, 190)), CornerRadii.Empty, Insets.Empty)))

 val m1 = new MenuItem("File")

  // To add graphs
 val line = new MenuItem("Line diagram")
 val pie = new MenuItem("Pie diagram")
 val bar = new MenuItem("Bar chart")
 val histo = new MenuItem("Histogram")

  line.onAction = (event) => makeLineDiagram()

  m.items += m1
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