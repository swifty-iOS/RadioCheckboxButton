//
//  CheckboxButtonContainerView.swift
//  RadioButtonDemo
//
//  Created by Manish Bhande on 14/01/18.
//  Copyright © 2018 Manish. All rights reserved.
//

import UIKit

/// View container that hold all CheckboxButton available as subview
public class CheckboxButtonContainerView: UIView {
    
    public typealias ButtonType = CheckboxButton
    
    private var _buttonContainer = CheckboxButtonContainer()
    
    /// Access button container for more features
    /// You can not change buttonContainer
    public var buttonContainer: CheckboxButtonContainer {
        return _buttonContainer
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Load all Radio button
        let buttons = subviews
        for case let button as ButtonType in buttons {
            addButton(button)
        }
    }
    
    /// Ading subview in button conatiner if it is CheckboxButton
    public override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        guard let button = subview as? ButtonType else { return }
        addButton(button)
    }
    
    /// Removing CheckboxButton from container
    public override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        guard let button = subview as? ButtonType else { return }
        removeButton(button)
    }
    
    /// Add button in container even if it is not added as subview in container view
    ///
    /// - Parameter button: CheckboxButton
    public func addButton(_ button: ButtonType) {
        buttonContainer.addButton(button)
    }
    
    /// Remove button from container. It will not remove from view. User removefromSuperview method delete button from view.
    ///
    /// - Parameter button: CheckboxButton
    public func removeButton(_ button: ButtonType) {
        buttonContainer.removeButton(button)
    }
    
}
