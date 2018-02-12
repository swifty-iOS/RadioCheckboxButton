//
//  CheckboxButton.swift
//  RadioAndCheckboxButtonDemo
//
//  Created by Manish Bhande on 11/02/18.
//  Copyright © 2018 Manish. All rights reserved.
//

import Foundation
import UIKit

public struct CheckboxLine {
    
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

public struct CheckBoxColor {
    
    let activeColor: UIColor
    let inactiveColor: UIColor
    let inactiveBorderColor: UIColor
    let checkMarkColor: UIColor
    
}

public protocol CheckboxButtonDelegate: class {
 
    func chechboxButtonDidSelect(_ button: CheckboxButton)
    func chechboxButtonDidDeselect(_ button: CheckboxButton)

}

public class CheckboxButton: RadioAndCheckboxButton {
    
    private var outerLayer = CAShapeLayer()
    private var checkMarkLayer = CAShapeLayer()
    
    // Make sure color did should not call while setting internal
    private var radioButtonColorDidSetCall = false
    
    public weak var delegate: CheckboxButtonDelegate?
    
    public var checkBoxColor: CheckBoxColor! {
        didSet {
            if radioButtonColorDidSetCall {
                checkMarkLayer.strokeColor = checkBoxColor.checkMarkColor.cgColor
                updateSelectionState()
            }
        }
    }
    
    public var checkboxLine = CheckboxLine() {
        didSet {
            setupLayer()
        }
    }
    
    public var radioButtonColor: RadioButtonColor! {
        didSet {
            outerLayer.strokeColor = isActive ? radioButtonColor.active.cgColor : radioButtonColor.inactive.cgColor
        }
    }
    
    override var allowDeselection: Bool { return true }
    
    override func setup() {
        checkBoxColor = CheckBoxColor(activeColor: tintColor, inactiveColor: UIColor.white, inactiveBorderColor: UIColor.lightGray, checkMarkColor: UIColor.white)
        super.setup()
        radioButtonColorDidSetCall = true
    }
    
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
        
        super.setupLayer()
    }
    
    override func callDelegate() {
        super.callDelegate()
        if isActive {
            delegate?.chechboxButtonDidSelect(self)
        } else {
            delegate?.chechboxButtonDidDeselect(self)
        }
    }
    
    internal override func updateActiveLayer() {
        checkMarkLayer.removeFromSuperlayer()
        outerLayer.fillColor = checkBoxColor.activeColor.cgColor
        outerLayer.strokeColor = checkBoxColor.activeColor.cgColor
        outerLayer.insertSublayer(checkMarkLayer, at: 0)
        animate()
    }
    
    internal override func updateInactiveLayer() {
        checkMarkLayer.removeAllAnimations()
        checkMarkLayer.removeFromSuperlayer()
        outerLayer.fillColor = checkBoxColor.inactiveColor.cgColor
        outerLayer.strokeColor = checkBoxColor.inactiveBorderColor.cgColor
    }
    
    private func animate() {
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 0.35
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        checkMarkLayer.add(pathAnimation, forKey: "checkMarkLayer")
    }
}
