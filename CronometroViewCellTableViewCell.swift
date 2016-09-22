//
//  CronometroViewCellTableViewCell.swift
//  cronoTask
//
//  Created by Alberto Banet on 22/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import UIKit

class CronometroViewCellTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPrimerContador: UILabel!
    @IBOutlet weak var lblSegundoContador: UILabel!
    @IBOutlet weak var lblTercerContador: UILabel!
    
    @IBOutlet weak var lblPrimerIdentificador: UILabel!
    @IBOutlet weak var lblSegundoIdentificador: UILabel!
    @IBOutlet weak var lblTercerIdentificador: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
