//
//  KotViewController.swift
//  ProjectIOS
//
//  Created by Arno Lambert on 28/12/2016.
//  Copyright © 2016 Arno Lambert. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class KotViewController: UITableViewController {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var adresLabel: UILabel!
    @IBOutlet weak var plaatsLabel: UILabel!
    @IBOutlet weak var optiesLabel: UILabel!
    @IBOutlet weak var huurprijsLabel: UILabel!
    @IBOutlet weak var afvalLabel: UILabel!
    @IBOutlet weak var internetLabel: UILabel!
    @IBOutlet weak var kabelLabel: UILabel!
    @IBOutlet weak var totaalLabel: UILabel!
    @IBOutlet weak var waarborgbedragLabel: UILabel!
    @IBOutlet weak var waarborgbetalingLabel: UILabel!
    @IBOutlet weak var contractTypeLabel: UILabel!
    @IBOutlet weak var contractDuurLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var kot: Kot!
    var kotLocation: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        title = "Kot in de " + kot.straatnaam
        typeLabel.text = kot.type
        adresLabel.text = "\(kot.straatnaam) \(kot.huisnummer)"
        plaatsLabel.text = kot.plaats
        optiesLabel.text = kot.opties
        huurprijsLabel.text = "€ \(kot.huurprijs)"
        afvalLabel.text = "€ \(kot.prijsAfvalverwerking)"
        internetLabel.text = "€ \(kot.prijsInternet)"
        kabelLabel.text = "€ \(kot.prijsKabeltv)"
        totaalLabel.text = "€ \(kot.totalePrijs)"
        waarborgbedragLabel.text = "€ \(kot.waarborg)"
        waarborgbetalingLabel.text = kot.betalingWaarborg
        contractTypeLabel.text = kot.contractType
        contractDuurLabel.text = kot.contractDuration

        addressToCoordinates(address: "\(kot.straatnaam) \(kot.huisnummer) \(kot.plaats)")
        

    }
    
    func addressToCoordinates(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
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
                pin.coordinate = coordinate!
                self.mapView.addAnnotation(pin)

            }
        })
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if !splitViewController!.isCollapsed {
            navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem
        }
    }
}
