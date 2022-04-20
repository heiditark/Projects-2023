package Graphs

import java.io.{BufferedReader, FileNotFoundException, FileReader, IOException}
import scala.io.{BufferedSource, Source}
import scala.util.{Try, Using}

object fileManagement {

  var file: String = ""
 // var linesFromFile = Using(Source.fromFile(file)) { _.getLines.toArray }

  def getData = readFile(file)

  def readFile(sourceFile: String)= {
    try {

      val fileIn = new FileReader(sourceFile)
      val linesIn = new BufferedReader(fileIn)

      try {

        var graphType = readLine(linesIn).dropWhile(_ != ':').drop(1).trim.toLowerCase
        val data = graphType match {
          case "piediagram" =>
            startOfData(linesIn)
            PieDiagram.data = Some(dataPieOrBar(linesIn))
            PieDiagram.changeColor()
          case  "barchart" =>
            startOfData(linesIn)
            BarCharProject.data = Some(dataPieOrBar(linesIn))
            BarCharProject.defineN()
            BarCharProject.addStampsOnY()
          case "linediagram" =>
            startOfData(linesIn)
            LineDiagram.data = Some(dataLine(linesIn))
            LineDiagram.flipYCoordAndArrange()
            LineDiagram.autoscale()
          case other => {
            throw new Exception("Graph type not found.")
          }
        }
      } finally {
        fileIn.close()
        linesIn.close()
      }
    } catch {
      case notFound: FileNotFoundException => {
        println("File not found exception.")
        Map[String, Double]()
      }
      case e: IOException => {
        println("Error occured")
        Map[String, Double]()
      }
    }
  }

  def readLine(input: BufferedReader) = {
    input.readLine()
  }

  def startOfData(input: BufferedReader): Unit = {
    var oneLine: String = null
    try {
      while({oneLine = input.readLine(); oneLine != null}) {
        if(oneLine.trim.toLowerCase == "datapoints:") return
      }
    } catch {
      case a: Exception => throw new Exception("Data corrupted.")
    }
  }

  def dataPieOrBar(input: BufferedReader): Map[String, Double] = {
    var oneLine: String = null
    var dataMapped = Map[String, Double]()

    try {
      while({oneLine = input.readLine(); oneLine != null}) {
        if(oneLine != "") {
          val indexOfComma = oneLine.indexWhere(_ == ',')
          if(indexOfComma == -1) throw new Exception("Data corrupted.")

          val splittedAtComma = oneLine.splitAt(indexOfComma)
          val key = splittedAtComma._1.trim
          val value = splittedAtComma._2.filter(_ != ',').trim.toDouble

          dataMapped = dataMapped + (key -> value)
        }
      }
      println(dataMapped)
      dataMapped
    } catch {
      case a: Exception => throw new Exception("Data corrupted.")
    }
  }

  def dataLine(input: BufferedReader): Map[String, Double] = {
    var oneLine: String = null
    var dataMapped = Map[String, Double]()

    try {
      while({oneLine = input.readLine(); oneLine != null}) {
        if(oneLine != "") {
          val withoutBrackets = oneLine.filter(a => a != '(').filter(a => a != ')')
          val indexOfComma = withoutBrackets.indexWhere(_ == ',')
          if(indexOfComma == -1) throw new Exception("Data corrupted.")

          val splittedAtComma = withoutBrackets.splitAt(indexOfComma)
          val x = splittedAtComma._1.trim
          val y = splittedAtComma._2.filter(_ != ',').trim.toDouble

          dataMapped = dataMapped + (x -> y)
        }
      }
      dataMapped
    } catch {
      case a: Exception => throw new Exception("Data corrupted.")
    }
  }

}
