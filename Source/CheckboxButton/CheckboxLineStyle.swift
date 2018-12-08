//
//  CheckboxLineStyle.swift
//  RadioAndCheckboxButtonDemo
//
//  Created by Manish Bhande on 08/12/18.
//  Copyright © 2018 Manish. All rights reserved.
//

import UIKit

// MARK: CheckboxLineStyle
/// Define Checkbox style
public struct CheckboxLineStyle {
    
    let checkBoxHeight: CGFloat
    let checkmarkLineWidth: CGFloat
    let padding: CGFloat
    
    public init(checkBoxHeight: CGFloat, checkmarkLineWidth: CGFloat = -1, padding: CGFloat = 6) {
        self.checkBoxHeight = checkBoxHeight
        self.checkmarkLineWidth = checkmarkLineWidth
        self.padding = padding
    }
    
    public init(checkmarkLineWidth: CGFloat, padding: CGFloat = 6) {
        self.init(checkBoxHeight: 18, checkmarkLineWidth: checkmarkLineWidth, padding: padding)
    }
    
    public init(padding: CGFloat = 6) {
        self.init(checkmarkLineWidth: -1, padding: padding)
    }
    
    public var size: CGSize {
        return CGSize(width: checkBoxHeight, height: checkBoxHeight)
    }
}
