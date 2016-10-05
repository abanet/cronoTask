//
//  HistoricoViewController.swift
//  cronoTask
//
//  Created by Alberto Banet on 3/10/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import UIKit

class HistoricoViewController: UIViewController {

    @IBOutlet weak var tabla: UITableView!
    
    
    // Base de datos
    var bbdd: TaskDatabase!
    var literalTarea: String!
    var totalOcurrencias = [Ocurrencia]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabla.dataSource = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let idTarea = bbdd.idParaTarea(descrip: literalTarea) else {
            return
        }
        bbdd.delegate = self
        
        //las ocurrencias a mostras son las almacenadas en la base de datos añadiendo la actual en memoria en ese momento.
        if let ultimaOcurrencia = bbdd.ocurrencias[idTarea] {
            totalOcurrencias.append(ultimaOcurrencia)        }
        totalOcurrencias = bbdd.leerOcurrencias(idTask: idTarea)
        totalOcurrencias = totalOcurrencias.reversed()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnSalirPulsado(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

    // MARK: TableViewDataSource
extension HistoricoViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalOcurrencias.count    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.0)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CeldaOcurrencia")! as! HistoricoTableViewCell
        
        cell.lblOcurrencia.text = "\(totalOcurrencias[indexPath.row].fecha), \(totalOcurrencias[indexPath.row].hora),\(totalOcurrencias[indexPath.row].reloj.tiempo)."
        return cell
    }
    
    

}

extension HistoricoViewController: protocoloActualizarBBDD {
    func actualizarBBDD() {
        DispatchQueue.main.async {
            self.tabla.reloadData()
        }
    }
}

