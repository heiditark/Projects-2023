package Interface

import Graphs.BarCharProject
import Graphs.PieDiagram.colorGenerator
import scalafx.scene.text.Text
import Interface._
import scalafx.Includes.observableList2ObservableBuffer
import scalafx.Includes._
import scalafx.scene.control.{Button, CheckBox, ColorPicker}




//noinspection FieldFromDelayedInit
object BarChartUI extends UIController {
  // Controllers of bar chart

  val colorPickerBar = new ColorPicker(colorGenerator())
  colorPickerBar.onAction = (event) => BarChartUI.makeBarChart()

  val resizeGridPlusBar = new Button("+")
  resizeGridPlusBar.onAction = (event) => {
    if(BarCharProject.gridSize > 6) {
      BarCharProject.gridSize -= 2
      BarCharProject.addStampsOnY()
      BarChartUI.makeBarChart()
    }
  }

  val resizeGridMinusBar = new Button("-")
  resizeGridMinusBar.onAction = (event) => {
    if(BarCharProject.gridSize <= 18) {
      BarCharProject.gridSize += 2
      BarCharProject.addStampsOnY()
      BarChartUI.makeBarChart()
    }
  }

  val cbGridBar = new CheckBox("Grid")
  cbGridBar.setIndeterminate(false)
  cbGridBar.onAction = (event) => {
    BarChartUI.makeBarChart()
  }

  val cbBarInfo = new CheckBox("Values")
  cbBarInfo.setIndeterminate(false)
  cbBarInfo.onAction = (event) => BarChartUI.makeBarChart()

  val barTitle = titleBox()

  val changeTitleBar = new Button("OK")
  changeTitleBar.onAction = (event) => {
    BarCharProject.title = barTitle.getText
    barTitle.setText("")
    BarChartUI.makeBarChart()
  }

  val barTitleY = titleBox()

  val changeTitleYBar = new Button("OK")
  changeTitleYBar.onAction = (event) => {
    BarCharProject.titleY = barTitleY.getText
    barTitleY.setText("")
    BarChartUI.makeBarChart()
  }

  def doBarInfo() = {
    diagram.children ++= BarCharProject.info()
  }

  def addGridBar() =
    diagram.children ++= BarCharProject.grid

  def makeBarChart() = {
    emptyDiagram()

    BarCharProject.color = colorPickerBar.getValue

    val colorVbox = vbox()
    sideBar.getChildren.add(colorVbox)
    colorVbox.getChildren.add(new Text("Color of Bar:"))
    colorVbox.getChildren.add(colorPickerBar)

    val valueVbox = vbox()
    sideBar.getChildren.add(valueVbox)
    valueVbox.getChildren.add(new Text("Show Values:"))
    valueVbox.getChildren.add(cbBarInfo)

    val gridVbox = vbox()
    sideBar.getChildren.add(gridVbox)
    gridVbox.getChildren.add(new Text("Add Grid:"))
    gridVbox.getChildren.add(cbGridBar)

    if(cbGridBar.isSelected) {
      val resizeGridHBox = hbox()
      resizeGridHBox.getChildren.add(resizeGridMinusBar)
      resizeGridHBox.getChildren.add(resizeGridPlusBar)
      gridVbox.getChildren.add(resizeGridHBox)
      addGridBar()
    }

    val changeTitleBox = vbox()
    sideBar.getChildren.add(changeTitleBox)
    changeTitleBox.getChildren.add(new Text("Change Title:"))
    val titleHBox = hbox()
    changeTitleBox.getChildren.add(titleHBox)
    titleHBox.getChildren.add(barTitle)
    titleHBox.getChildren.add(changeTitleBar)

    val changeNameY = vbox()
    sideBar.getChildren.add(changeNameY)
    changeNameY.getChildren.add(new Text("Change Title of Axis:"))
    val titleYHBox = hbox()
    changeNameY.getChildren.add(titleYHBox)
    titleYHBox.getChildren.add(barTitleY)
    titleYHBox.getChildren.add(changeTitleYBar)

    if(cbBarInfo.isSelected) doBarInfo()
    diagram.children ++= BarCharProject.doBars()
    diagram.children ++= BarCharProject.axis
    diagram.children ++= BarCharProject.stampsOnY
    diagram.children += BarCharProject.addTitle
    diagram.children += BarCharProject.addTitleY
  }


}
