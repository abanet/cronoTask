//
//  TaskTableViewCell.swift
//  cronoTask
//
//  Created by Alberto Banet on 26/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        let backView = UIView(frame: self.frame)
        backView.backgroundColor = CronoTaskColores.backgroundCell
        self.selectedBackgroundView = backView
        
    }

}
