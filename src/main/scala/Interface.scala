
import scalafx.application.JFXApp
import scalafx.scene.Scene
import scalafx.scene.layout.Pane


/*
Creation of a new primary stage (Application window).
We can use Scala's anonymous subclass syntax to get quite
readable code.
*/
object Interface extends JFXApp {

stage = new JFXApp.PrimaryStage {
    title.value = "Hello Stage"
    width = 600
    height = 450
}

/*
Create root gui component, add it to a Scene
and set the current window scene.
*/

val root = new Pane //Simple pane component
val scene = new Scene(root) //Scene acts as a container for the scene graph
stage.scene = scene

}