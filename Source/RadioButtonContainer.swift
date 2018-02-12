//
//  RadioButtonGroupContainer.swift
//  RadioButtonDemo
//
//  Created by Manish Bhande on 13/01/18.
//  Copyright © 2018 Manish. All rights reserved.
//

import Foundation



// MARK: GroupRadioButton Handling

public class RadioButtonContainer: RadioCheckboxBaseContainer<RadioButton> {
    
    public weak var radioButtonDelegate: RadioButtonDelegate? {
        didSet {
            forEachButton { $0?.delegate = radioButtonDelegate }
        }
    }
    
    public var radioButtonColor: RadioButtonColor? {
        didSet {
            if radioButtonColor != nil {
                forEachButton { $0?.radioButtonColor = radioButtonColor }
            }
        }
    }
    
    public var selectedButton: RadioButton? {
        get { return selectedButtons.first }
        set {
            guard let button = newValue else {
                deselectAll()
                return
            }
            selectedButtons = [button]
        }
    }
    
    override func selectionChangeObserver(_ button: RadioButton, _ change: NSKeyValueObservedChange<Bool>) {
        super.selectionChangeObserver(button, change)
        if button.isActive {
            // Deselect on selected button excepting current selected button
            forEachButton { object in
                if object != button, object?.isActive == true {
                    object?.isActive = false
                }
            }
        }
    }
    
    public func setEachRadioButtonColor(_ body: (RadioButton) -> RadioButtonColor) {
        forEachButton {
            if let button = $0 {
                button.radioButtonColor = body(button)
            }
        }
    }
    
    public func setEachRadioButtonCircle(_ body: (RadioButton) -> RadioButtonCircleHeight) {
        forEachButton {
            if let button = $0 {
                button.radioCircle = body(button)
            }
        }
    }
}

