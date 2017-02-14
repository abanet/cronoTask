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
    
    @IBOutlet weak var lblTarea: UILabel!
    @IBOutlet weak var lblTiempoTotal: UILabel!

    var literalTarea: String!
    var totalOcurrencias = [Ocurrencia]()
    var ocurrenciasPorFecha: [[Ocurrencia]]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabla.dataSource = self
        self.tabla.delegate = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let idTarea = TaskDatabase.shared.idParaTarea(descrip: literalTarea) else {
            lblTarea.text = ""
            lblTiempoTotal.text = ""
            return
        }
        TaskDatabase.shared.delegate = self
        
        //las ocurrencias a mostrar son las almacenadas en la base de datos.
        
        totalOcurrencias = TaskDatabase.shared.leerOcurrencias(idTask: idTarea)
        guard totalOcurrencias.count > 0 else {
            lblTarea.text = ""
            lblTiempoTotal.text = ""
            return
        }
        totalOcurrencias = totalOcurrencias.reversed() // quedarán de más reciente a menos
        ocurrenciasPorFecha = Ocurrencia.categorizarOcurrencias(totalOcurrencias)
        
        lblTarea.text = literalTarea
        lblTiempoTotal.text = Ocurrencia.acumuladoTodasOcurrencias(totalOcurrencias)
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
        guard ocurrenciasPorFecha != nil else { return 0 }
        return ocurrenciasPorFecha!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard ocurrenciasPorFecha != nil else { return 0 }
        return ocurrenciasPorFecha![section].count
    }
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CeldaOcurrencia")! as! HistoricoTableViewCell
        cell.lblOcurrencia.text = "\(totalOcurrencias[indexPath.row].hora) -> \(totalOcurrencias[indexPath.row].reloj.tiempo)."
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let fecha = ocurrenciasPorFecha![section][0].fecha
        let fechaResultado = Fecha().literalFechaLocalizada(fecha: fecha)
        return fechaResultado
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let acumulado = Ocurrencia.acumuladoOcurrenciasSeccion(ocurrenciasPorFecha![section])
        return "Total -> \(acumulado)"
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerViewRect = tableView.rectForHeader(inSection: section)
//        let headerView = UIView(frame: headerViewRect)
//        headerView.backgroundColor = CronoTaskColores.backgroundCell
//        return headerView
//    }
    
    func crearVistaHeaderTabla() {
        let vista = UIView(frame: CGRect(x: 0, y: 0, width: 800, height: 100))
        let texto = UILabel(frame: CGRect(x:0, y:0, width:200, height:50))
        texto.text = "skjfaksd"
        vista.addSubview(texto)
            
        self.tabla.tableHeaderView = vista
        
        
    }
    
}

extension HistoricoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fondo de celdas transparentes
        cell.backgroundColor = UIColor(white: 1, alpha: 0.0)
    }
    
}


extension HistoricoViewController: protocoloActualizarBBDD {
    func actualizarBBDD() {
        DispatchQueue.main.async {
            self.tabla.reloadData()
        }
    }
}

