//
//  LocationHomeViewController.swift
//  Felagi
//
//  Created by Semeon D on 9/20/17.
//  Copyright © 2017 Semeon D. All rights reserved.
//

import UIKit
import LocationPickerViewController
import GooglePlaces
import Firebase
import GeoFire

class LocationHomeViewController: UIViewController, CLLocationManagerDelegate {
   
    var location : Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        addViews()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleGeoFire))
        
    }
    
    @objc func handleGeoFire() {
        let databaseRef = Database.database().reference().child("posts_user")
        let geoFire = GeoFire(firebaseRef: databaseRef)
        let key = databaseRef.child("posts_user").childByAutoId().key
        //geoFire?.setLocation(CLLocation(latitude: 70, longitude:70), forKey: "firebase-hq")
        if let lat = self.location?.latitude {
            print("************* ", lat)
        }
        if let long = self.location?.longitude {
            print("************* ", long)
        }
        if let lat = self.location?.latitude, let  long = self.location?.longitude {
            geoFire?.setLocation(CLLocation(latitude:lat, longitude:long ), forKey: key, withCompletionBlock: { (error) in
                if let error = error {
                    print("********** error: ", error)
                }else {
                    print("********** saved successfully")
                }
            })
        } else {
            print("********** lat or long or both are missing")
        }
        
        
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    let locationField : UITextField = {
        let locField = UITextField()
        locField.placeholder = "please select a location"
        locField.translatesAutoresizingMaskIntoConstraints = false
        locField.backgroundColor = .white
        locField.borderStyle = UITextBorderStyle.roundedRect
        return locField
    }()
    
    func addViews() {
        //locationField.inputView = self.locationPicker
        //locationField.addTarget(self, action: #selector(handleFieldTap), for: UIControlEvents.touchUpInside)
        locationField.addTarget(self, action: #selector(handleFieldTap), for: UIControlEvents.editingDidBegin)
        view.addSubview(locationField)
        locationField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        locationField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        locationField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        locationField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6)
    }
    
    @objc func handleFieldTap(){
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        present(autoCompleteController, animated: true, completion: nil )
    }

}
extension LocationHomeViewController:GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //print(place.formattedAddress)
        //print("Place address components: \(place.addressComponents)")
        //self.location = [place.coordinate.latitude, place.coordinate.longitude]
        location?.longitude = place.coordinate.longitude
        location?.latitude = place.coordinate.latitude
        
        
        let databaseRef = Database.database().reference().child("posts_user")
        let geoFire = GeoFire(firebaseRef: databaseRef)
        let key = databaseRef.child("posts_user").childByAutoId().key
        
        geoFire?.setLocation(CLLocation(latitude:place.coordinate.latitude, longitude:place.coordinate.longitude ), forKey: key, withCompletionBlock: { (error) in
            if let error = error {
                print("********** error: ", error)
            }else {
                print("********** saved successfully")
            }
        })
        
        
        if let components = place.addressComponents {
            for comp in components {
                if comp.type == "administrative_area_level_2" {
                    print("Here is the City : \(comp.name)")
                }
                if comp.type == "country" {
                    print("here is the country : \(comp.name)")
                }
                if comp.type == "locality" {
                    print("here is the locality: ", comp.name)
                }
            }
        }
        
        dismiss(animated: true, completion: nil )
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("******* error authocomplete" ,error )
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
