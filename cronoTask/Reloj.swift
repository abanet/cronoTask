//
//  Rejol.swift
//  cronoTask
//
//  Created by Alberto Banet on 29/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import Foundation

enum PosicionesSeparadoresReloj: Int {
    case primerSeparador = 2
    case segundoSeparador = 5
}

enum TipoReloj {
    case horaMinutosSegundos
    case minutosSegundosDecimas
}


// Clase Reloj
// Encargada de mantener las cadenas de tiempos

// Estructura de tiempos:
//      00:00,00 No se ha llegado a 60 minutos
//      00:00:00 Cuando se pasan los 60 minutos. // TODO

class Reloj {
    
    var tipo: TipoReloj = TipoReloj.minutosSegundosDecimas
    var tiempo: String {
        didSet {
            tipo = tipoReloj()
            horas = horasInt()
            minutos = minutosInt()
            segundos = segundosInt()
            centesimas = centesimasInt()
        }
    }
    
    
    private var centesimas: Int = 0
    private var segundos: Int = 0
    private var minutos: Int = 0
    private var horas: Int = 0
    
    init() {
        self.tiempo = "00:00,00" // Estado inicial de un reloj nuevo
        tipo = tipoReloj()
        horas = horasInt()
        minutos = minutosInt()
        segundos = segundosInt()
        centesimas = centesimasInt()
    }
    
    init(tiempo:String) {
        self.tiempo = tiempo
        tipo = tipoReloj()
        horas = horasInt()
        minutos = minutosInt()
        segundos = segundosInt()
        centesimas = centesimasInt()
    }
    
    func actualizaTiemposReloj() {
        tipo = tipoReloj()
        horas = horasInt()
        minutos = minutosInt()
        segundos = segundosInt()
        centesimas = centesimasInt()
    }
    
    func incrementarTiempoUnaCentesima() {
            centesimas = centesimas + 1
            if centesimas == 100 {
                centesimas = 0
                segundos = segundos + 1
                if segundos == 60 {
                    segundos = 0
                    minutos = minutos + 1
                    if minutos == 60 {
                        minutos = 0
                        horas = horas + 1
                    }
                    
                }
                
            }
        
        // Generamos la nueva cadena
        let horasCompletadas, minutosCompletados, segundosCompletados, centesimasCompletadas: String
        
        if String(horas).characters.count == 1 {
            horasCompletadas = "0\(horas)"
        } else { horasCompletadas = "\(horas)" }
        
        if String(minutos).characters.count == 1 {
            minutosCompletados = "0\(minutos)"
        } else { minutosCompletados = "\(minutos)" }
            
        if String(segundos).characters.count == 1 {
            segundosCompletados = "0\(segundos)"
        } else { segundosCompletados = "\(segundos)" }
                
        if String(centesimas).characters.count == 1 {
            centesimasCompletadas = "0\(centesimas)"
        } else { centesimasCompletadas = "\(centesimas)" }
        
         if tipo == .horaMinutosSegundos {
            tiempo = "\(horasCompletadas):\(minutosCompletados):\(segundosCompletados)"
         } else {
            tiempo = "\(minutosCompletados):\(segundosCompletados),\(centesimasCompletadas)"
        }
        
        self.actualizaTiemposReloj()
    }
    
    // Identificación del tipo de reloj que estamos tratando
    private func tipoReloj()->TipoReloj {
        let indice = self.tiempo.index(self.tiempo.startIndex, offsetBy: PosicionesSeparadoresReloj.segundoSeparador.rawValue)
        return (self.tiempo[indice] == ",") ? TipoReloj.minutosSegundosDecimas : TipoReloj.horaMinutosSegundos
    }
    
    // Funciones que extraen el tiempo de las cadenas
    private func horasInt() -> Int {
        if tipo == .horaMinutosSegundos {
            let indice = tiempo.index(tiempo.startIndex, offsetBy:2)
            return Int(tiempo.substring(to: indice))!
        } else {
            return 0
        }
    }
    
    private func minutosInt() -> Int {
        if tipo == .horaMinutosSegundos {
            let start = tiempo.index(tiempo.startIndex, offsetBy:3)
            let end   = tiempo.index(tiempo.startIndex, offsetBy:4)
            return Int(tiempo[start...end])!
        } else {
            let indice = tiempo.index(tiempo.startIndex, offsetBy:2)
            return Int(tiempo.substring(to: indice))!
        }
    }
    
    private func segundosInt() -> Int {
        if tipo == .horaMinutosSegundos {
            let indice = tiempo.index(tiempo.endIndex, offsetBy: -2)
            return Int(tiempo.substring(from: indice))!
        } else {
            let start = tiempo.index(tiempo.startIndex, offsetBy:3)
            let end   = tiempo.index(tiempo.startIndex, offsetBy:4)
            return Int(tiempo[start...end])!
        }

    }
    
    private func centesimasInt() -> Int {
        if tipo == .horaMinutosSegundos {
            return 0
        } else {
            let indice = tiempo.index(tiempo.endIndex, offsetBy: -2)
            return Int(tiempo.substring(from: indice))!
        }
    }
    
}
