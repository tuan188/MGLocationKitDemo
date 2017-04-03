//
//  MapViewController.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 3/31/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    var currentRoute: MKPolyline?
    
    let locationService = LocationService()
    
    var datePickerPopup: Popup!
    
    @IBOutlet var dateLabel: UILabel!
    
    var currentDate: Date! {
        didSet {
            dateLabel.text = currentDate.dateString()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentDate = Date()
        
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pickDate(_ sender: Any) {
        if datePickerPopup == nil {
            let datePickerView = Bundle.main.loadNibNamed("DatePickerView", owner: self, options: nil)?[0] as! DatePickerView
            datePickerPopup = Popup(contentView: datePickerView, height: 200)
            datePickerView.okAction = { [weak self] date in
                self?.datePickerPopup.close(completion: { 
                    self?.currentDate = date
                    self?.loadRoute()
                })
            }
            datePickerView.cancelAction = { [weak self] in
                self?.datePickerPopup.close(completion: nil)
            }
        }
        datePickerPopup?.show()
    }
    
    @IBAction func centerToCurrentLocation(_ sender: Any) {
        centerToCurrentLocation()
    }
    
    private func centerToCurrentLocation() {
        if let location = mapView.userLocation.location {
            centerCamera(to: location)
        }
    }
    
    private func centerCamera(to location: CLLocation) {
        let camera = mapView.camera
        camera.centerCoordinate = location.coordinate
        
        mapView.camera = camera
        let viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
        
        mapView.setRegion(viewRegion, animated: true)
    }
    
    private func loadRoute() {
        locationService.all(currentDate).then { [unowned self] locations -> Void in
            let newRoute = self.polyline(locations: locations, title: "route")
            DispatchQueue.main.async {
                if let currentRoute = self.currentRoute {
                    self.mapView.remove(currentRoute)
                }
                self.currentRoute = newRoute
                self.mapView.add(self.currentRoute!)
            }
            
            }.catch { (error) in
                log.debug(error)
        }
    }
    
    @IBAction func drawRoute(_ sender: Any) {
        
        loadRoute()
    }
    
    private func polyline(locations: [Location], title:String) -> MKPolyline {
        var coords = locations.map { (location) -> CLLocationCoordinate2D in
            return CLLocationCoordinate2D(latitude: location.lat,
                                          longitude: location.lng)
        }
        
        let polyline = MKPolyline(coordinates: &coords, count: locations.count)
        polyline.title = title
        
        return polyline
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circle = overlay as? MKCircle {
            let renderer = MKCircleRenderer(circle: circle)
            let isRegion = circle.title ?? "" == "regionPlanned"
            renderer.fillColor = isRegion ? UIColor.blue.withAlphaComponent(0.2) : UIColor.red.withAlphaComponent(0.2)
            return renderer
        }
        
        
        let isRegion = overlay.title ?? "" == "regions"
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = isRegion ? UIColor.red.withAlphaComponent(0.8) : UIColor.blue.withAlphaComponent(0.8)
        renderer.lineWidth = isRegion ? 8.0 : 2.0
        
        return renderer
    }
    
}

