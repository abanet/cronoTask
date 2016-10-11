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
    
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        colorOriginal = self.contenedorView.backgroundColor
        
        
        lblTarea.textColor = UIColor.white
        
        let botonesDerecha = [MGSwipeButton(title: "Historial", backgroundColor: CronoTaskColores.backgroundViewNewTask)!
            ,MGSwipeButton(title: "Reset", backgroundColor: CronoTaskColores.backgroundViewNewTask)!]
        let botonesIzquierda = [MGSwipeButton(title: "Delete", backgroundColor: CronoTaskColores.backgroundViewNewTask)!]
        //configure left buttons
        self.leftButtons = botonesIzquierda
        self.leftSwipeSettings.transition = MGSwipeTransition.border
        self.leftExpansion.fillOnTrigger = true
        
        //configure right buttons
        self.rightButtons =  botonesDerecha
        self.rightSwipeSettings.transition = MGSwipeTransition.border
        
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
