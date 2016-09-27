//
//  Ocurrencia.swift
//  cronoTask
//
//  Created by Alberto Banet on 27/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import Foundation

class Ocurrencia {
    var idTask: String  // tarea a la que pertenece
    var fecha: String
    var comienzo: TimeInterval
    var final: TimeInterval
    
    init(idTask: String, fecha: String, comienza: TimeInterval, finaliza: TimeInterval) {
        self.idTask = idTask
        self.fecha = fecha
        self.comienzo = comienza
        self.final = finaliza
        
    }
}
