//
//  ViewController.swift
//  cronoTask
//
//  Created by Alberto Banet Masa on 19/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var startTime = NSTimeInterval()
  var timer = NSTimer()


  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func iniciarCronometro(sender: AnyObject) {
    
    let aSelector : Selector = #selector(ViewController.updateTime)
    timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
    startTime = NSDate.timeIntervalSinceReferenceDate()
    
    
  }
  
  @IBAction func pararCronometro(sender: AnyObject) {
    timer.invalidate()
  }

  
  func updateTime(){
    let currentTime = NSDate.timeIntervalSinceReferenceDate()
    var tiempoPasado: NSTimeInterval = currentTime - startTime
    
    
    let minutos = UInt8(tiempoPasado/60.0)
    tiempoPasado -= (NSTimeInterval(minutos)*60)
    
    let segundos = UInt8(tiempoPasado)
    tiempoPasado -= NSTimeInterval(segundos)
    
    let fraccion = UInt8(tiempoPasado * 100)
  
    let strMinutos = String(format:"%02d",minutos)
    let strSegundos = String(format:"%02d", segundos)
    let strFracciones = String(format:"%02d",fraccion)
    
//    lblHoras.text = strMinutos
//    lblMinutos.text = strSegundos
//    lblSegundos.text = strFracciones
  }

}

