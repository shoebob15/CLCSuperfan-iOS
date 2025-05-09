//
//  EventRedeemViewController.swift
//  CLCSuperfan
//
//  Created by Brennan Reinhard on 3/12/25.
//

import UIKit
import MapKit

class EventRedeemViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var event: Event! = nil
    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var redeemButton: UIButton!
    
    @IBOutlet weak var scanLabel: UILabel!

    @IBOutlet weak var titleLabel: UILabel!
    private var canRedeem = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        map.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        map.addOverlay(
            MKCircle(center: CLLocationCoordinate2D(latitude: Double(event.lat), longitude: Double(event.lon)), radius: 402))
        
        map.showsUserLocation = true

        map.showAnnotations(map.annotations, animated: true)
        
        if AppData.mostRecentScan != nil && AppData.mostRecentScan!.timeIntervalSinceNow < 3600 {
                redeemButton.backgroundColor = .systemGray
            redeemButton.layer.cornerRadius = 10
            scanLabel.text = "Next scan in \((Int)(60 + (AppData.mostRecentScan!.timeIntervalSinceNow / 60.0)))mins \((Int)(60 + AppData.mostRecentScan!.timeIntervalSinceNow.truncatingRemainder(dividingBy: 60)))secs"
                scanLabel.isHidden = false

            canRedeem = false
        } else {
            canRedeem = true
            scanLabel.isHidden = true
            redeemButton.backgroundColor = .systemOrange
            redeemButton.layer.cornerRadius = 10
        }
        
        titleLabel.text = event.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(event.lat), longitude: Double(event.lon)), latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
        
        
    }
    
    // render mkcircle as circle overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        guard let circle = overlay as? MKCircle else { return MKOverlayRenderer(overlay: overlay) }
        
        let renderer = MKCircleRenderer(circle: circle)
        
        renderer.strokeColor = .orange
        renderer.lineWidth = 1
        return renderer
    }
    
    @IBAction func redeemAction(_ sender: UIButton) {
        if canRedeem {
            performSegue(withIdentifier: "scanSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scanSegue" {
            let vc = segue.destination as! ScannerViewController
            
            vc.event = event
        }
    }
    
    

}
