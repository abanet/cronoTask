//
//  ViewController.swift
//  cronoTask
//
//  Created by Alberto Banet Masa on 19/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  // Tabla que contiene los cronómetros
  @IBOutlet weak var tabla: UITableView!
 
    
  // Cronómetro
    @IBOutlet weak var lblPrimerContador: UILabel!
    @IBOutlet weak var lblSegundoContador: UILabel!
    @IBOutlet weak var lblTercerContador: UILabel!
    
    @IBOutlet weak var lblPrimerIdentificador: UILabel!
    @IBOutlet weak var lblSegundoIdentificador: UILabel!
    @IBOutlet weak var lblTercerIdentificador: UILabel!
    
  // Cronómetro en funcionamiento
    var indiceCronometroFuncionando: IndexPath = IndexPath()
    var cronometrando: Bool = false
    
    
  var startTime = TimeInterval()
  var timer = Timer()

  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tabla.delegate = self
    self.tabla.dataSource = self
    
    
  }

// MARK: Funciones que manejan el timer de la app.
func iniciarCronometro() {
    let aSelector : Selector = #selector(ViewController.updateTime)
    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: aSelector, userInfo: nil, repeats: true)
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
    
    //let fraccion = UInt8(tiempoPasado * 100)
    let strHoras = String(format:"%02d", horas)
    let strMinutos = String(format:"%02d",minutos)
    let strSegundos = String(format:"%02d", segundos)
    //let strFracciones = String(format:"%02d",fraccion)
    
    self.lblPrimerContador.text = strHoras
    self.lblSegundoContador.text = strMinutos
    self.lblTercerContador.text = strSegundos
    
//    lblHoras.text = strMinutos
//    lblMinutos.text = strSegundos
//    lblSegundos.text = strFracciones
  }


// MARK: TableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.0)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda")! as UITableViewCell
        
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
    
    
   }

