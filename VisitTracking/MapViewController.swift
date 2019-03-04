//
//  MapViewController.swift
//  VisitTracking
//
//  Created by Ankit Kumar on 26/02/2019.
//  Copyright © 2019 Ankit Kumar. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.userTrackingMode = .follow
        
        let annotations = LocationStorage.shared.locations.map { annotationForLocation($0) }
        mapView.addAnnotations(annotations)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(newLocationAdded(_:)),
            name: .newLocationSaved,
            object: nil)
        
    }
    
    @IBAction func addItemPressed(_ sender: Any) {
        guard let currentLocation = mapView.userLocation.location else {
            return
        }
        
        LocationStorage.shared.saveCLLocationToDisk(currentLocation)
    }
    
    func annotationForLocation(_ location: Location) -> MKAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = location.dateString
        annotation.coordinate = location.coordinates
        return annotation
    }
    @objc func newLocationAdded(_ notification: Notification) {
        guard let location = notification.userInfo?["location"] as? Location else {
            return
        }
        
        let annotation = annotationForLocation(location)
        mapView.addAnnotation(annotation)
    }

}
