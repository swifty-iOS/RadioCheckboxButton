//
//  RadioButtonContainerView.swift
//  RadioButtonDemo
//
//  Created by Manish Bhande on 14/01/18.
//  Copyright © 2018 Manish. All rights reserved.
//

import UIKit

public class RadioButtonContainerView: UIView {
    
    private typealias Button = RadioButton
    
    private var _buttonContainer = RadioButtonContainer()
    
    public var buttonContainer: RadioButtonContainer {
        return _buttonContainer
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Load all Radio button
        let buttons = subviews
        for button in buttons {
            addButton(button)
        }
    }
    
    public override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        addButton(subview)
    }
    
    public override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        removeButton(subview)
    }
    
    public func addButton(_ view: UIView) {
        if view is Button {
            buttonContainer.addButton(view as! Button)
        }
    }
    
    public func removeButton(_ view: UIView) {
        if view is Button {
            buttonContainer.removeButton(view as! Button)
        }
    }
    
}
