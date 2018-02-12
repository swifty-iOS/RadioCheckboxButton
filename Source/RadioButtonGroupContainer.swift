//
//  RadioButtonGroupContainer.swift
//  RadioButtonDemo
//
//  Created by Manish Bhande on 13/01/18.
//  Copyright © 2018 Manish. All rights reserved.
//

import Foundation

// MARK: GroupRadioButton Handling

public class RadioButtonGroupContainer<T> where T: RadioButton {
    
    private var radioButtons: [WeakRef<T>] = []
    
    public init(_ buttons: [T] = []) {
        addButtons(buttons)
    }
    
    public weak var radioButtonDelegate: RadioButtonDelegate? {
        didSet {
            radioButtons.forEach { $0.value?.delegate = radioButtonDelegate }
        }
    }
        
    public var radioButtonColor: RadioButtonColor? {
        didSet {
            if radioButtonColor != nil {
                radioButtons.forEach { $0.value?.radioButtonColor = radioButtonColor! }
            }
        }
    }
    
    public var selectedButton: T? {
        get { return radioButtons.first { $0.value?.isActive == true }?.value }
        set {
            guard let button = newValue else {
                selectedButton?.isActive = false
                return
            }
            weakRefOf(button: button)?.value?.isActive = true
        }
    }
    
    public func addButtons(_ buttons: [T]) {
        buttons.forEach { addButton($0) }
    }
    
    @discardableResult
    public func addButton(_ button: T) -> Bool {
        // Check if button is already added
        if weakRefOf(button: button) == nil {
            let newWeakRef = WeakRef<T>(button, handler: selectionChangeObserver)
            radioButtons.append(newWeakRef)
            return true
        }
        return false
    }
    
    private func selectionChangeObserver(_ button: T, _ change: NSKeyValueObservedChange<Bool>) {
        if button.isActive {
            // Deselect on selected button excepting current selected button
            radioButtons.first { $0.value != button && $0.value?.isActive == true }?.value?.isActive = false
        }
    }
    
    private func weakRefOf(button: T) -> WeakRef<T>? {
        return radioButtons.first(where: { $0.value == button })
    }
    
    @discardableResult
    public func removeButton(_ button: T) -> Bool {
        guard let index = radioButtons.index(where: { $0.value == button }) else {
            return false
        }
        radioButtons.remove(at: index)
        return true
    }
    
    public func setEachRadioButtonColor(_ body: (RadioButton) -> RadioButtonColor) {
        for each in radioButtons {
            guard let button = each.value else { continue }
            each.value?.radioButtonColor = body(button)
        }
    }
    
    public func setEachRadioButtonCircle(_ body: (RadioButton) -> RadioButtonCircleHeight) {
        for each in radioButtons {
            guard let button = each.value else { continue }
            each.value?.radioCircle = body(button)
        }
    }
        
    // Free up radio button which are no more available
    internal func compact() {
        
    }
}


private extension RadioButtonGroupContainer {
    
    struct WeakRef<T: RadioButton> {
        
        private var selectionObservation: NSKeyValueObservation?
        weak var value: T?
        
        init(_ value: T, handler: @escaping (T, NSKeyValueObservedChange<Bool>) -> Void) {
            self.value = value
            selectionObservation = self.value?.observe(\T.isActive, changeHandler: handler)
        }
    }
}
