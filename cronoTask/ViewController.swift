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
    

    var timer:Timer?
   

  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("VIEW DID LOAD")
    self.tabla.delegate = self
    self.tabla.dataSource = self
    TaskDatabase.shared.delegate = self
    
  }

  
  deinit {
        NotificationCenter.default.removeObserver(self)
    }

// MARK: Funciones que manejan el timer de la app.
func iniciarCronometro() {
    print("Iniciando timer")
    let aSelector : Selector = #selector(ViewController.updateTime)
    self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
    RunLoop.main.add(self.timer!, forMode: .commonModes)
}
  
func pararCronometro() {
    print("Invalidando Timer")
    self.timer?.invalidate()
}

  
  func updateTime(){
    self.ocurrenciaActual.reloj.incrementarTiempoUnaCentesima()
    self.relojTiempoTotal.incrementarTiempoUnaCentesima()
    self.lblPrimerContador.text = "\(ocurrenciaActual.reloj.tiempo)"
    self.lblSegundoContador.text = "\(relojTiempoTotal.tiempo)"
  }


// MARK: TableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return TaskDatabase.shared.tareas.count
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.0)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda")! as! TaskTableViewCell
        cell.delegate = self
        cell.lblTarea.text = TaskDatabase.shared.tareas[indexPath.row].descripcion
        
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
            let descrTarea = TaskDatabase.shared.tareas[indexPath.row].descripcion // La descripción será única
            if let id = TaskDatabase.shared.idParaTarea(descrip: descrTarea) {
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
            let descrTarea = TaskDatabase.shared.tareas[indexPath.row].descripcion // La descripción será única
            if let identificador = TaskDatabase.shared.idParaTarea(descrip: descrTarea) {
                if let ocurrenciaTareaSeleccionada = TaskDatabase.shared.ocurrencias[identificador] {
                    ocurrenciaActual = ocurrenciaTareaSeleccionada
                } else {
                    ocurrenciaActual = Ocurrencia(idTask:identificador)
                }
                 lblPrimerContador.text = ocurrenciaActual.reloj.tiempo
                if let acumulado = TaskDatabase.shared.tareas[indexPath.row].tiempoAcumulado {
                    relojTiempoTotal = Reloj.sumar(reloj1: ocurrenciaActual.reloj, reloj2: Reloj(tiempo: acumulado))
                    lblSegundoContador.text = relojTiempoTotal.tiempo
                } else {
                    //relojTiempoTotal = ocurrenciaActual.reloj // Está igualando los punteros!!!
                    relojTiempoTotal = ocurrenciaActual.reloj.copy() as! Reloj
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
        let descrTarea = TaskDatabase.shared.tareas[indexPath.row].descripcion // La descripción será única
        if let id = TaskDatabase.shared.idParaTarea(descrip: descrTarea) {
            let ocurrencia = Ocurrencia(idTask: id, tiempo: self.lblPrimerContador.text!)
            TaskDatabase.shared.ocurrencias[id] = ocurrencia
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
                destinoVC.nombreInicial = TaskDatabase.shared.tareas[(tabla.indexPathForSelectedRow?.row)!].descripcion
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
        if TaskDatabase.shared.existeTarea(t: task) {
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
                    if let tareaAntigua = TaskDatabase.shared.tareaConDescripcion(nombreInicial!) {
                        TaskDatabase.shared.renombrarTarea(tareaAntigua, anteriorNombre: nombreAnteriorTarea, nuevoNombre:value)
                    }
                }
            } else {
                // Añadiendo tarea
                volviendoDeAddTarea = true
                TaskDatabase.shared.tareas.insert(task, at: 0) // la insertamos al comienzo del array. Insertar antes de añadir a la base de datos.
                self.tabla.reloadData()
                indiceCronometroFuncionando = IndexPath(row:0, section:0)
                self.tabla.selectRow(at: indiceCronometroFuncionando, animated: true, scrollPosition: UITableViewScrollPosition.top) // cronómetro parado y seleccionada la primera celda (nueva tarea)
                self.tabla.cellForRow(at: indiceCronometroFuncionando)?.setSelected(true, animated: true)
                
                self.deseleccionarCeldasTabla() // para evitar que queden selecciones marcadas
                self.tableView(self.tabla, didSelectRowAt: IndexPath(row:0, section:0))
               TaskDatabase.shared.addTask(tarea: task)  // insertamos en la base de datos
                print("tareas: \(TaskDatabase.shared.tareas)")
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
                let descripcionTarea = TaskDatabase.shared.tareas[indice].descripcion
                let alert = UIAlertController(title: "Borrar Tarea".localized,
                                              message: String.localizedStringWithFormat(NSLocalizedString("mensajeBorrarTarea",comment:""),descripcionTarea),
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel))
                let action = UIAlertAction(title: "Ok".localized, style: .default) { [unowned self] action in
                    self.volviendoDeBorrarTarea = true
                    self.indiceCronometroFuncionando = self.tabla.indexPath(for: cell)! // Al hacer un swipe sobre la celda el cronómetro que estaba funcionando tiene que perder el foco.
                    let tarea = TaskDatabase.shared.tareas[indice]
                    TaskDatabase.shared.tareas.remove(at: indice)
                    self.tabla.reloadData()
                    _ = TaskDatabase.shared.removeTask(tarea: tarea)
                    
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
                        TaskDatabase.shared.addOcurrencia(ocurrenciaActual)
                        TaskDatabase.shared.tareas = TaskDatabase.shared.leerTareas() // Actualizamos las tareas para que incorpore la última ocurrencias insertada.
                    } else { // es la primera vez que se añade la ocurrencia y todavía no tiene idTask.
                        if let indice = self.tabla.indexPath(for: cell)?.row {
                            let descripcionTarea = TaskDatabase.shared.tareas[indice].descripcion
                            if let identificador = TaskDatabase.shared.idParaTarea(descrip: descripcionTarea) {
                                ocurrenciaActual.idTask = identificador
                                TaskDatabase.shared.addOcurrencia(ocurrenciaActual)
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
                    historicoVC.literalTarea = TaskDatabase.shared.tareas[indice].descripcion
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
