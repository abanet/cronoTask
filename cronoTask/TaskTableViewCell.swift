//
//  TaskTableViewCell.swift
//  cronoTask
//
//  Created by Alberto Banet on 26/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import UIKit

class TaskTableViewCell: MGSwipeTableCell {

    @IBOutlet weak var lblTarea: UILabel!
    @IBOutlet weak var contenedorView: VistaRedondeada!
    var colorOriginal: UIColor!
    var estado: EstadoCelda = EstadoCelda.noSeleccionada // por defecto la celda no está seleccionada
    
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        colorOriginal = self.contenedorView.backgroundColor
        
        
        lblTarea.textColor = UIColor.white
        
        let botonesDerecha = [MGSwipeButton(title: "Add".localized, backgroundColor: CronoTaskColores.backgroundViewNewTask)!
            ,MGSwipeButton(title: "Log".localized, backgroundColor: CronoTaskColores.backgroundViewNewTask)!,MGSwipeButton(title: "Rename".localized, backgroundColor: CronoTaskColores.backgroundViewNewTask)!]
        let botonesIzquierda = [MGSwipeButton(title: "Delete".localized, backgroundColor: CronoTaskColores.backgroundViewNewTask)!]
        //configure left buttons
        self.leftButtons = botonesIzquierda
        self.leftSwipeSettings.transition = MGSwipeTransition.border
        self.leftExpansion.fillOnTrigger = true
        
        //configure right buttons
        self.rightButtons =  botonesDerecha
        self.rightSwipeSettings.transition = MGSwipeTransition.border
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        switch estado {
        case .seleccionada:
            self.contenedorView.backgroundColor = CronoTaskColores.backgroundCell
        case .noSeleccionada:
            self.contenedorView.backgroundColor = colorOriginal
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
        if selected {
            self.contenedorView.backgroundColor = CronoTaskColores.backgroundCell
        } else {
            self.contenedorView.backgroundColor = colorOriginal
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if(highlighted) {
            self.contenedorView.backgroundColor = CronoTaskColores.backgroundViewNewTask
        } else {
            self.contenedorView.backgroundColor = colorOriginal
        }
    }

}
