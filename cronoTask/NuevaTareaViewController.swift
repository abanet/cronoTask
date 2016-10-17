//
//  NuevaTareaViewController.swift
//  cronoTask
//
//  Created by Alberto Banet on 26/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import UIKit

protocol writeValueBackDelegate {
    func writeValueBack(value: String, renombrando:Bool, nombreInicial: String?)
}

enum CampoVentana: Int {
    case accion
    case objeto
}

enum TiposMensajesVentana: String {
    case nuevaTarea
    case modificarTarea
}

struct MensajesVentana {
    let mensajes = ["nuevaTarea":["Create a","New Task"], "modificarTarea":["Modifying","Task"]]
}

class NuevaTareaViewController: UIViewController {
    
    var delegate: writeValueBackDelegate?
    var renombrando: Bool = false
    var nombreInicial: String?
    
    @IBOutlet weak var viewNuevaTarea: UIView!
    

    @IBOutlet weak var lblCrear: UILabel!
    @IBOutlet weak var lblNuevaTarea: UILabel!

    @IBOutlet weak var txtNuevaTarea: UITextField!
    
    
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewNuevaTarea.backgroundColor = CronoTaskColores.backgroundViewNewTask
        
        
        btnOk.setTitle("Ok".localized, for: .normal)
        btnCancel.setTitle("Cancel".localized, for: .normal)
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        // Asignar etiquetas
        let tipoMensaje = (renombrando) ? TiposMensajesVentana.modificarTarea.rawValue:TiposMensajesVentana.nuevaTarea.rawValue
        let mensajesVentana = MensajesVentana()
        let mensajes = mensajesVentana.mensajes[tipoMensaje]!
        let mensajeAccion = mensajes[CampoVentana.accion.rawValue]
        let mensajeObjeto = mensajes[CampoVentana.objeto.rawValue]
        
        // Asignación localizada de las etiquetas
        // Se utiliza la extensión de String definida en StringExtensions para hacerlo más Swifty...
        lblCrear.text = mensajeAccion.localized
        lblNuevaTarea.text = mensajeObjeto.localized
        if let contenidoCampoTexto = nombreInicial {
            txtNuevaTarea.text = contenidoCampoTexto
        } else {
            txtNuevaTarea.placeholder = "Name of the new task".localized
        }
        
        viewNuevaTarea.alpha = 0.0
        UIView.animate(withDuration: 1, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.viewNuevaTarea.alpha = 1.0
        })
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

 // MARK: Botones del formulario
    @IBAction func cancelarCreacionTarea(_ sender: AnyObject) {
        self.dismiss(animated: true)
    }
    
    @IBAction func okCreacionTarea(_ sender: AnyObject) {
        
        if let descripcion = txtNuevaTarea.text {
            let trimmedString = descripcion.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedString.isEmpty {
                print("Enviando tarea \(txtNuevaTarea.text) al delegado")
                self.dismiss(animated: true) // eliminamos antes de ir al delegado el controlador ya que en writeValueBack puede que lancemos un alert.
                delegate?.writeValueBack(value: descripcion, renombrando: false, nombreInicial: self.nombreInicial)
                return
            }
        }
        self.dismiss(animated: true)
        
    }
    
    
    
}


