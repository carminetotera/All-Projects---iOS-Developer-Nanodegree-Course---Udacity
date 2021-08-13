//
//  LocationsMapViewController.swift
//  Virtual_Tourist
//
//  Created by Carmine Totera on 13/08/21.
//

import UIKit
import MapKit

// MARK: - LocationsMapViewController

class LocationsMapViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    var pins:[Pin] = []
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let longPressGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        longPressGestureRecognizer.addTarget(self, action:#selector(recognizeLongPress(_:)))
        mapView.addGestureRecognizer(longPressGestureRecognizer)
    
        settingPins()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        settingPins()
    }
    
    @objc private func recognizeLongPress(_ sender: UILongPressGestureRecognizer) {
        // Do not generate pins many times during long press.
        if sender.state != UIGestureRecognizer.State.began {
            return
        }
        
        let coordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
        mapView.addAnnotationMap(coordinate: coordinate)
        CoreDataController.shared.addPin(coordinate: coordinate) { pin in
            pins.append(pin)
        }
    }
    
    func settingPins() {
        pins = CoreDataController.shared.loadPins()
        for pin in pins {
            let coord = CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.lon)
            mapView.addAnnotationMap(coordinate: coord)
        }
    }
}
