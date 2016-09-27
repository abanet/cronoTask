//
//  TaskDatabase.swift
//  cronoTask
//
//  Created by Alberto Banet on 27/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import UIKit

protocol protocoloActualizarBBDD {
    func actualizarBBDD()
}

class TaskDatabase {
    
    let databaseName = "CronoTask.db"
    let databasePath: String
    var tareas: [Tarea] = [Tarea]()
    
    var delegate: protocoloActualizarBBDD?
    
    // Init de la base de datos
    // Si no existe un fichero CronoTask.db se crea y se crea la estructura de la base de datos.
    // Si ya existe una base de datos se obtienen las tareas que pueda contener.
     init() {
        // Ruta de la base de datos
        let filemgr = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        databasePath = documentsPath.appending("/\(databaseName)")
        print("Base de datos: \(databasePath)")
        
        // Creación de la base de datos o recuperación de las tareas si ya existía
        if !filemgr.fileExists(atPath: databasePath){
            //No existe la base de datos. Creamos la base de datos.
            if let taskDB = FMDatabase(path: databasePath) {
                if taskDB.open() {
                    // tabla de tareas
                    let sql_crear_tareas = "CREATE TABLE IF NOT EXISTS TASKS (ID INTEGER PRIMARY KEY AUTOINCREMENT, DESCRIPCION TEXT, FECHA TEXT, HORA TEXT, ULTIMAVEZ TEXT)"
                    if !taskDB.executeStatements(sql_crear_tareas) {
                        print("Error: \(taskDB.lastErrorMessage())")
                    }
                    // tabla de ocurrencias
                    let sql_crear_ocurrencias = "CREATE TABLE IF NOT EXISTS OCURRENCIAS (ID INTEGER PRIMARY KEY AUTOINCREMENT, IDTASK INTEGER, FECHA TEXT, HORA TEXT, DESCRIPCION TEXT)"
                    if !taskDB.executeStatements(sql_crear_ocurrencias) {
                        print("Error: \(taskDB.lastErrorMessage())")
                    }
                    taskDB.close()
                }
            }
        } else {
            // La base de datos existe.
            if let taskDB = FMDatabase(path: databasePath) {
                taskDB.logsErrors = true
                self.tareas = self.leerTareas()
            }
        }
    }

    
    // Añadir Tareas
    func addTask(tarea:Tarea) {
        if let database = FMDatabase(path: self.databasePath) {
            if database.open() {
                let insertSQL = "INSERT INTO TASKS (DESCRIPCION, FECHA, HORA, ULTIMAVEZ) VALUES ('\(tarea.descripcion)', '\(tarea.fechaCreacion)', '\(tarea.horaCreacion)', '\(tarea.fechaUltimaVezUtilizada)')"
                print("addTask: \(insertSQL)")
                let resultado = database.executeUpdate(insertSQL, withArgumentsIn: nil)
                if !resultado {
                    print("Error: \(database.lastErrorMessage())")
                } else {
                    delegate?.actualizarBBDD()
                    print("Tarea añadida")
                    
                }
            }
        }
    }
    
    // Se leen las tareas que hay almacenadas en la base de datos y se devuelven en un array.
    func leerTareas() -> [Tarea] {
        var arrayResultado = [Tarea]()
        if let database = FMDatabase(path: self.databasePath) {
            if database.open() {
                let selectSQL = "SELECT ID, DESCRIPCION, FECHA, HORA, ULTIMAVEZ FROM TASKS"
                let resultados: FMResultSet? = database.executeQuery(selectSQL, withArgumentsIn: nil)
                while resultados?.next() == true {
                    let tarea: Tarea = Tarea(id: resultados!.string(forColumn: "ID"),
                                                  descripcion: resultados!.string(forColumn: "DESCRIPCION")!,
                                                  fecha: resultados!.string(forColumn: "FECHA"),
                                                  hora: resultados!.string(forColumn: "HORA"),
                                                  fechaUltimaVez: resultados!.string(forColumn: "ULTIMAVEZ"))
                    arrayResultado.append(tarea)
                }
            } else {
                // problemas al abrir la base de datos
            }
        }
        delegate?.actualizarBBDD()
        return arrayResultado
    }
    
    
}
