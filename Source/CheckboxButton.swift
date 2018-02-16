//
//  CheckboxButton.swift
//  RadioAndCheckboxButtonDemo
//
//  Created by Manish Bhande on 11/02/18.
//  Copyright © 2018 Manish. All rights reserved.
//

import Foundation
import UIKit

// MARK: CheckboxLineStyle
/// Struct to define Chebox style
public struct CheckboxLineStyle {
    
    let checkBoxHeight: CGFloat
    let checkmarkLineWidth: CGFloat
    let padding: CGFloat
    
    init(checkBoxHeight: CGFloat, checkmarkLineWidth: CGFloat = -1, padding: CGFloat = 6) {
        self.checkBoxHeight = checkBoxHeight
        self.checkmarkLineWidth = checkmarkLineWidth
        self.padding = padding
    }
    
    init(checkmarkLineWidth: CGFloat, padding: CGFloat = 6) {
        self.init(checkBoxHeight: 18, checkmarkLineWidth: checkmarkLineWidth, padding: padding)
    }
    
    init(padding: CGFloat = 6) {
        self.init(checkmarkLineWidth: -1, padding: padding)
    }
    
    var size: CGSize {
        return CGSize(width: checkBoxHeight, height: checkBoxHeight)
    }
}

// MARK:- CheckBoxColor
/// Define check box color
public struct CheckBoxColor {
    
    let activeColor: UIColor
    let inactiveColor: UIColor
    let inactiveBorderColor: UIColor
    let checkMarkColor: UIColor
    
}

// MARK:- CheckboxButtonDelegate
/// Chebox delegates
public protocol CheckboxButtonDelegate: class {
    
    func chechboxButtonDidSelect(_ button: CheckboxButton)
    func chechboxButtonDidDeselect(_ button: CheckboxButton)
    
}

// MARK:- CheckboxButton
public class CheckboxButton: RadioCheckboxBaseButton {
    
    private var outerLayer = CAShapeLayer()
    private var checkMarkLayer = CAShapeLayer()
    
    // Make sure color did should not call while setting internal
    private var radioButtonColorDidSetCall = false
    
    public weak var delegate: CheckboxButtonDelegate?
    
    /// Set checkbox color to customise the buttons
    public var checkBoxColor: CheckBoxColor! {
        didSet {
            if radioButtonColorDidSetCall {
                checkMarkLayer.strokeColor = checkBoxColor.checkMarkColor.cgColor
                updateSelectionState()
            }
        }
    }
    
    /// Apply checkbox line to gcustomize checkbox button layout
    public var checkboxLine = CheckboxLineStyle() {
        didSet {
            setupLayer()
        }
    }
    
    /// Allow deselectiom of button
    override internal var allowDeselection: Bool {
        return true
    }
    
    /// Set default color of chebox
    override internal func setup() {
        checkBoxColor = CheckBoxColor(activeColor: tintColor, inactiveColor: UIColor.clear, inactiveBorderColor: UIColor.lightGray, checkMarkColor: UIColor.white)
        super.setup()
        radioButtonColorDidSetCall = true
    }
    
    /// Setup layer of check box
    override internal func setupLayer() {
        contentEdgeInsets = UIEdgeInsets(top: 0, left: checkboxLine.checkBoxHeight + checkboxLine.padding, bottom: 0, right: 0)
        // Make inner later here
        let origin = CGPoint(x: 1, y: bounds.midY - (checkboxLine.checkBoxHeight/2))
        let rect = CGRect(origin: origin, size: checkboxLine.size)
        let outerPath = UIBezierPath(roundedRect: rect, cornerRadius: 3)
        outerLayer.path = outerPath.cgPath
        outerLayer.lineWidth = 2
        outerLayer.removeFromSuperlayer()
        layer.insertSublayer(outerLayer, at: 0)
        
        let path = UIBezierPath()
        var xPos: CGFloat = (rect.width * 0.15) + origin.x
        var yPos = rect.midY
        path.move(to: CGPoint(x: xPos, y: yPos))
        
        var radius = (rect.width/2 - xPos)
        
        [45.0, -45.0].forEach {
            xPos = xPos + radius * CGFloat(cos($0 * .pi/180))
            yPos = yPos + radius * CGFloat(sin($0 * .pi/180))
            path.addLine(to: CGPoint(x: xPos, y: yPos))
            radius *= 2
        }
        
        checkMarkLayer.lineWidth = checkboxLine.checkmarkLineWidth == -1 ? max(checkboxLine.checkBoxHeight*0.1, 2) : checkboxLine.checkmarkLineWidth
        checkMarkLayer.strokeColor = checkBoxColor.checkMarkColor.cgColor
        checkMarkLayer.path = path.cgPath
        checkMarkLayer.fillColor = UIColor.clear.cgColor
        checkMarkLayer.removeFromSuperlayer()
        outerLayer.insertSublayer(checkMarkLayer, at: 0)
        
        super.setupLayer()
    }
    
    /// Delegate call
    override internal func callDelegate() {
        super.callDelegate()
        if isActive {
            delegate?.chechboxButtonDidSelect(self)
        } else {
            delegate?.chechboxButtonDidDeselect(self)
        }
    }
    
    /// Update active layer and apply animation
    override internal  func updateActiveLayer() {
        checkMarkLayer.animateStrokeEnd(from: 0, to: 1)
        outerLayer.fillColor = checkBoxColor.activeColor.cgColor
        outerLayer.strokeColor = checkBoxColor.activeColor.cgColor
    }
    
    /// Update inactive layer apply animation
    override internal func updateInactiveLayer() {
        checkMarkLayer.animateStrokeEnd(from: 1, to: 0)
        outerLayer.fillColor = checkBoxColor.inactiveColor.cgColor
        outerLayer.strokeColor = checkBoxColor.inactiveBorderColor.cgColor
    }
    
}
// MARK:- CAShapeLayer Stroke animation
private extension CAShapeLayer {
    
    func animateStrokeEnd(from: CGFloat, to: CGFloat, completion: ((Bool) -> Void)? = nil) {
        removeAllAnimations()
        UIView.animate(withDuration: 0.35, animations: {
            self.strokeEnd = from
            self.strokeEnd = to
        }, completion: completion)
    }
    
}
