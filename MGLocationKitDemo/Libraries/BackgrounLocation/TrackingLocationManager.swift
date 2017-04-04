import CoreLocation

public typealias Listener = (Result<CLLocation>) -> ()

public typealias VisitTrackingListener = (Result<CLVisit>) -> ()

protocol TrackingLocationManagerDelegate {
    func trackingLocationManager(didVisit visit: CLVisit)
}

final public class TrackingLocationManager: NSObject {
    
    fileprivate lazy var significantLocationManager: CLLocationManager = {
        var locationManager: CLLocationManager = CLLocationManager()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        return locationManager
    }()
    
    fileprivate lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.distanceFilter = 50  // default is 100
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true

        return manager
    }()
    
//    fileprivate lazy var monitorVisitsLocationManager: CLLocationManager = {
//        let manager = CLLocationManager()
//        manager.distanceFilter = 50  // default is 100
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        manager.requestAlwaysAuthorization()
//        manager.allowsBackgroundLocationUpdates = true
//        
//        return manager
//    }()
    
    
    fileprivate var listener: Listener?
    fileprivate var visitTrackingListener: VisitTrackingListener?
    
    func startSignificantLocationChanges() {
        event.add(content: "startSignificantLocationChanges")
        significantLocationManager.delegate = self
        significantLocationManager.startMonitoringSignificantLocationChanges()
    }
    
    func startMonitoringVisits(listener: @escaping VisitTrackingListener) {
        event.add(content: "startMonitoringVisits")
        self.visitTrackingListener = listener
        locationManager.delegate = self
        locationManager.startMonitoringVisits()
    }
    
    func requestLocation(listener: @escaping Listener) {
        self.listener = listener
        locationManager.delegate = self
        
        if significantLocationManager.delegate == nil {
            startSignificantLocationChanges()
        }
        locationManager.requestLocation()
    }
    
    public func start(listener: @escaping Listener) {
        self.listener = listener
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    public func stop() {
        locationManager.stopUpdatingLocation()
    }
}

extension TrackingLocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.max(by: { (location1, location2) -> Bool in
            return location1.timestamp.timeIntervalSince1970 < location2.timestamp.timeIntervalSince1970}) else { return }
        
        if manager == significantLocationManager {
            locationManager.requestLocation()
        } else {
            listener?(Result.Success(location))
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    public func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        event.add(content: "EVENT: visit " + visit.description)
        self.visitTrackingListener?(Result.Success(visit))
    }
}
