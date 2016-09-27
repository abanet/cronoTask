//
//  NuevaTareaViewController.swift
//  cronoTask
//
//  Created by Alberto Banet on 26/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import UIKit

protocol writeValueBackDelegate {
    func writeValueBack(value: String)
}


class NuevaTareaViewController: UIViewController {
    
    var delegate: writeValueBackDelegate?
    
    @IBOutlet weak var viewNuevaTarea: UIView!
    

    @IBOutlet weak var lblCrear: UILabel!
    @IBOutlet weak var lblNuevaTarea: UILabel!

    @IBOutlet weak var txtNuevaTarea: UITextField!
    
    
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewNuevaTarea.backgroundColor = CronoTaskColores.backgroundViewNewTask
        
        // Asignación localizada de las etiquetas
        // Se utiliza la extensión de String definida en StringExtensions para hacerlo más Swifty...
        lblCrear.text = "Create a".localized
        lblNuevaTarea.text = "New Task".localized
        txtNuevaTarea.placeholder = "Name of the new task".localized
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
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
            print("Enviando tarea \(txtNuevaTarea.text) al delegado")
            delegate?.writeValueBack(value: descripcion)
            self.dismiss(animated: true)
        }
        
    }
    
}
