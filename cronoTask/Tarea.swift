//
//  Tarea.swift
//  cronoTask
//
//  Created by Alberto Banet on 27/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import Foundation

class Tarea {
    var idTarea: String?
    var descripcion: String
    var fechaCreacion: String
    var horaCreacion: String
    var fechaUltimaVezUtilizada: String
    var tiempoAcumulado: String?
    
    var ocurrencias: [Ocurrencia]?
    
    
    init(descripcion: String, fecha: String, hora: String, fechaUltimaVez: String) {
        self.descripcion = descripcion
        self.fechaCreacion = fecha
        self.horaCreacion = hora
        self.fechaUltimaVezUtilizada = fechaUltimaVez
        
    }
    
    convenience init(id: String, descripcion: String, fecha: String, hora: String, fechaUltimaVez: String) {
        self.init(descripcion: descripcion, fecha: fecha, hora: hora, fechaUltimaVez: fechaUltimaVez)
        self.idTarea = id
    }
    
    convenience init(descripcion:String) {
        let unaFecha = Fecha()
        self.init(descripcion: descripcion, fecha: unaFecha.fecha, hora: unaFecha.hora, fechaUltimaVez: unaFecha.fecha)
    }
    
    
}

extension Tarea: Equatable {
    static func == (lhs: Tarea, rhs: Tarea) -> Bool {
        return lhs.descripcion == rhs.descripcion
    }
}


