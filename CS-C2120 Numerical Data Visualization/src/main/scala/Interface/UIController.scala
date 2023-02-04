package Interface

import scalafx.geometry.Insets
import scalafx.scene.control.TextField
import scalafx.scene.layout.{HBox, VBox}
import UI._

//noinspection FieldFromDelayedInit
trait UIController {

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
