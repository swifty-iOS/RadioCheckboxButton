//
//  RadioCheckboxBaseButton.swift
//  RadioCheckboxButton
//
//  Created by Manish Bhande on 11/02/18.
//  Copyright © 2018 Manish. All rights reserved.
//

import Foundation
import UIKit

// MARK: CheckboxStyle
/// Define Checkbox style
public enum RadioCheckboxStyle {
    case rounded(radius: CGFloat), square, circle
}

// MARK: - RadioCheckboxBaseButton
@IBDesignable
public class RadioCheckboxBaseButton: UIButton {
    
    /// Oberver frame change to update style
    private var sizeChangeObserver: NSKeyValueObservation?
    
    /// Allow delection for button useful in Check bok stype
    internal var allowDeselection: Bool {
        return false
    }
    
    /// Keep the track of Selection and deselction
    @objc dynamic public var isOn = false {
        didSet {
            if isOn != oldValue {
                updateSelectionState()
                callDelegate()
            }
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
    
    public convenience init?(type buttonType: UIButton.ButtonType) {
        return nil
    }
    
    /// Specify button style from CheckboxStyle
    public var style: RadioCheckboxStyle = .circle {
        didSet {
            setupLayer()
        }
    }
    
    /// Setup intial things required
    internal func setup() {
        // Add action here
        addTarget(self, action: #selector(selectionAction), for: .touchUpInside)
        contentHorizontalAlignment = .left
        addObserverSizeChange()
        setupLayer()
    }
    
    /// Action handler of button for internal use
    ///
    /// - Parameter sender: RadioCheckboxBaseButton
    @objc internal func selectionAction(_ sender: RadioCheckboxBaseButton) {
        // If toggle enable, change selection state
        if allowDeselection {
            isOn = !isOn
        } else if !isOn {
            isOn = true
        }
    }
    
    /// Update selection stage as button selected for deselected
    public func updateSelectionState() {
        if isOn {
            updateActiveLayer()
        } else {
            updateInactiveLayer()
        }
    }
    
    /// Setup layer that will for Radio and Checkbox button
    /// This method can be called mutliple times
    /// Do the stuff by overriding, then call super class method
    internal func setupLayer() {
        updateSelectionState()
    }
    
    /// Update active layer as button is selected
    internal func updateActiveLayer() { }
    
    /// Update inative later as button is deselected
    internal func updateInactiveLayer() { }
    
    /// call delegate as button selection state changes
    internal func callDelegate() { }
    
}

// MARK:- frame change handler
extension RadioCheckboxBaseButton {
    
    private func addObserverSizeChange() {
        sizeChangeObserver = observe(\RadioCheckboxBaseButton.frame, changeHandler: sizeChangeObseveHandler)
    }
    
    private func sizeChangeObseveHandler(_ object: RadioCheckboxBaseButton, _ change: NSKeyValueObservedChange<CGRect>) {
        setupLayer()
    }
    
}

// MARK:- CAShapeLayer Stroke animation
internal extension CAShapeLayer {
    
    func animateStrokeEnd(from: CGFloat, to: CGFloat) {
        self.strokeEnd = from
        self.strokeEnd = to
    }
    
    func animatePath(start: CGPath, end: CGPath) {
        removeAllAnimations()
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = start
        animation.toValue = end
        animation.isRemovedOnCompletion = true
        add(animation, forKey: "pathAnimation")
    }
    
}
