//
//  CheckboxButtonContainer.swift
//  RadioButtonDemo
//
//  Created by Manish Bhande on 13/01/18.
//  Copyright © 2018 Manish. All rights reserved.
//

import Foundation

/// Hold all CheckboxButton button
public class CheckboxButtonContainer: RadioCheckboxBaseContainer<CheckboxButton> {
    
    /// Checkbox delegate, will be assigned to all button added in container
    public weak var delegate: CheckboxButtonDelegate? {
        didSet {
            forEachButton { $0?.delegate = delegate }
        }
    }
    
    /// Set color separate color style for each checkbox button added in conatainer
    ///
    /// - Parameter body: (CheckboxButton) -> CheckBoxColor
    public func setEachCheckboxButtonColor(_ body: (CheckboxButton) -> CheckBoxColor) {
        forEachButton {
            if let button = $0 {
                button.checkBoxColor = body(button)
            }
        }
    }
    
    /// Apply separate CheckboxLine style for each style added in container
    ///
    /// - Parameter body: (CheckboxButton) -> CheckboxLine
    public func setEachCheckboxButtonLine(_ body: (CheckboxButton) -> CheckboxLine) {
        forEachButton {
            if let button = $0 {
                button.checkboxLine = body(button)
            }
        }
    }
 
    /// Overrideding for seeting delegate
    @discardableResult
    public override func addButton(_ button: CheckboxButton) -> Bool {
        button.delegate = delegate
        return super.addButton(button)
    }
 
}
