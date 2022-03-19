
import Graphs.LineDiagram
import scalafx.application.JFXApp
import scalafx.scene.Scene
import scalafx.scene.layout.Pane
import scalafx.Includes._


/*
Creation of a new primary stage (Application window).
We can use Scala's anonymous subclass syntax to get quite
readable code.
*/
object Interface extends JFXApp {

stage = new JFXApp.PrimaryStage {
    title.value = "Visualization of numerical data"
    width = 500
    height = 400
}

/*
Create root gui component, add it to a Scene
and set the current window scene.
*/

val root = new Pane //Simple pane component
val scene = new Scene(root){ //Scene acts as a container for the scene graph
}
stage.scene = scene

def addDots() = {
  var dotCount = LineDiagram.arrangedDataPoints.length
  def addDot(index: Int) = LineDiagram.doDots()(index)
  for(i <- 0 until dotCount){
    root.children += addDot(i)
  }
}

    addDots()

}