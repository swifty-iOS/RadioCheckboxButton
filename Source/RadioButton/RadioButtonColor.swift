//
//  RadioButtonColor.swift
//  RadioAndCheckboxButtonDemo
//
//  Created by Manish Bhande on 08/12/18.
//  Copyright © 2018 Manish. All rights reserved.
//

import UIKit

/// Define RadioButtonColor

public struct RadioButtonColor {
    
    let active: UIColor
    let inactive: UIColor
    let strokeActiveColor: UIColor?
    let strokeInactiveColor: UIColor?
    
    public init(active: UIColor, inactive: UIColor, strokeActiveColor: UIColor? = nil, strokeInactiveColor: UIColor? = nil) {
        self.active = active
        self.inactive = inactive
        self.strokeActiveColor = strokeActiveColor
        self.strokeInactiveColor = strokeInactiveColor
    }
    
}
