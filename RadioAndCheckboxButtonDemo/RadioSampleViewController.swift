//
//  RadioSampleViewController.swift
//  RadioButtonDemo
//
//  Created by Manish on 10/01/2018.
//  Copyright © 2018 Manish. All rights reserved.
//

import UIKit

class RadioSampleViewController: UIViewController {
    
    @IBOutlet weak var viewGroup1: RadioButtonContainerView!
    @IBOutlet weak var viewGroup2: RadioButtonContainerView!
    @IBOutlet weak var viewGroup3: UIView!
    
    @IBOutlet weak var optionAG3: RadioButton!
    @IBOutlet weak var optionBG3: RadioButton!
    @IBOutlet weak var optionCG3: RadioButton!
    
    var group3Container = RadioButtonContainer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGroup2()
        setupGroup3()
    }
    
    func setupGroup2() {
        viewGroup2.buttonContainer.delegate = self
        viewGroup2.buttonContainer.setEachRadioButtonColor {
            return RadioButtonColor(active: $0.tintColor , inactive: $0.tintColor)
        }
    }
    
    func setupGroup3() {
        
        group3Container.addButtons([optionAG3, optionBG3, optionCG3])
        group3Container.delegate = self
        group3Container.selectedButton = optionBG3
        
        // Set cutsom color for each button
        optionAG3.radioButtonColor = RadioButtonColor(active: UIColor.red, inactive: optionAG3.tintColor, strokeActiveColor: UIColor.green)
        optionBG3.style = .square
        optionBG3.radioButtonColor = RadioButtonColor(active: UIColor.black
            , inactive: optionBG3.tintColor)
        optionCG3.radioButtonColor = RadioButtonColor(active: UIColor.magenta, inactive: UIColor.red)
        
        // Set up cirlce size here
        optionAG3.radioCircle = RadioButtonCircleStyle.init(outerCircle: 10, innerCircle: 5, outerCircleBorder: 1)
        optionBG3.radioCircle = RadioButtonCircleStyle.init(outerCircle: 25, innerCircle: 10, outerCircleBorder: 5, contentPadding: 20)
        optionCG3.radioCircle = RadioButtonCircleStyle.init(outerCircle: 20, innerCircle: 20, outerCircleBorder: 5, contentPadding: 10)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension RadioSampleViewController: RadioButtonDelegate {
    
    func radioButtonDidSelect(_ button: RadioButton) {
        print("Select: ", button.title(for: .normal)!)
    }
    
    func radioButtonDidDeselect(_ button: RadioButton) {
        print("Deselect: ",  button.title(for: .normal)!)
    }
}

