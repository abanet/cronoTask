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
        
        let botonesIzquierda = [MGSwipeButton(title: "", icon: UIImage(named:"check.png"), backgroundColor: UIColor.green)!
            ,MGSwipeButton(title: "", icon: UIImage(named:"fav.png"), backgroundColor: UIColor.blue)!]
        let botonesDerecha = [MGSwipeButton(title: "Delete", backgroundColor: UIColor.red)!]
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
