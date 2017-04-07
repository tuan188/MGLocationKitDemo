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
    
    var circles: [MKCircle] = []
    
    var currentDate: Date! {
        didSet {
            dateLabel.text = currentDate.dateString
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentDate = Date()
        
        mapView.delegate = self
        
        drawRegions()
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
                    self?.clearMap()
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
    
    @IBAction func drawRoute(_ sender: Any) {
        clearMap()
        loadRoute()
    }
    
    @IBAction func drawProcessedRoute(_ sender: Any) {
        clearMap()
        loadProccessedRoute()
    }
    
    private func loadRoute() {
        locationService.all(currentDate).then { [unowned self] locations -> Void in
            let newRoute = self.polyline(locations: locations, title: "route")
            let annotations = self.annotations(locations: locations)
            
            DispatchQueue.main.async {
                self.currentRoute = newRoute
                self.mapView.add(self.currentRoute!)
                
                self.mapView.addAnnotations(annotations)
            }
            
            }.catch { (error) in
                log.debug(error)
        }
    }
    
    private func loadProccessedRoute() {
        locationService.all(currentDate).then { [unowned self] locations -> Void in
            let proccessedLocation = self.locationService.preprocessing(locations)
            
            
            let (stopPoints, route) = self.locationService.extractStopPoints(proccessedLocation)
            let stopPointsAnnotations = self.annotations(clusters: stopPoints)
            let annotations = self.annotationsWithoutStopPoints(locations: route)
            let newRoute = self.polyline(locations: route, title: "route")
            let circles = self.circles(clusters: stopPoints)
            
            DispatchQueue.main.async {
                self.currentRoute = newRoute
                self.mapView.add(self.currentRoute!)
                
                self.mapView.addAnnotations(annotations)
                self.mapView.addAnnotations(stopPointsAnnotations)
                self.circles = circles
                circles.forEach({ (circle) in
                    self.mapView.add(circle)
                })
                
            }
            
            }.catch { (error) in
                log.debug(error)
        }
    }
    
    private func clearMap() {
        self.circles.forEach({ circle in
            self.mapView.remove(circle)
        })
        if let currentRoute = self.currentRoute {
            self.mapView.remove(currentRoute)
        }
        self.removeAllAnnotations()
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
    
    private func annotations(locations: [Location]) -> [MapAnnotation] {
        return locations.map { (location) -> MapAnnotation in
            return MapAnnotation(title: location.description, coordinate: CLLocationCoordinate2DMake(location.lat, location.lng), type: location.type)
        }
    }
    
    private func annotationsWithoutStopPoints(locations: [Location]) -> [MapAnnotation] {
        return locations.map { (location) -> MapAnnotation in
            return MapAnnotation(title: location.description, coordinate: CLLocationCoordinate2DMake(location.lat, location.lng), type: .route)
        }
    }
    
    private func annotations(clusters: [LocationCluster]) -> [MapAnnotation] {
        return clusters.map { (cluster) -> MapAnnotation in
            return MapAnnotation(title: cluster.description, coordinate: cluster.centerLocation.location.coordinate, type: LocationType.arrival)
        }
    }
    
    
    private func circles(clusters: [LocationCluster]) -> [MKCircle] {
        return clusters.map({ (cluster) -> MKCircle in
            let circle = MKCircle(center: cluster.centerLocation.location.coordinate, radius: distanceThreshold)
            circle.title = "regionPlanned"
            return circle
        })
    }
    
    fileprivate func drawRegions() {
//        AppDelegate.sharedInstance().backgroundLocationManager.addedRegionsListener = { result in
//            if case let .Success(locations) = result {
//                self.circles.forEach({ circle in
//                    self.mapView.remove(circle)
//                })
//                
//                locations.forEach({ location in
//                    let circle = MKCircle(center: location.coordinate, radius: BackgroundLocationManager.RegionConfig.regionRadius)
//                    circle.title = "regionPlanned"
//                    self.mapView.add(circle)
//                    self.circles.append(circle)
//                })
//            }
//        }
        
    }
    
    fileprivate func removeAllAnnotations() {
        if self.mapView.annotations.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
        }
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        let reuseIdentifier = "annotationIdentifier"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        }
        else {
            annotationView?.annotation = annotation
        }
        
        if let mapAnnotation = annotation as? MapAnnotation {
            let image: UIImage
            switch mapAnnotation.type {
            case .arrival:
                image = #imageLiteral(resourceName: "icon_annotation_green")
            case .departure:
                image = #imageLiteral(resourceName: "icon_annotation_blue")
            default:
                image = #imageLiteral(resourceName: "dot")
            }
            annotationView?.image = image
        }
        
        return annotationView
    }
    
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

class MapAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var type : LocationType
    var title : String?
    
    init(title:String? = nil, coordinate: CLLocationCoordinate2D, type: LocationType) {
        self.title = title
        self.coordinate = coordinate
        self.type = type
    }
}


