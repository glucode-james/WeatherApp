//
//  MyLocationModel.swift
//  WeatherApp
//

import CoreLocation

protocol MyLocationModelDelegate: class {
    func myLocationModel(locationServicesDisabled myLocationModel: MyLocationModel)
    func myLocationModel(locationUpdated myLocationModel: MyLocationModel)
}

class MyLocationModel: NSObject, CLLocationManagerDelegate {

    /* Constant for use in view models */
    static let myLocationInternalID = "my_location"
    static let myLocation = City(city: "My Location", country: "", latitude: "-22.900", longitude: "-43.233", internalID: myLocationInternalID)

    private static let instance = MyLocationModel()

    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?

    weak var delegate: MyLocationModelDelegate?

    static func getInstance() -> MyLocationModel {
        return instance
    }

    override private init() {
        super.init()

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func getCurrentLocation() -> CLLocation? {
        return currentLocation
    }

    func startUpdating() {
        handleAuth()
    }

    func stopUpdating() {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last

        delegate?.myLocationModel(locationUpdated: self)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleAuth()
    }

    private func handleAuth() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            delegate?.myLocationModel(locationServicesDisabled: self)
        default:
            locationManager.startUpdatingLocation()
        }
    }
}
