//
//  ViewController.swift
//  OkCollectOkVerifyExample
//
//  Created by Julius Kiano on 16/06/2021.
//

import UIKit
import OkCore
import OkCollect
import OkVerify

class ViewController: UIViewController {
    private let okCollect = OkHiCollect() // initialise the OkCollect class
    private let okhiLocationService = OkHiLocationService() // optionally use the OkHiLocationService to manage location permissions
    private var okVerify:OkHiVerify? // define a OkHiVerify object that will be initialised with the OkHiUser
    private let okHiUser = OkHiUser(phoneNumber: "+254712345678").with(firstName: "Julius").with(lastName: "Kiano") // define your OkHiUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        okCollect.delegate = self // set your view controller as an OkCollect delegate
        okhiLocationService.delegate = self // set your view controller as an OkHiLocationService delegate
        okVerify = OkHiVerify(user: okHiUser) // initialise your okVerify variable
        okVerify?.delegate = self // set your view controller as an OkHiVerify delegate
    }

    @IBAction func onRequestPermissionButtonPress(_ sender: UIButton) {
        if !okhiLocationService.isLocationPermissionGranted() {
            okhiLocationService.requestLocationPermission(withBackgroundLocationPermission: true)
        }
    }
    
    @IBAction func onCreateAddressPress(_ sender: UIButton) {
        let okHiTheme = OkHiTheme().with(logoUrl: "https://cdn.okhi.co/icon.png").with(appBarColor: "#ba0c2f").with(appName: "OkHi")
        let okHiConfig = OkHiConfig().enableStreetView().enableAppBar()
        guard let vc = okCollect.viewController(with: okHiUser, okHiTheme: okHiTheme, okHiConfig: okHiConfig) else {
            return
        }
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func showMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func startVerification(location: OkHiLocation) {
        okVerify?.start(location: location) // start the address verification process
    }
    
}

extension ViewController: OkHiLocationServiceDelegate {
    func okHiLocationService(locationService: OkHiLocationService, didChangeLocationPermissionStatus locationPermissionType: LocationPermissionType, result: Bool) {
        if locationPermissionType == LocationPermissionType.always && result {
            showMessage(title: "Location Permission", message: "Status granted")
        }
        
    }
}

extension ViewController: OkCollectWebviewDelegate {
    func collect(didEncounterError error: OkHiError) {
        showMessage(title: error.code, message: error.message)
    }
    
    func collect(didSelectAddress user: OkHiUser, location: OkHiLocation) {
        startVerification(location: location)
    }
}

extension ViewController: OkVerifyDelegate {
    func verify(_ okVerify: OkHiVerify, didEncounterError error: OkHiError) {
        showMessage(title: error.code, message: error.message)
    }
    
    func verify(_ okVerify: OkHiVerify, didStart locationId: String) {
        showMessage(title: "Verification started", message: locationId)
    }
    
    func verify(_ okVerify: OkHiVerify, didEnd locationId: String) {
        
    }
}

