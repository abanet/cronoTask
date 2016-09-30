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
    
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblTarea.textColor = UIColor.white
        
        let botonesIzquierda = [MGSwipeButton(title: "Historial", backgroundColor: CronoTaskColores.backgroundViewNewTask)!
            ,MGSwipeButton(title: "Reset", backgroundColor: CronoTaskColores.backgroundViewNewTask)!]
        let botonesDerecha = [MGSwipeButton(title: "Delete", backgroundColor: CronoTaskColores.backgroundViewNewTask)!]
        //configure left buttons
        self.leftButtons = botonesIzquierda
        self.leftSwipeSettings.transition = MGSwipeTransition.border
        self.leftExpansion.fillOnTrigger = true
        
        //configure right buttons
        self.rightButtons =  botonesDerecha
        self.rightSwipeSettings.transition = MGSwipeTransition.border
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        let backView = UIView(frame: self.frame)
        backView.backgroundColor = CronoTaskColores.backgroundCell
        self.selectedBackgroundView = backView
        
    }

}
