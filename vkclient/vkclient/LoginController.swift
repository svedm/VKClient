//
//  ViewController.swift
//  vkclient
//
//  Created by Svetoslav Karasev on 07.03.16.
//  Copyright © 2016 Svetoslav Karasev. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func signIn(sender: UIButton) {
        if loginField.hasText() && passwordField.hasText() {
            let login = loginField.text!, password = passwordField.text!
            
            let alertController = UIAlertController(title: "Ololo", message: "\(login) \(password)",preferredStyle: .Alert)
            
            let button = UIAlertAction(title: "ok", style: .Cancel, handler: nil)
            
            alertController.addAction(button)
       
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
}

