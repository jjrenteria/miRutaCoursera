//
//  ViewController.swift
//  MiRuta
//
//  Created by Juan Jose Renteria on 27/06/16.
//  Copyright © 2016 Juan Jose Renteria. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func vistaNormal(sender: UIButton) {
        mapView.mapType = .Standard
    }
    
    @IBAction func vitaSatelite(sender: UIButton) {
        mapView.mapType = .Satellite
    }
    
    @IBAction func vistaHibrida(sender: UIButton) {
        mapView.mapType = .Hybrid
    }
    
    var locationManager: CLLocationManager!
    var puntoAnterior : CLLocation?
    var puntoOrigen : CLLocation?
    var distancia = CLLocationDistance(floatLiteral: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
            
        }
        mapView.zoomEnabled = true
        mapView.showsUserLocation = true
        mapView.showsScale = true
        
    }
    
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1500, 1500)
        
        if puntoOrigen == nil {
            mapView.setRegion(region , animated: true)
            puntoOrigen = mapView.userLocation.location
            puntoAnterior = mapView.userLocation.location
        }

    }
    


    func agregarPin( location: CLLocation ) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = "Lat \(location.coordinate.latitude), Lon \(location.coordinate.longitude)"
        annotation.subtitle = "\(distancia)"
        mapView.addAnnotation( annotation )
    }

    // MARK
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        if puntoAnterior != nil {
            let d = newLocation.distanceFromLocation(puntoAnterior!)
            if  d > 50  {
                agregarPin( newLocation)
                puntoAnterior = newLocation
                distancia += d
                
            }
        }
    }
        



}

