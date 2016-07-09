//
//  LocationCellularManager.swift
//  FinancialAid
//
//  Created by GaoChengliang on 16/6/16.
//  Copyright © 2016年 pku. All rights reserved.
//

import Foundation
import CocoaLumberjack
import CoreLocation
import CoreTelephony

class LocationCellularManager: NSObject, CLLocationManagerDelegate {

    // MARK: Singleton
    static let sharedInstance = LocationCellularManager()

    var locationManager: CLLocationManager!
    var carrier: CTCarrier!
    var timer: NSTimer!
    var timeInterval = 1.0
    var battery: Float = 1.0

    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 500.0
        locationManager.requestAlwaysAuthorization()
        carrier = CTTelephonyNetworkInfo().subscriberCellularProvider
        UIDevice.currentDevice().batteryMonitoringEnabled = true
    }

    func getLocationCellular(completion: (() -> Void)?) {
        locationManager.delegate = self
        startGetLocationCellular()
        battery = UIDevice.currentDevice().batteryLevel
        if battery >= 0.6 {
            timeInterval = 900
            timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self,
                    selector: #selector(LocationCellularManager.startGetLocationCellular),
                                                           userInfo: nil, repeats: true)
        } else if battery >= 0.2 {
            timeInterval = 1800
            timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self,
                    selector: #selector(LocationCellularManager.startGetLocationCellular),
                                                           userInfo: nil, repeats: true)
        }
        if completion != nil {
            completion!()
        }
    }

    func startGetLocationCellular() {
        locationManager.startUpdatingLocation()
        if carrier != nil {
            let name = carrier.carrierName
            let isoCode = carrier.isoCountryCode
            let countryCode = carrier.mobileCountryCode
            let networkCode = carrier.mobileNetworkCode
            DDLogInfo("Get cellular success, \(name) \(isoCode) \(countryCode) \(networkCode)")
        }
    }

    func stopGetLocationCellular() {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let curLocation = locations.last! as CLLocation
        let latitude = curLocation.coordinate.latitude
        let longitude = curLocation.coordinate.longitude
        DDLogInfo("Get location success, latitude: \(latitude) longitude: \(longitude)")
        stopGetLocationCellular()
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        DDLogInfo("Get location error: \(error.localizedDescription)")
        stopGetLocationCellular()
    }
}
