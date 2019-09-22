//
//  ViewController.swift
//  SiteSeer
//
//  Created by Kevin Chen on 3/15/2019.
//  Copyright © 2019 New York University. All rights reserved.
//

import UIKit
import WebKit
import Firebase
import CoreLocation
import CoreMotion
import MapKit
// import CoreMotion

class ViewController: UIViewController, CLLocationManagerDelegate {
    // Setup App elements
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    //var motMananger = CMMotionManager()
    var direction = 0.0;
    var original_direction = 0.0;

    // Function when open opens (main loop)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Heading
        locManager.startUpdatingHeading()
        // motMananger.startGyroUpdates()
        //startGyros()
    }
    
    @IBAction func touch_down(_ sender: Any) {
        original_direction = direction
    }
    
    @IBAction func long_press(_ sender: Any) {
        let database = Database.database().reference(fromURL: "https://hacksbu1.firebaseio.com/").child("movement")
        
        var left_range = original_direction - 20
        var right_range = original_direction + 20
        if left_range < 0 {
            left_range = 360 - left_range
        }
        else if right_range > 360 {
            right_range = right_range - 360
        }
        
        // If the range is between the LEFT side
        if direction < left_range {
            print("LEFT")
            database.updateChildValues(["1":"Left"])
        }
        // If the range is between the RIGHT side
        else if direction > right_range {
            print("RIGHT")
            database.updateChildValues(["1":"Right"])
        }
        else {
            print("STRAIGHT")
            database.updateChildValues(["1":"Straight"])
        }
        
    }
    
    @IBAction func done(_ sender: Any) {
        let database = Database.database().reference(fromURL: "https://hacksbu1.firebaseio.com/").child("movement")
        print("STOPPED")
        database.updateChildValues(["1":"Stop"])
    }
    
    // o: 20, L: 340 and 20 OR R: 20 and 40

//    func startGyros() {
//        if motMananger.isGyroAvailable {
//            self.motMananger.gyroUpdateInterval = 1.0 / 2.0
//            self.motMananger.startGyroUpdates()
//
//            // Configure a timer to fetch the accelerometer data.
//            var timer = Timer(fire: Date(), interval: (1.0/2.0),
//                               repeats: true, block: { (timer) in
//                                // Get the gyro data.
//                                if let data = self.motMananger.gyroData {
//                                    let x = data.rotationRate.x
//                                    let y = data.rotationRate.y
//                                    let z = data.rotationRate.z
//                                    // print(x, y, z)
//                                    // Use the gyroscope data in your app.
//                                }
//            })
//
//            // Add the timer to the current run loop.
//            RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
//        }
//    }
    
    // function to run when app opens
    override func viewDidAppear(_ animated: Bool) {
        locManager.requestWhenInUseAuthorization()
        locManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.startUpdatingLocation()
        }
        else {
            print("Location authorization not allowed")
        }
    }
    
    // Need Y and X for Left/Right and Up/Down
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let database = Database.database().reference(fromURL: "https://hacksbu1.firebaseio.com/").child("data")
        database.updateChildValues(["lr":newHeading.magneticHeading]) // Sets {“maps” : {“trigger” : {“1” : true}}}
        direction = newHeading.magneticHeading.magnitude
        // print(newHeading.magneticHeading)
        //print(motMananger.gyroData.hashValue.magnitude)
//        if let data = self.motMananger.gyroData {
//
//            let x = round(data.rotationRate.x * 100)
//            let y = round(data.rotationRate.y * 100)
//            let z = round(data.rotationRate.z * 100)
//            //print(x, y, z)
//            database.updateChildValues(["x":x])
//            database.updateChildValues(["y":y])
//            database.updateChildValues(["z":z])
//        }
    }
}
