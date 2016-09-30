//
//  ViewController.swift
//  cronoTask
//
//  Created by Alberto Banet Masa on 19/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  // Base de datos
    var bbdd: TaskDatabase!
    
  // Tabla que contiene los cronómetros
  @IBOutlet weak var tabla: UITableView!
 
    
  // Cronómetro
    @IBOutlet weak var lblPrimerContador: UILabel!
    @IBOutlet weak var lblSegundoContador: UILabel!
    
    
  // Cronómetro en funcionamiento
    var indiceCronometroFuncionando: IndexPath = IndexPath(row:-1,section:-1)
    var cronometrando: Bool = false
    var ocurrenciaActual: Ocurrencia = Ocurrencia()
    var relojTiempoTotal: Reloj = Reloj()
    
  var startTime = TimeInterval()
  var timer = Timer()

  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tabla.delegate = self
    self.tabla.dataSource = self
    self.bbdd.delegate = self
    
    
    
  }

// MARK: Funciones que manejan el timer de la app.
func iniciarCronometro() {
    let aSelector : Selector = #selector(ViewController.updateTime)
    timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
    startTime = Date.timeIntervalSinceReferenceDate
}
  
func pararCronometro() {
    timer.invalidate()
  }

  
  func updateTime(){
    self.ocurrenciaActual.reloj.incrementarTiempoUnaCentesima()
    self.relojTiempoTotal.incrementarTiempoUnaCentesima()
    self.lblPrimerContador.text = "\(ocurrenciaActual.reloj.tiempo)"
    self.lblSegundoContador.text = "\(relojTiempoTotal.tiempo)"
    
//    lblHoras.text = strMinutos
//    lblMinutos.text = strSegundos
//    lblSegundos.text = strFracciones
  }


// MARK: TableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return bbdd.tareas.count
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.0)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda")! as! TaskTableViewCell
        cell.delegate = self
        cell.lblTarea.text = bbdd.tareas[indexPath.row].descripcion
        
        
        return cell
    }
    
// MARK: TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indiceCronometroFuncionando.row == indexPath.row { // se ha pulsado sobre la misma entrada
            if cronometrando {
                cronometrando = false
                pararCronometro()
                // Guardamos la ocurrencia
                let descrTarea = bbdd.tareas[indexPath.row].descripcion // La descripción será única
                if let id = bbdd.idParaTarea(descrip: descrTarea) {
                    let ocurrencia = Ocurrencia(idTask: id, tiempo: self.lblPrimerContador.text!)
                    bbdd.ocurrencias[id] = ocurrencia
                }
            } else {
                // recuperamos el valor de la ocurrencia
                let descrTarea = bbdd.tareas[indexPath.row].descripcion
                if let id = bbdd.idParaTarea(descrip: descrTarea) {
                    if let ocu = bbdd.ocurrencias[id] {
                        ocurrenciaActual = ocu // valor de la ocurrencia en la sesión abierta
                    }
                }
                iniciarCronometro()
                cronometrando = true
            }
        } else {
            pararCronometro()
            cronometrando = false
            self.indiceCronometroFuncionando = indexPath
            let descrTarea = bbdd.tareas[indexPath.row].descripcion // La descripción será única
            if let id = bbdd.idParaTarea(descrip: descrTarea) {
                if let ocurrenciaTareaSeleccionada = bbdd.ocurrencias[id] {
                    ocurrenciaActual = ocurrenciaTareaSeleccionada
                } else {
                    ocurrenciaActual = Ocurrencia()
                }
                 lblPrimerContador.text = ocurrenciaActual.reloj.tiempo
                if let acumulado = bbdd.tareas[indexPath.row].tiempoAcumulado {
                    relojTiempoTotal = Reloj.sumar(reloj1: ocurrenciaActual.reloj, reloj2: Reloj(tiempo: acumulado))
                    lblSegundoContador.text = relojTiempoTotal.tiempo
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Guardamos la ocurrencia de la que venimos
        let descrTarea = bbdd.tareas[indexPath.row].descripcion // La descripción será única
        if let id = bbdd.idParaTarea(descrip: descrTarea) {
            let ocurrencia = Ocurrencia(idTask: id, tiempo: self.lblPrimerContador.text!)
            bbdd.ocurrencias[id] = ocurrencia
        }
    }
    
    

    // MARK: Preparación del segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueNuevaTarea") {
            // pass data to next view
            let destinoVC = segue.destination as! NuevaTareaViewController
            destinoVC.delegate = self
            
        }
    }
    
} // class ViewController




// MARK: writeValueBackDelegate
// Protocolo definido en NuevaTareaViewController
extension ViewController: writeValueBackDelegate {
    func writeValueBack(value: String) {
        print("Recibiendo por el protocolo la tarea \(value)")
        let task: Tarea = Tarea(descripcion: value)
        bbdd.tareas.insert(task, at: 0) // la insertamos al comienzo del array. Insertar antes de añadir a la base de datos.
        bbdd.addTask(tarea: task)  // insertamos en la base de datos
        
        print("tareas: \(bbdd.tareas)")
    }
}


// MARK: protocoloActualizarBBDD
// Protocolo definido en TaskDatabase
extension ViewController: protocoloActualizarBBDD {
    func actualizarBBDD() {
        self.tabla.reloadData()
    }
}

// MARK: MGSwipeTableCellDelegate
extension ViewController: MGSwipeTableCellDelegate {
    func swipeTableCell(_ cell: MGSwipeTableCell!, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        if (direction == MGSwipeDirection.rightToLeft && index == 0) {
            print("Button Delete tapped")
            cronometrando = false
            pararCronometro()
            
            if let indice = self.tabla.indexPath(for: cell)?.row {
                let alert = UIAlertController(title: "Borrar Tarea",
                                              message: "La tarea y todo su historial se eliminarán de la base de datos",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                let action = UIAlertAction(title: "Ok", style: .default) { [unowned self] action in
                    let tarea = self.bbdd.tareas[indice]
                    self.bbdd.tareas.remove(at: indice)
                    _ = self.bbdd.removeTask(tarea: tarea)
                    self.lblPrimerContador.text = "--:--,--"
                    self.lblSegundoContador.text = "--:--,--"
                }
                alert.addAction(action)
                present(alert, animated: true)

                
            }
            
        }
        return true
    }
    
    
}
