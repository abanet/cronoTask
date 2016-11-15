//
//  AppDelegate.swift
//  cronoTask
//
//  Created by Alberto Banet Masa on 19/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    // Conexión a la base de datos de la app
    TaskDatabase.shared.crearBbdd()
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // guardamos el momento actual en el que se sale del primer plano si se está cronometrando.
    print("RESIGN ACTIVE")
    let mainViewController = window!.rootViewController as! ViewController
    if mainViewController.cronometrando {
        let tiempoResignacion = Date()
        print("tiempo de Resignación: \(tiempoResignacion)")
        UserDefaults.standard.set(tiempoResignacion, forKey: "claveTiempo")
        UserDefaults.standard.set(true, forKey: "cronometrando")
    } else {
        UserDefaults.standard.set(false, forKey: "cronometrando")
    }
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    


  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Si cuando se salió se estaba cronometrando hay que acualizar el tiempo de la ocurrencia actual
        if UserDefaults.standard.bool(forKey: "cronometrando") {
            let mainViewController = window!.rootViewController as! ViewController
            if mainViewController.cronometrando {
                
                let tiempoWillResignActiva = UserDefaults.standard.object(forKey: "claveTiempo") as! Date
                let ahora = Date()
                let diferencia = Int(ahora.timeIntervalSince(tiempoWillResignActiva))
                print("DID BECOME ACTIVE con tiempo: \(diferencia)")
                let horas = diferencia/3600
                let minutos = (diferencia/60)%60
                let segundos = diferencia % 60
                
                let reloj = Reloj(horas:horas, minutos:minutos, segundos: segundos, centesimas: 0)
                let relojFinal = Reloj.sumar(reloj1: reloj, reloj2:mainViewController.ocurrenciaActual.reloj)
                let relojTiempoTotal = Reloj.sumar(reloj1: reloj, reloj2: mainViewController.relojTiempoTotal)
                
                mainViewController.ocurrenciaActual.reloj = relojFinal
                mainViewController.relojTiempoTotal = relojTiempoTotal
                
            }
        }
    }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    // Si la aplicación termina grabamos las ocurrencias no grabadas a la base de datos.
    TaskDatabase.shared.grabarOcurrenciasNotSaveBBDD()
    TaskDatabase.shared.cerrarBBDD()
  }

}

