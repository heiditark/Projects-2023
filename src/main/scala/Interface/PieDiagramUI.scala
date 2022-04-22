package Interface

import Graphs.PieDiagram
import scalafx.scene.text.Text
import Interface._
import scalafx.Includes.observableList2ObservableBuffer
import scalafx.scene.control.{Button, CheckBox}


//noinspection FieldFromDelayedInit
object PieDiagramUI extends UIController {
  // Controllers of pie diagram

  val cbPieInfo = new CheckBox("Info")
  cbPieInfo.setIndeterminate(false)
  cbPieInfo.onAction = (event) => PieDiagramUI.makePieDiagram()

  val pieColor = new Button("Change")
  pieColor.onAction = (event) => {
    PieDiagram.changeColor()
    PieDiagramUI.makePieDiagram()
  }

  val backPieColor = new Button("Back")
  backPieColor.onAction = (event) => {
    PieDiagram.unChangeColor()
    PieDiagramUI.makePieDiagram()
  }

  val pieTitle = titleBox()

  val changeTitlePie = new Button("OK")
  changeTitlePie.onAction = (event) => {
    PieDiagram.title = pieTitle.getText
    pieTitle.setText("")
    PieDiagramUI.makePieDiagram()
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
    val colorbox = hbox()
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
    val titleHBox = hbox()
    changeTitleBox.getChildren.add(titleHBox)
    titleHBox.getChildren.add(pieTitle)
    titleHBox.getChildren.add(changeTitlePie)

  }
}
