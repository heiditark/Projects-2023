
import Graphs.LineDiagram
import scalafx.application.JFXApp
import scalafx.scene.Scene
import scalafx.scene.layout._
import scalafx.Includes._
import scalafx.geometry.Insets
import scalafx.scene.control.Button
import scalafx.scene.paint.Color
import scalafx.scene.paint.Color._

object Interface extends JFXApp {

stage = new JFXApp.PrimaryStage {
    title.value = "Visualization of numerical data"
    width = 1291
    height = 693
}

// Parts of the interface
val diagram = new Pane
val topMenu = new VBox(20)
val sideBar = new HBox {
  minWidth = 190
}

// Background color of topMenu and sideBar
topMenu.background = new Background(Array(new BackgroundFill((Color.rgb(215, 215, 215)), CornerRadii.Empty, Insets.Empty)))
sideBar.background = new Background(Array(new BackgroundFill((Color.rgb(186, 188, 190)), CornerRadii.Empty, Insets.Empty)))

// Buttons 'Add' and 'File'
val addGraphButton = new Button("Add")
val fileButton = new Button("File")
addGraphButton.onAction = (event) => makeLineDiagram()

topMenu.children += (fileButton, addGraphButton)



val root = new BorderPane {
  center = diagram
  top = topMenu
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