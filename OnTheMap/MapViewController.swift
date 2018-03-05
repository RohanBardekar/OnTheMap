//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Rohan Bardekar on 16/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func refresh(_ sender: Any) {
       
        self.reloadData()
    }
    
    @IBAction func addStudentLocation(_ sender: Any) {
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "AddLocationViewController") as! LocationViewController
        
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
      
        OTMClient.sharedInstance().logoutWithViewController(self) { (success, errorString) in performUIUpdatesOnMain {
            
            if success {
                self.appLogout()
                
            }
            else {
                
                if let errorString = errorString {
                    
                    self.displayError(errorString)
                }
            }
            }
        }
    }
    
    private func appLogout() {
        
        dismiss(animated: true, completion: nil)
    }
    
    private func displayError(_ errorString: String){
        
        print(errorString)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.mapView.delegate = self
        self.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView?.animatesDrop = true
            let callOutButton = UIButton(type: .detailDisclosure)
            pinView!.rightCalloutAccessoryView = callOutButton
            
        }
        else {
            
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let annotation = view.annotation!
        if let subtitle = annotation.subtitle {
            
            if let url = subtitle {
                if let actualURL = URL(string: url) {
                    
                    UIApplication.shared.open(actualURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    private func reloadData() {
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.showHideActivityIndicator(true)
        OTMClient.sharedInstance().getStudentLocations(self) { (success, errorString) in performUIUpdatesOnMain {
            
            if success {
                
                self.showHideActivityIndicator(false)
                let studentLocations: [StudentLocation] = StudentLocationCollection.all
                var annotations = [MKPointAnnotation]()
                
                for studentLocation in studentLocations {
                    
                    let lat = CLLocationDegrees(studentLocation.latitude)
                    let long = CLLocationDegrees(studentLocation.longitude)
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let annotation = MKPointAnnotation()
                    
                    annotation.coordinate = coordinate
                    annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
                    annotation.subtitle = "\(studentLocation.mediaURL)"
                    annotations.append(annotation)
                        
                    }
                
                self.mapView.addAnnotations(annotations)
                    
            }
            
            else {
                
                self.showAlert("Error Message", message: "Failed to fetch student locations")
            }
        }
        }
    }
    
    private func showAlert(_ title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: OTMClient.Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showHideActivityIndicator(_ show: Bool = false) {
        
        if show {
            
            self.activityIndicator.startAnimating()
        }
        else {
            
            self.activityIndicator.stopAnimating()
        }
    }
    
}
