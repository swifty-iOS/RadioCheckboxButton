//
//  RadioCheckboxBaseContainer.swift
//  RadioAndCheckboxButtonDemo
//
//  Created by Manish Bhande on 12/02/18.
//  Copyright © 2018 Manish. All rights reserved.
//

import Foundation

struct WeakRef<T: RadioCheckboxBaseButton> {
    
    private var selectionObservation: NSKeyValueObservation?
    weak var value: T?
    
    init(_ value: T, handler: @escaping (T, NSKeyValueObservedChange<Bool>) -> Void) {
        self.value = value
        selectionObservation = self.value?.observe(\T.isActive, changeHandler: handler)
    }
}

public class RadioCheckboxBaseContainer<T> where T: RadioCheckboxBaseButton {
    
    private var buttonContainer: [WeakRef<T>] = []
    
    public init(_ buttons: [T] = []) {
        addButtons(buttons)
    }
    
    private func weakRefOf(button: T) -> WeakRef<T>? {
        return buttonContainer.first(where: { $0.value == button })
    }
    
    internal func forEachButton(_ button: (T?) -> Void) {
        buttonContainer.forEach { button($0.value) }
    }
    
    public func addButtons(_ buttons: [T]) {
        buttons.forEach { addButton($0) }
    }
    
    public func deselectAll() {
        forEachButton { $0?.isActive = false }
    }
    
    internal var selectedButtons: [T] {
        
        get {
            var result = [T]()
            forEachButton { button in
                if button != nil, button!.isActive {
                    result.append(button!)
                }
            }
            return result
        }
        
        set {
            deselectAll()
            for each in newValue {
                let btn = weakRefOf(button: each)
                btn?.value?.isActive = true
            }
        }
        
    }
    
    @discardableResult
    public func addButton(_ button: T) -> Bool {
        // Check if button is already added
        if weakRefOf(button: button) == nil {
            let newWeakRef = WeakRef<T>(button, handler: selectionChangeObserver)
            buttonContainer.append(newWeakRef)
            return true
        }
        return false
    }
    
    @discardableResult
    public func removeButton(_ button: T) -> Bool {
        guard let index = buttonContainer.index(where: { $0.value == button }) else {
            return false
        }
        buttonContainer.remove(at: index)
        return true
    }
    
    internal func selectionChangeObserver(_ button: T, _ change: NSKeyValueObservedChange<Bool>) {
        
    }
    
    // Free up radio button which are no more available
    internal func compact() {
        
    }
    
}
