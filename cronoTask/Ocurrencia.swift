//
//  Ocurrencia.swift
//  cronoTask
//
//  Created by Alberto Banet on 27/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import Foundation

class Ocurrencia {
    var idTask: String?  // tarea a la que pertenece
    var fecha: String
    var hora: String
    var reloj: Reloj
    
    init() {
        self.reloj = Reloj()
        
        let unaFecha = Fecha()
        fecha = unaFecha.fecha
        hora = unaFecha.hora
        
    }
    
    init(idTask: String, tiempo: String) {
        self.idTask = idTask
        self.reloj = Reloj(tiempo: tiempo)
        
        let unaFecha = Fecha()
        fecha = unaFecha.fecha
        hora = unaFecha.hora
    }
    
    init(idTask: String, fecha: String, hora:String, tiempo:String) {
        self.idTask = idTask
        self.fecha = fecha
        self.hora = hora
        self.reloj = Reloj(tiempo: tiempo)
    }
    
    
    
}
