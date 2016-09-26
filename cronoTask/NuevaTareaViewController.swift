//
//  NuevaTareaViewController.swift
//  cronoTask
//
//  Created by Alberto Banet on 26/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import UIKit

class NuevaTareaViewController: UIViewController {
    
    @IBOutlet weak var viewNuevaTarea: UIView!
    

    @IBOutlet weak var lblCrear: UILabel!
    @IBOutlet weak var lblNuevaTarea: UILabel!

    @IBOutlet weak var txtNuevaTarea: UITextField!
    
    
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewNuevaTarea.backgroundColor = CronoTaskColores.backgroundViewNewTask
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

}
