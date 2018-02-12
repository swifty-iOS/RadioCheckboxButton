//
//  CheckboxButtonContainer.swift
//  RadioButtonDemo
//
//  Created by Manish Bhande on 13/01/18.
//  Copyright © 2018 Manish. All rights reserved.
//

import Foundation



// MARK: GroupRadioButton Handling

public class CheckboxButtonContainer: RadioCheckboxBaseContainer<CheckboxButton> {
    
    public weak var delegate: CheckboxButtonDelegate? {
        didSet {
            forEachButton { $0?.delegate = delegate }
        }
    }
    
    public var radioButtonColor: RadioButtonColor? {
        didSet {
            if radioButtonColor != nil {
                forEachButton { $0?.radioButtonColor = radioButtonColor }
            }
        }
    }
    
    public var selectedButton: CheckboxButton? {
        get { return selectedButtons.first }
        set {
            guard let button = newValue else {
                deselectAll()
                return
            }
            selectedButtons = [button]
        }
    }
    
    public func setEachCheckboxButtonColor(_ body: (CheckboxButton) -> CheckBoxColor) {
        forEachButton {
            if let button = $0 {
                button.checkBoxColor = body(button)
            }
        }
    }
    
    public func setEachCheckboxButtonLine(_ body: (CheckboxButton) -> CheckboxLine) {
        forEachButton {
            if let button = $0 {
                button.checkboxLine = body(button)
            }
        }
    }
    
}
