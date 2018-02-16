//
//  RadioCheckboxBaseContainer.swift
//  RadioAndCheckboxButtonDemo
//
//  Created by Manish Bhande on 12/02/18.
//  Copyright © 2018 Manish. All rights reserved.
//

import Foundation

/// Struct to hold weak reference of a button
struct WeakRef<T: RadioCheckboxBaseButton> {
    
    private var selectionObservation: NSKeyValueObservation?
    weak var value: T?
    
    init(_ value: T, handler: @escaping (T, NSKeyValueObservedChange<Bool>) -> Void) {
        self.value = value
        selectionObservation = self.value?.observe(\T.isActive, changeHandler: handler)
    }
}

public class RadioCheckboxBaseContainer<T> where T: RadioCheckboxBaseButton {
    
    /// Hold lsit of buttons of T type
    private var buttonContainer: [WeakRef<T>] = []
    
    /// initializer with buttos
    ///
    /// - Parameter buttons: Array<T: RadioCheckboxBaseButton>
    public init(_ buttons: [T] = []) {
        addButtons(buttons)
    }
    
    /// Get buttons strutct object of specified button
    ///
    /// - Parameter button: RadioCheckboxBaseButton
    /// - Returns: WeakRef of specified button
    private func weakRefOf(button: T) -> WeakRef<T>? {
        return buttonContainer.first(where: { $0.value == button })
    }
    
    /// Eterate all button
    ///
    /// - Parameter button: Block with RadioCheckboxBaseButton objet
    internal func forEachButton(_ button: (T?) -> Void) {
        buttonContainer.forEach { button($0.value) }
    }
    
    /// Add buttons into container
    ///
    /// - Parameter buttons: RadioCheckboxBaseButton
    public func addButtons(_ buttons: [T]) {
        buttons.forEach { addButton($0) }
    }
    
    /// Deselect all buttons
    public func deselectAll() {
        forEachButton { $0?.isActive = false }
    }
    
    /// Get / set selected all buttons
    public var selectedButtons: [T] {
        
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
    
    /// Add a new button to container on return confirm button is added or not.
    /// If button is already added then false will be return
    ///
    /// - Parameter button: RadioCheckboxBaseButton
    /// - Returns: Bool
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
    
    /// Remove specified button from container, If button is not present then false will be return
    ///
    /// - Parameter button: RadioCheckboxBaseButton
    /// - Returns: Bool
    @discardableResult
    public func removeButton(_ button: T) -> Bool {
        guard let index = buttonContainer.index(where: { $0.value == button }) else {
            return false
        }
        buttonContainer.remove(at: index)
        return true
    }
    
    /// Selection state change onbser for each button.
    /// Child can override if wants to perform any action on selection state changes
    ///
    /// - Parameters:
    ///   - button: RadioCheckboxBaseButton
    ///   - change: NSKeyValueObservedChange<Bool>
    internal func selectionChangeObserver(_ button: T, _ change: NSKeyValueObservedChange<Bool>) {
        
    }
    
    // Free up the button which are no more available
    internal func compact() {
        
    }
    
}
