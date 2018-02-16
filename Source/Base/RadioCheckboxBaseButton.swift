//
//  RadioCheckboxBaseButton.swift
//  RadioAndCheckboxButtonDemo
//
//  Created by Manish Bhande on 11/02/18.
//  Copyright © 2018 Manish. All rights reserved.
//

import Foundation
import UIKit

public class RadioCheckboxBaseButton: UIButton {
    
    private var sizeChangeObserver: NSKeyValueObservation?
    
    internal var allowDeselection: Bool {
        return false
    }
    
    @objc dynamic public var isActive = false {
        didSet {
            updateSelectionState()
            callDelegate()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public convenience init?(type buttonType: UIButtonType) {
        return nil
    }
    
    internal func setup() {
        // Add action here
        addTarget(self, action: #selector(selectionAction), for: .touchUpInside)
        contentHorizontalAlignment = .left
        addObserverSizeChange()
        setupLayer()
    }
    
    @objc internal func selectionAction(_ sender: RadioButton) {
        // If toggle enable, change selection state
        if allowDeselection {
            isActive = !isActive
        } else if !isActive {
            isActive = true
        }
    }
    
    public func updateSelectionState() {
        if isActive {
            updateActiveLayer()
        } else {
            updateInactiveLayer()
        }
    }
    
    internal func setupLayer() {
        updateSelectionState()
    }
    
    internal func updateActiveLayer() { }
    
    internal func updateInactiveLayer() { }
    
    internal func callDelegate() { }
    
}

//MARK:- frame change handler
extension RadioCheckboxBaseButton {
    
    private func addObserverSizeChange() {
        sizeChangeObserver = observe(\RadioCheckboxBaseButton.frame, changeHandler: sizeChangeObseveHandler)
    }
    
    private func sizeChangeObseveHandler(_ object: RadioCheckboxBaseButton, _ change: NSKeyValueObservedChange<CGRect>) {
        setupLayer()
    }
    
}
