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
    var indiceCronometroFuncionando: IndexPath = IndexPath()
    var cronometrando: Bool = false
    
    
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
    let currentTime = Date.timeIntervalSinceReferenceDate
    var tiempoPasado: TimeInterval = currentTime - startTime
    
    
    let horas = UInt8(tiempoPasado/3600.0)
    tiempoPasado -= TimeInterval(horas)*3600.0
    
    let minutos = UInt8(tiempoPasado/60.0)
    tiempoPasado -= (TimeInterval(minutos)*60)
    
    let segundos = UInt8(tiempoPasado)
    tiempoPasado -= TimeInterval(segundos)
    
    let fraccion = UInt8(tiempoPasado * 100)
    let strHoras = String(format:"%02d", horas)
    let strMinutos = String(format:"%02d",minutos)
    let strSegundos = String(format:"%02d", segundos)
    let strFracciones = String(format:"%02d",fraccion)
    
    self.lblPrimerContador.text = "\(strMinutos):\(strSegundos),\(strFracciones)"
    self.lblSegundoContador.text = self.lblPrimerContador.text
    
    
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
        self.indiceCronometroFuncionando = indexPath
        if cronometrando {
            cronometrando = false
            pararCronometro()
        } else {
            cronometrando = true
            iniciarCronometro()
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
            if let indice = self.tabla.indexPath(for: cell)?.row {
                let tarea = bbdd.tareas[indice]
                bbdd.tareas.remove(at: indice)
                _ = bbdd.removeTask(tarea: tarea)
            }
            
        }
        return true
    }
}
