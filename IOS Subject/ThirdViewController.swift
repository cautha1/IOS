//
//  ThirdViewController.swift
//  Assignment1
//
//  Created by Cauthan Janet BULUMA (001171028) on 20/3/2024.
//

import UIKit
import MapKit
import CoreLocation
class ThirdViewController: UIViewController , UIColorPickerViewControllerDelegate, CLLocationManagerDelegate,MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    @available(iOS 14.0,*)

    @IBAction func changedClicked(_ sender: UIButton) {
        let picker = UIColorPickerViewController()
        //setting the intila color of the picker
        picker.selectedColor = self.view.backgroundColor!
        
        //setting delegate
        picker.delegate = self
        //presenting the color picker
        
        self.present(picker, animated: true, completion: nil)
        
    }
    
    @available(iOS 14.0,*)
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.view.backgroundColor = viewController.selectedColor
    }
    //call on every color selection done in the picker
    
    @available(iOS 14.0,*)
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        self.view.backgroundColor = viewController.selectedColor
        Colour.sharedInstance.selectedColour = self.view.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = Colour.sharedInstance.selectedColour
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
        // Check for location services
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        //Zoom to user location
        if let userlocation = locationManager.location?.coordinate{
            let viewRegion = MKCoordinateRegion(center: userlocation,latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(viewRegion, animated: false)
        }
        self.locationManager = locationManager
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        region.center = mapView.userLocation.coordinate
        mapView.setRegion(region, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
