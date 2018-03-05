//
//  LocationViewController.swift
//  OnTheMap
//
//  Created by Rohan Bardekar on 16/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController, UITextViewDelegate, MKMapViewDelegate {

    
    @IBOutlet weak var findOnTheMapButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var address: UITextView!
    
    var placeMark: CLPlacemark!
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        self.address.delegate = self
        self.setUpButton()
    }
    
    private func setUpButton(){
        
        findOnTheMapButton.layer.cornerRadius = 5
        findOnTheMapButton.layer.borderWidth = 0
    }
    
    @IBAction func findOnTheMap(_ sender: Any) {
        
        let clGeoEncoder = CLGeocoder()
        self.activityIndicator.startAnimating()
        
        clGeoEncoder.geocodeAddressString(address.text) { (placemarks, error) in
            
            if error == nil {
                
                if let placemarks = placemarks {
                    
                    self.placeMark = placemarks[0] as CLPlacemark
                }
            
                self.performSegue(withIdentifier: "studentMap", sender: self)
            }
            
            else {
                
                self.showAlert("Address Search", message: "Address not found")
            }
            
            self.activityIndicator.stopAnimating()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "studentMap" {
          
            let mapStudentViewController = segue.destination as! StudentMapViewController
            mapStudentViewController.placeMark = placeMark
            mapStudentViewController.mapString = address.text
            print(address.text)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func showAlert(_ title: String, message: String) {
       
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: OTMClient.Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
        
            textView.resignFirstResponder()
            
            return false
        }
        
        return true
    }

}
