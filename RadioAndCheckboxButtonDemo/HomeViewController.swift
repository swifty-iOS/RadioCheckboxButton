//
//  HomeViewController.swift
//  RadioAndCheckboxButtonDemo
//
//  Created by Manish Bhande on 13/02/18.
//  Copyright © 2018 Manish. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var containerRadio: UIView!
    @IBOutlet weak var containerCheckbox: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerRadio.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentValueChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: containerCheckbox.isHidden = false
        case 1: containerCheckbox.isHidden = true
        default: break
        }
        containerRadio.isHidden = !containerCheckbox.isHidden
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
