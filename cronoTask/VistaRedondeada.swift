//
//  VistaRedondeada.swift
//  cronoTask
//
//  Created by Alberto Banet on 26/9/16.
//  Copyright © 2016 Alberto Banet Masa. All rights reserved.
//

import UIKit

@IBDesignable public class VistaRedondeada: UIView {

    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

}
