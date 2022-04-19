package Graphs

import java.io.{BufferedReader, FileNotFoundException, FileReader, IOException, Reader}

object fileManagement {

 /* val dataOne = Map(("Car" -> 10), ("Bike" -> 20), ("Bus" -> 50), ("Train" -> 19), ("Metro" -> 4),("Airplane" -> 54))
  val dataTwo = Map(("Koira" -> 13), ("Kissa" -> 8), ("Hevonen" -> 19), ("Pupu" -> 28))
  val data = Map(("Maanantai" -> 100), ("Tiistai" -> 120), ("Keskiviikko" -> 103), ("Torstai" -> 70), ("Perjantai" -> 23), ("Lauantai" -> 85), ("Sunnuntai" -> 180))*/

  def readFile(sourceFile: String): Map[String, Double] = {
    try {
      val fileIn = new FileReader(sourceFile)
      val linesIn = new BufferedReader(fileIn)

      try {
        var graphType = readLine(linesIn).dropWhile(_ != ':').drop(1).trim.toLowerCase
        println(graphType)

        val data = graphType match {
          case "piediagram" =>
            println("joo")
            startOfData(linesIn)
            dataPieOrBar(linesIn)
          case  "barchart" =>
            startOfData(linesIn)
            dataPieOrBar(linesIn)
          case "linediagram" =>
            startOfData(linesIn)
            dataLine(linesIn)
          case other => {
            throw new Exception("Graph type not found.")
            Map[String, Double]()
          }
        }
        data
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
