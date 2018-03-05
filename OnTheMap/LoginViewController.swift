//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Rohan Bardekar on 16/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        username.delegate = self
        password.delegate = self
        self.showHideActivityIndicator(false)
    }
    
    
    @IBAction func authenticate(_ sender: Any) {
        
        self.errorLabel.text = ""
        authenticate(username.text!, password.text!)
       
    }
    
    func authenticate(_ userName: String, _ password: String) {
        
        OTMClient.sharedInstance().authenticateWithViewController(self, userName, password) { (success, errorString) in performUIUpdatesOnMain {
            
            self.showHideActivityIndicator(false)
            
            if success {
                
                self.appLogin()
            }
                
            else if (self.username.text!.isEmpty || self.password.text!.isEmpty){
                
                self.enableDisableTextBoxAndButton(false)
            }
            
            else {
                
                //Post Review Change - "The internet connection is offline, please try again"
                if let errorString = errorString {
                    
                    self.displayError(errorString)
                }
            }
            
            self.enableDisableTextBoxAndButton(true)
            
            }
        }
    }
    
    //Post Review Change - Keyboard dismiss on pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    private func appLogin() {
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "TabViewController") as! UITabBarController
        present(controller, animated: true, completion: nil)
    
    }
    
    private func enableDisableTextBoxAndButton(_ disable: Bool = false) {
        
        self.username.isEnabled = disable
        self.password.isEnabled = disable
        self.loginButton.isEnabled = disable
    }
    
    private func showHideActivityIndicator(_ show: Bool = false) {
        
        if show {
            
            self.spinner.startAnimating()
        }
        else {
            
            self.spinner.stopAnimating()
        }
    }
    
    private func displayError(_ errorString: String) {
       
        showAlert("Login Message", message: errorString)
    }
    
    func showAlert(_ title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: OTMClient.Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
