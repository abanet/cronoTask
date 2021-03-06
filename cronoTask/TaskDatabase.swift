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
    var ocurrencias: [String:Ocurrencia] = [String:Ocurrencia]() // diccionario que mantiene los acumulados de ocurrencias.
    
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
                    let sql_crear_ocurrencias = "CREATE TABLE IF NOT EXISTS OCURRENCIAS (ID INTEGER PRIMARY KEY AUTOINCREMENT, IDTASK INTEGER, FECHA TEXT, HORA TEXT, TIEMPO TEXT)"
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

    // MARK: Tratamiento de las tareas
    
    // ¿Existe una tarea con esa misma descripcion en la base de datos?
    func existeTarea(t:Tarea) -> Bool {
        for unaTarea in tareas {
            if unaTarea == t {
                return true
            }
        }
        return false
    }
    
    // Encontrar una tarea dada la descripción
    func tareaConDescripcion(_ descripcion: String) -> Tarea? {
        for unaTarea in tareas {
            if unaTarea.descripcion == descripcion {
                return unaTarea
            }
        }
        return nil
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
                    //delegate?.actualizarBBDD()
                    print("Tarea añadida")
                    
                }
            }
        }
    }
    
    
    // Eliminar Tarea
    // TODO: eliminar las ocurrencias asociadas a dicha tarea
    func removeTask(tarea:Tarea)->Bool {
        if let id = tarea.idTarea { //si no hay identificador se está intentando borrar una tarea que aún no ha sido grabada.
        if let database = FMDatabase(path: self.databasePath) {
            if database.open() {
                let deleteSQL = "DELETE FROM TASKS WHERE ID = '\(id)'"
                let resultado = database.executeUpdate(deleteSQL, withArgumentsIn: nil)
                if !resultado {
                    print("Error: \(database.lastErrorMessage())")
                    return false
                } else {
                    removeOcurrencias(idTask: id)
                    delegate?.actualizarBBDD()
                    print("Tarea eliminada")
                }
            }
        }
    }
        return true
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
                    tarea.tiempoAcumulado = calcularTiempoAcumulado(idTask: tarea.idTarea!)
                    arrayResultado.append(tarea)
                }
            } else {
                // problemas al abrir la base de datos
            }
        }
        delegate?.actualizarBBDD()
        return arrayResultado
    }
    
    func idParaTarea(descrip: String) -> String? {
      // Primero buscamos en la caché: el array de tareas
      
        for tarea in self.tareas {
            if tarea.descripcion == descrip {
              if tarea.idTarea != nil {
                return tarea.idTarea
              } else {
                break
              }
            }
        }
       // y si no estaba lo buscamos en la base de datos.
            if let database = FMDatabase(path: self.databasePath) {
                if database.open() {
                    let selectSQL = "SELECT ID FROM TASKS WHERE DESCRIPCION = '\(descrip)'"
                    let resultado: FMResultSet? = database.executeQuery(selectSQL, withArgumentsIn: nil)
                    if resultado!.next() {
                        return resultado!.string(forColumn: "ID")
                    }
                    database.close()
                }
            }
      
        return nil
    }
    
    func renombrarTarea(_ task:Tarea, anteriorNombre: String, nuevoNombre:String) {
        
        // Realizamos el cambio en la base de datos
        if let id = task.idTarea {
            if let database = FMDatabase(path: self.databasePath) {
                if database.open() {
                    let modifySQL = "UPDATE TASKS SET DESCRIPCION = '\(task.descripcion)' WHERE ID = '\(id)'"
                    print("Modificando Tarea: \(modifySQL)")
                    let resultado = database.executeUpdate(modifySQL, withArgumentsIn: nil)
                    if !resultado {
                        print("Error: \(database.lastErrorMessage())")
                    } else {
                        // cambiamos el nombre en el array
                        renombrarTareaEnArray(anteriorNombre: anteriorNombre, nuevoNombre: nuevoNombre)
                        print("Tarea modificada.")
                        delegate?.actualizarBBDD()
                    }
                }
            }
        } else {
            // cambiamos el nombre en el array
            renombrarTareaEnArray(anteriorNombre: anteriorNombre, nuevoNombre: nuevoNombre)
        }
    }
    
    
    // Recorre el array de tareas y realiza un cambio de nombre.
    func renombrarTareaEnArray(anteriorNombre: String, nuevoNombre:String) {
        for (indice, unaTarea) in tareas.enumerated() {
            if unaTarea.descripcion == anteriorNombre {
                unaTarea.descripcion = nuevoNombre
                tareas[indice] = unaTarea
                break
            }
        }
    }
    // MARK: Tratamiento de las Ocurrencias
    
    // Graba una Ocurrencia a la base de datos
    func addOcurrencia(_ ocu: Ocurrencia) {
        if let database = FMDatabase(path: self.databasePath) {
            if database.open() {
                let insertSQL = "INSERT INTO OCURRENCIAS (IDTASK, FECHA, HORA, TIEMPO) VALUES ('\(ocu.idTask!)', '\(ocu.fecha)', '\(ocu.hora)', '\(ocu.reloj.tiempo)')"
                print("addOcurrencia: \(insertSQL)")
                let resultado = database.executeUpdate(insertSQL, withArgumentsIn: nil)
                if !resultado {
                    print("Error: \(database.lastErrorMessage())")
                } else {
                    print("Ocurrencia añadida")
                    
                }
            }
        }
    }
    // Graba el array de ocurrencias a la base de datos
    func grabarOcurrenciasBBDD() {
        for (_ , unaOcurrencia) in self.ocurrencias {
            addOcurrencia(unaOcurrencia)
        }
    }
    
    // Elimina las ocurrencias asociadas a una tarea concreta.
    func removeOcurrencias(idTask id:String) {
            if let database = FMDatabase(path: self.databasePath) {
                if database.open() {
                    let deleteSQL = "DELETE FROM OCURRENCIAS WHERE IDTASK = '\(id)'"
                    let resultado = database.executeUpdate(deleteSQL, withArgumentsIn: nil)
                    if !resultado {
                        print("Error: \(database.lastErrorMessage())")
                    } else {
                        print("Ocurrencia eliminada")
                    }
                }
            }
        }
    
    
    // Se leen las ocurrencias que hay almacenadas en la base de datos y se devuelven en un array.
    func leerOcurrencias(idTask:String) -> [Ocurrencia] {
        var arrayResultado = [Ocurrencia]()
        if let database = FMDatabase(path: self.databasePath) {
            if database.open() {
                let selectSQL = "SELECT ID, IDTASK, FECHA, HORA, TIEMPO FROM OCURRENCIAS WHERE IDTASK = '\(idTask)'"
                let resultados: FMResultSet? = database.executeQuery(selectSQL, withArgumentsIn: nil)
                while resultados?.next() == true {
                    let ocurrencia: Ocurrencia = Ocurrencia(idTask: resultados!.string(forColumn: "IDTASK"),
                                             fecha: resultados!.string(forColumn: "FECHA"),
                                             hora: resultados!.string(forColumn: "HORA"),
                                             tiempo: resultados!.string(forColumn: "TIEMPO"))
                    arrayResultado.append(ocurrencia)
                }
            } else {
                // problemas al abrir la base de datos
            }
        }
        delegate?.actualizarBBDD()
        print("Ocurrencias leídas:\(arrayResultado)")
        return arrayResultado
    }
    
    
    
    // Calcular un String con el tiempo acumulado de todas las ocurrencias para añadir al acumulado de la tarea
    func calcularTiempoAcumulado(idTask:String) -> String {
        let ocurrencias = self.leerOcurrencias(idTask: idTask)
        var relojFinal = Reloj()
        for unaOcurrencia in ocurrencias {
            relojFinal = Reloj.sumar(reloj1: relojFinal, reloj2:unaOcurrencia.reloj)
        }
        return relojFinal.tiempo
    }
}
