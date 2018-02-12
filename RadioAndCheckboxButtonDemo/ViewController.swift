//
//  ViewController.swift
//  RadioButtonDemo
//
//  Created by Manish on 10/01/2018.
//  Copyright © 2018 Manish. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
        viewGroup2.buttonContainer.radioButtonDelegate = self
        viewGroup2.buttonContainer.setEachRadioButtonColor {
            return RadioButtonColor(active: $0.tintColor , inactive: $0.tintColor)
        }
        // You can customize circle as well
//        viewGroup2.setEachRadioButtonCircle { _ in
//            return RadioButtonCircleHeight.init(outerCircle: 10, innerCircle: 5, outerCircleBorder: 1)
//        }
    
    }
    
    func setupGroup3() {
        // Assign radio ration delegate if required
        optionAG3.delegate = self
        optionBG3.delegate = self
        group3Container.addButtons([optionAG3, optionBG3, optionCG3])
        group3Container.selectedButton = optionBG3
        
        // Set cutsom color for each button
        optionAG3.radioButtonColor = RadioButtonColor(active: UIColor.red, inactive: optionAG3.tintColor)
        optionBG3.radioButtonColor = RadioButtonColor(active: UIColor.black
            , inactive: optionBG3.tintColor)
        optionCG3.radioButtonColor = RadioButtonColor(active: UIColor.magenta, inactive: UIColor.red)
        
        // Set up cirlce size here
        optionAG3.radioCircle = RadioButtonCircleHeight.init(outerCircle: 10, innerCircle: 5, outerCircleBorder: 1)
        optionBG3.radioCircle = RadioButtonCircleHeight.init(outerCircle: 25, innerCircle: 10, outerCircleBorder: 5, contentPadding: 20)
        optionCG3.radioCircle = RadioButtonCircleHeight.init(outerCircle: 20, innerCircle: 20, outerCircleBorder: 5, contentPadding: 10)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController: RadioButtonDelegate {
    
    func radioButtonDidSelect(_ button: RadioButton) {
        print("Select: ", button.title(for: .normal)!)
    }
    
    func radioButtonDidDeselect(_ button: RadioButton) {
        print("Deselect: ",  button.title(for: .normal)!)
    }
}

