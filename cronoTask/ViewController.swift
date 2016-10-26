//
//  ViewController.swift
//  cronoTask
//
//  Created by Alberto Banet Masa on 19/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import UIKit

enum EstadoCelda {
    case seleccionada
    case noSeleccionada
}



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
    var volviendoDeAddTarea = false
    var volviendoDeAddOcurrencia = false
    var volviendoDeBorrarTarea = false
    var renombrandoTarea = false
    
   var startTime = TimeInterval()
   var timer = Timer()
   

  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tabla.delegate = self
    self.tabla.dataSource = self
    self.bbdd.delegate = self
    
//    self.tableView(self.tabla, didSelectRowAt: indiceCronometroFuncionando)
//    if bbdd.tareas.count > 0, let acumulado = bbdd.tareas[indiceCronometroFuncionando.row].tiempoAcumulado {
//        relojTiempoTotal = Reloj(tiempo: acumulado)
//        lblSegundoContador.text = relojTiempoTotal.tiempo
//    }
  }

  
  deinit {
        NotificationCenter.default.removeObserver(self)
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
        // Estado de la celda = seleccionada
        let celda = tableView.cellForRow(at: indexPath) as! TaskTableViewCell
        celda.estado = .seleccionada
        
        if volviendoDeAddTarea  {
           // caso de que se haya creado una nueva tarea
            ocurrenciaActual = Ocurrencia()
            //Recien añadida la tarea ponemos los contadores a cero
            relojTiempoTotal = Reloj()
            lblPrimerContador.text = relojTiempoTotal.tiempo
            lblSegundoContador.text = relojTiempoTotal.tiempo
            volviendoDeAddTarea = false
        } else if volviendoDeAddOcurrencia {
            let descrTarea = bbdd.tareas[indexPath.row].descripcion // La descripción será única
            if let id = bbdd.idParaTarea(descrip: descrTarea) {
                ocurrenciaActual = Ocurrencia(idTask:id) // se añadió una ocurrencia y al volver tienen que actualizarse los relojes.
                lblPrimerContador.text = ocurrenciaActual.reloj.tiempo
                lblSegundoContador.text = relojTiempoTotal.tiempo
            }
            volviendoDeAddOcurrencia = false
            
        } else if indiceCronometroFuncionando.row == indexPath.row && !volviendoDeBorrarTarea { // se ha pulsado sobre la misma entrada
            
                    if cronometrando {
                        pararCronometro()
                        cronometrando = false
                    } else { // no se estaba cronometrando
                        // si el reloj de la ocurrencia actual está a cero es que es la primera vez que se va a cronometrar. Esa es la fecha de la ocurrencia
                        if ocurrenciaActual.reloj.aCero() {
                            let unaFecha = Fecha()
                            ocurrenciaActual.fecha = unaFecha.fecha
                            ocurrenciaActual.hora = unaFecha.hora
                        }
                            iniciarCronometro()
                            cronometrando = true
                    }
            
        } else { // se ha pulsado sobre una celda no seleccionada
            
            volviendoDeBorrarTarea = false
            
            pararCronometro()
            cronometrando = false
            self.indiceCronometroFuncionando = indexPath
            let descrTarea = bbdd.tareas[indexPath.row].descripcion // La descripción será única
            if let id = bbdd.idParaTarea(descrip: descrTarea) {
                if let ocurrenciaTareaSeleccionada = bbdd.ocurrencias[id] {
                    ocurrenciaActual = ocurrenciaTareaSeleccionada
                } else {
                    ocurrenciaActual = Ocurrencia(idTask:id)
                }
                 lblPrimerContador.text = ocurrenciaActual.reloj.tiempo
                if let acumulado = bbdd.tareas[indexPath.row].tiempoAcumulado {
                    relojTiempoTotal = Reloj.sumar(reloj1: ocurrenciaActual.reloj, reloj2: Reloj(tiempo: acumulado))
                    lblSegundoContador.text = relojTiempoTotal.tiempo
                } else {
                    relojTiempoTotal = ocurrenciaActual.reloj
                    lblSegundoContador.text = relojTiempoTotal.tiempo
                }
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Estado de la celda = noSeleccionada
        let celda = tableView.cellForRow(at: indexPath) as! TaskTableViewCell
        celda.estado = .noSeleccionada
        
        // Guardamos la ocurrencia de la que venimos
        let descrTarea = bbdd.tareas[indexPath.row].descripcion // La descripción será única
        if let id = bbdd.idParaTarea(descrip: descrTarea) {
            let ocurrencia = Ocurrencia(idTask: id, tiempo: self.lblPrimerContador.text!)
            bbdd.ocurrencias[id] = ocurrencia
        }
    }
    
    

    // MARK: Preparación del segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if cronometrando {
            cronometrando = false
            pararCronometro()
        }
        if (segue.identifier == "segueNuevaTarea") {
            // pass data to next view
            let destinoVC = segue.destination as! NuevaTareaViewController
            destinoVC.delegate = self
            
            if self.renombrandoTarea {
                destinoVC.renombrando = true
                destinoVC.nombreInicial = bbdd.tareas[(tabla.indexPathForSelectedRow?.row)!].descripcion
            } 
            
        }
    }
    
    @IBAction func btnCrearNuevaTareaPulsado(_ sender: AnyObject) {
        self.renombrandoTarea = false
        // asegurar de qeu se guarda la ocurrencia que estuviera seleccionada (de existir alguna tarea seleccionada)
        if let indice = tabla.indexPathForSelectedRow {
            self.tableView(self.tabla, didDeselectRowAt: indice)
        }
    }
    
} // class ViewController




// MARK: writeValueBackDelegate
// Volviendo del viewController de Nueva Tarea
//
// Protocolo definido en NuevaTareaViewController
extension ViewController: writeValueBackDelegate {
    func writeValueBack(value: String, renombrando: Bool, nombreInicial: String?) {
        
        if cronometrando {
            cronometrando = false
            pararCronometro()
        }
        
        print("Recibiendo por el protocolo la tarea \(value)")
        let task: Tarea = Tarea(descripcion: value.sinEspaciosExtremos)
        if bbdd.existeTarea(t: task) {
            // Informar de que la tarea ya existe
            let alert = UIAlertController(title: "TareaExiste".localized,
                                          message: String.localizedStringWithFormat(NSLocalizedString("MensajeTareaExiste",comment:""),task.descripcion),
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel))
            let action = UIAlertAction(title: "Ok".localized, style: .default) { [unowned self] action in
                self.performSegue(withIdentifier: "segueNuevaTarea", sender: nil)
            }
            alert.addAction(action)
            self.present(alert, animated: true)
            
        } else { // La tarea no existe
            if renombrandoTarea {
                // renombrar la tarea
                if let nombreAnteriorTarea = nombreInicial {
                    if let tareaAntigua = bbdd.tareaConDescripcion(nombreInicial!) {
                        bbdd.renombrarTarea(tareaAntigua, anteriorNombre: nombreAnteriorTarea, nuevoNombre:value)
                    }
                }
            } else {
                // Añadiendo tarea
                volviendoDeAddTarea = true
                bbdd.tareas.insert(task, at: 0) // la insertamos al comienzo del array. Insertar antes de añadir a la base de datos.
                self.tabla.reloadData()
                indiceCronometroFuncionando = IndexPath(row:0, section:0)
                self.tabla.selectRow(at: indiceCronometroFuncionando, animated: true, scrollPosition: UITableViewScrollPosition.top) // cronómetro parado y seleccionada la primera celda (nueva tarea)
                self.tabla.cellForRow(at: indiceCronometroFuncionando)?.setSelected(true, animated: true)
                
                self.deseleccionarCeldasTabla() // para evitar que queden selecciones marcadas
                self.tableView(self.tabla, didSelectRowAt: IndexPath(row:0, section:0))
                bbdd.addTask(tarea: task)  // insertamos en la base de datos
                print("tareas: \(bbdd.tareas)")
            }
            }
    }
    
    func deseleccionarCeldasTabla() {
        // Recorre las celdas de la tabla y las pone con el estado a no seleccionadas
        for cell in tabla.visibleCells {
            let celda = cell as! TaskTableViewCell
            celda.estado = EstadoCelda.noSeleccionada
        }
    }
}


// MARK: protocoloActualizarBBDD
// Protocolo definido en TaskDatabase
extension ViewController: protocoloActualizarBBDD {
    func actualizarBBDD() {
        // Modif 01-10-2016 -> nos aseguramos de que se actualiza en la main queue por si se llama desde otro thread
        DispatchQueue.main.async {
            self.tabla.reloadData()
        }
    }
}

// MARK: MGSwipeTableCellDelegate
extension ViewController: MGSwipeTableCellDelegate {
    func swipeTableCell(_ cell: MGSwipeTableCell!, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        if cronometrando {
            cronometrando = false
            pararCronometro()
        }
        
                // ¿Qué opción se ha pulsado?
        if (direction == MGSwipeDirection.leftToRight && index == 0) {
            print("Presionado botón de borrado")
           
            
            if let indice = self.tabla.indexPath(for: cell)?.row {
                let descripcionTarea = self.bbdd.tareas[indice].descripcion
                let alert = UIAlertController(title: "Borrar Tarea".localized,
                                              message: String.localizedStringWithFormat(NSLocalizedString("mensajeBorrarTarea",comment:""),descripcionTarea),
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel))
                let action = UIAlertAction(title: "Ok".localized, style: .default) { [unowned self] action in
                    self.volviendoDeBorrarTarea = true
                    self.indiceCronometroFuncionando = self.tabla.indexPath(for: cell)! // Al hacer un swipe sobre la celda el cronómetro que estaba funcionando tiene que perder el foco.
                    let tarea = self.bbdd.tareas[indice]
                    self.bbdd.tareas.remove(at: indice)
                    self.tabla.reloadData()
                    _ = self.bbdd.removeTask(tarea: tarea)
                    
                    DispatchQueue.main.async {
                        // llevarla al row-1 (si existe) y no hacer scroll.
                        var nuevoIndicePosicionamientoTrasBorrado = IndexPath(row: 0, section: 0)
                        if self.indiceCronometroFuncionando.row > 1 { // se borra de la 3 en adelante
                            nuevoIndicePosicionamientoTrasBorrado = IndexPath(row: self.indiceCronometroFuncionando.row - 1, section: 0)
                        }
                        if self.tabla.numberOfRows(inSection: 0) > 0 {
                            self.tabla.selectRow(at: nuevoIndicePosicionamientoTrasBorrado, animated: true, scrollPosition: UITableViewScrollPosition.none)
                            self.tableView(self.tabla, didSelectRowAt: nuevoIndicePosicionamientoTrasBorrado)
                        } else {
                            self.lblPrimerContador.text = "--:--,--"
                            self.lblSegundoContador.text = "--:--,--"
                        }
                    }
                    
                }
                alert.addAction(action)
                present(alert, animated: true)

                
            }
            
        } else {
             // se ha desplazado la celda de izquiera a derecha. Botones de Reset e Historial
            switch index {
            case 0:
                print("Presionado botón de Añadir / Save ")
                // Añadir ocurrencia a la base de datos y poner el reloj a cero
                if !ocurrenciaActual.reloj.aCero() {
                    if ocurrenciaActual.idTask != nil {
                        self.bbdd.addOcurrencia(ocurrenciaActual)
                    } else { // es la primera vez que se añade la ocurrencia y todavía no tiene idTask.
                        if let indice = self.tabla.indexPath(for: cell)?.row {
                            let descripcionTarea = self.bbdd.tareas[indice].descripcion
                            if let id = bbdd.idParaTarea(descrip: descripcionTarea) {
                                ocurrenciaActual.idTask = id
                                self.bbdd.addOcurrencia(ocurrenciaActual)
                                ocurrenciaActual.saved = true
                            }
                        }
                    }
                    volviendoDeAddOcurrencia = true
                     if let indice = self.tabla.indexPath(for: cell) {
                        self.tableView(self.tabla, didSelectRowAt: indice)
                    }

                }
     
            case 1:
                print("Presionado botón de Historial")
                if let indice = self.tabla.indexPath(for: cell)?.row {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let historicoVC = storyboard.instantiateViewController(withIdentifier: "HistoricoVC") as! HistoricoViewController
                    historicoVC.bbdd = self.bbdd
                    historicoVC.literalTarea = bbdd.tareas[indice].descripcion
                    self.present(historicoVC, animated: true, completion: nil)
                }
                
            case 2:
                print("Presionado el botón de Rename")
                self.renombrandoTarea = true
                self.performSegue(withIdentifier: "segueNuevaTarea", sender: nil)
            default:
                print("Esto no debería de salir nunca")
                
            }
        }
        return true
    }
    
    func swipeTableCellWillBeginSwiping(_ cell: MGSwipeTableCell!) {
        // al detectar swipe la celda queda seleccionada
        let indiceCeldaSwipeada = self.tabla.indexPath(for: cell)!
        self.tabla.selectRow(at: indiceCeldaSwipeada, animated: true, scrollPosition: UITableViewScrollPosition.none)
        self.tableView(self.tabla, didSelectRowAt: indiceCeldaSwipeada)
        // paramos cronómetro
        cronometrando = false
        pararCronometro()
    }
    
    // MARK: Memento Pattern Design
//    func saveCurrentState() {
//        UserDefaults.standard.set(indiceCronometroFuncionando.row, forKey: "tareaActual")
//    }
//    
//    func loadPreviousState() {
//        // Si no existe lo situa en la 0,0
//        indiceCronometroFuncionando = IndexPath(row:UserDefaults.standard.integer(forKey: "tareaActual"), section:0)
//    }
    
}
