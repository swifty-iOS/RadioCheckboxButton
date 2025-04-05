//
//  RadioButtonContainerView.swift
//  RadioCheckboxButton
//
//  Created by Manish Bhande on 14/01/18.
//  Copyright © 2018 Manish. All rights reserved.
//

import UIKit

/// View container that hold all RadioButton available as first immediate subview only
open class RadioButtonContainerView: UIView {
    
    private var _buttonContainer = RadioButtonContainer()
    
    /// Access button container for more features
    /// You can not change buttonContainer
    public var buttonContainer: RadioButtonContainer {
        return _buttonContainer
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Load all Radio button
        let buttons = subviews
        for case let button as RadioButtonContainer.Kind in buttons {
            addButton(button)
        }
    }
    
    /// Ading subview in button conatiner if it is RadioButton
    open override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        guard let button = subview as? RadioButtonContainer.Kind else { return }
        addButton(button)
    }
    
    /// Removing RadioButton from container
    open override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        guard let button = subview as? RadioButtonContainer.Kind else { return }
        removeButton(button)
    }
    
    /// Add button in container even if it is not added as subview in container view
    ///
    /// - Parameter button: RadioButtonContainer.Kind
    public func addButton(_ button: RadioButtonContainer.Kind) {
        buttonContainer.addButton(button)
    }
    
    /// Remove button from container. It will not remove from view. User removefromSuperview method delete button from view.
    ///
    /// - Parameter button: RadioButtonContainer.Kind
    public func removeButton(_ view: RadioButtonContainer.Kind) {
            buttonContainer.removeButton(view)
    }
    
}
