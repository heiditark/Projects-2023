
import Graphs.LineDiagram
import scalafx.application.JFXApp
import scalafx.scene.Scene
import scalafx.scene.layout._
import scalafx.Includes._
import scalafx.geometry.Insets
import scalafx.scene.control.Button
import scalafx.scene.paint.Color._

object Interface extends JFXApp {

stage = new JFXApp.PrimaryStage {
    title.value = "Visualization of numerical data"
    width = 1291
    height = 693
}

/*
Create root gui component, add it to a Scene
and set the current window scene.
*/

val root = new BorderPane {
    padding = Insets(25)
    center = new Pane
}
val scene = new Scene(root)
stage.scene = scene

/* Button
val button = new Button("Add a line diagram")
button.onAction = (event) => {
    makeLineDiagram()
} */

// To make a line diagram
def addDots() = {
  var dotCount = LineDiagram.arrangedDataPoints.length
  def addDot(index: Int) = LineDiagram.doDots()(index)
  for(i <- 0 until dotCount){
    root.children += addDot(i)
  }
}

// To make a line diagram
def addLines() = {
  var lineCount = LineDiagram.arrangedDataPoints.length - 1
  def addLine(index: Int) = LineDiagram.doLines()(index)
  for(i <- 0 until lineCount){
    root.children += addLine(i)
  }
}

def makeLineDiagram() = {
   addDots()
   addLines()
 }

 makeLineDiagram()

}