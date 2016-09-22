//
//  ViewController.swift
//  cronoTask
//
//  Created by Alberto Banet Masa on 19/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  
  @IBOutlet weak var tabla: UITableView!
    
    
  var startTime = TimeInterval()
  var timer = Timer()

  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    self.tabla.delegate = self
    self.tabla.dataSource = self
    
// Para que ocupe toda la pantalla al desplazar las celdas se superpondría con el status bar.
//    let backgroundImage = UIImage(named: "background")
//    let imageView = UIImageView(image: backgroundImage)
//    self.tabla.backgroundView = imageView
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func iniciarCronometro(_ sender: AnyObject) {
    
    let aSelector : Selector = #selector(ViewController.updateTime)
    timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
    startTime = Date.timeIntervalSinceReferenceDate
    
    
  }
  
  @IBAction func pararCronometro(_ sender: AnyObject) {
    timer.invalidate()
  }

  
  func updateTime(){
    let currentTime = Date.timeIntervalSinceReferenceDate
    var tiempoPasado: TimeInterval = currentTime - startTime
    
    
    let minutos = UInt8(tiempoPasado/60.0)
    tiempoPasado -= (TimeInterval(minutos)*60)
    
    let segundos = UInt8(tiempoPasado)
    tiempoPasado -= TimeInterval(segundos)
    
    let fraccion = UInt8(tiempoPasado * 100)
  
    let strMinutos = String(format:"%02d",minutos)
    let strSegundos = String(format:"%02d", segundos)
    let strFracciones = String(format:"%02d",fraccion)
    
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
}

