//
//  MapViewController.swift
//  ProjectIOS
//
//  Created by Arno Lambert on 26/01/2017.
//  Copyright © 2017 Arno Lambert. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class MapViewController : UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    var koten: [Kot] = []
    let locationManager = CLLocationManager()
    let identifier = "Pin";
    let coordinateCentrumGent = CLLocationCoordinate2D(latitude: 51.054505, longitude: 3.720762)
    
    override func viewDidLoad() {
        self.mapView.delegate = self
        
        
        for kot in koten {
            addressToCoordinates(kot: kot)
        }
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true;
    }
    
    func addressToCoordinates(kot: Kot) {
        CLGeocoder().geocodeAddressString("\(kot.straatnaam) \(kot.huisnummer) \(kot.plaats)", completionHandler: { (placemarks, error) in
            if error != nil {
                print(error!)
                return
            }
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                
                self.mapView.region = MKCoordinateRegion(center: coordinate!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                let pin = MKPointAnnotation()
                pin.title = "\(kot.straatnaam) \(kot.huisnummer)"
                pin.coordinate = coordinate!
                self.mapView.addAnnotation(pin)
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .infoLight)
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "mapToDetailSegue", sender: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "mapToDetailSegue":
            let navigationController = segue.destination as! UINavigationController
            let kotViewController = navigationController.topViewController as! KotViewController
            let sender = sender as! MKAnnotationView
            let selectedIndex = sender.annotation!.title!
            for kot in koten {
                let kotnaam = "\(kot.straatnaam) \(kot.huisnummer)"
                if (kotnaam == selectedIndex){
                    kotViewController.kot = kot
                    break
                }
            }
        default:
            break
        }
    }
}
