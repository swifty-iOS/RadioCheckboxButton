//
//  RadioCheckboxBaseContainer.swift
//  RadioCheckboxButton
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
        selectionObservation = self.value?.observe(\T.isOn, changeHandler: handler)
    }
}

public class RadioCheckboxBaseContainer<T> where T: RadioCheckboxBaseButton {
    
    public typealias Kind = T
    
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
    
    /// Get all buttons in container
    public var allButtons: [T] {
        return buttonContainer.filter { $0.value != nil }.map { $0.value! }
    }
    
    /// Add buttons into container
    ///
    /// - Parameter buttons: RadioCheckboxBaseButton
    public func addButtons(_ buttons: [T]) {
        buttons.forEach { addButton($0) }
    }
    
    /// Deselect all buttons
    public func deselectAll() {
        allButtons.forEach { $0.isOn = false }
    }
    
    /// Get / set selected all buttons
    public var selectedButtons: [T] {
        
        get {
            return allButtons.filter { $0.isOn }
        }
        
        set {
            deselectAll()
            for each in newValue {
                let btn = weakRefOf(button: each)
                btn?.value?.isOn = true
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
            button.style = buttonStyle ?? button.style
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
    
    /// Set common style for button added in container
    public var buttonStyle: RadioCheckboxStyle? {
        didSet {
            guard let newStyle = buttonStyle else { return }
            setEachButtonStyle { _ in return newStyle }
        }
    }
    
    /// Set a separate style for each button added in container
    ///
    /// - Parameter body: (RadioCheckboxBaseButton) -> RadioCheckboxStyle
    public func setEachButtonStyle(_ body: (T) -> RadioCheckboxStyle) {
        allButtons.forEach {
            $0.style = body($0)
        }
    }
    
    // Free up the button which are no longer available
    public func compact() {
    
        var counter = 0
        while counter < buttonContainer.count {
            if buttonContainer[counter].value == nil {
                buttonContainer.remove(at: counter)
            } else {
                counter += 1
            }
        }
    }
    
}
