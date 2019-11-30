//
//  CheckInPlacePickerViewController.swift
//  Aceros
//
//  Created by Apple on 23/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import GoogleMaps

protocol CheckInPlacePickerViewControllerDelegate:class {
    func CheckInPlaceAndCoordinateSelected(address:String, coordinates: CLLocationCoordinate2D)
}

class CheckInPlacePickerViewController: UIViewController ,UISearchBarDelegate, GMSMapViewDelegate{
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: GMSMapView!
    
    //MARK:- VARIABLES
    var currentMarker:GMSMarker?
    var delegate:CheckInPlacePickerViewControllerDelegate?
    var addressSelected :String?
    var cordinatesSelected :CLLocationCoordinate2D?
    
    //MARK:- VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if currentMarker == nil{
            DispatchQueue.main.async {
                self.zoomAndPinInitialCurrentLocation()
            }
        }
       
    }
    
    //MARK:- CUSTOM FUNCTIONS
    
    //MARK: - Zoom And Pin To Current Location
    
    @objc func zoomAndPinInitialCurrentLocation(){
        
        let longlast = UserDefaults.standard.value(forKey: "lastUpdatedLong") as? Double
        let latlast = UserDefaults.standard.value(forKey: "lastUpdatedLat") as? Double
        self.setupMarker(loc: CLLocation.init(latitude: /latlast, longitude: /longlast), getAddress: true)
        
        
        // start Location manager // get  current location
        
        LocationManager.sharedInstance.getLocation { [weak self](location, error) in
            if error == nil{
                guard let loc = location else{return}
                DispatchQueue.main.async {
                    self?.setupMarker(loc: loc)
                }
            }
            else{
                switch /error?.code{
                case 2:
                    UtilityFunctions.show(alert: R.string.localizable.popLocTitle(), message: R.string.localizable.popNoLocation(), buttonOk: {
                        let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
                        if let url = settingsUrl {
                            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                        }
                    }, viewController: /self, buttonText: R.string.localizable.popSetting())
                    
                default:
                    UtilityFunctions.makeToast(text: "\(/error?.localizedDescription)", type: .error)
                }
            }
        }
    }
    
    func setupMarker(loc:CLLocation,getAddress:Bool = true){
        self.mapView.clear()
        currentMarker?.map = nil
        currentMarker = GMSMarker(position: loc.coordinate)
        currentMarker?.icon = R.image.ic_m_location_pin()
        currentMarker?.map = mapView
        currentMarker?.zIndex = 1
        self.mapView.camera = GMSCameraPosition(target: loc.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        mapView.selectedMarker = currentMarker
        if getAddress{
            getPlaceNameFromRevereseGeocoding(location: loc)
        }
    }
    
    //MARK:-  MAPVIEW DELGATES
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let loc = CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.setupMarker(loc: loc)
    }
    
    
    func getPlaceNameFromRevereseGeocoding(location:CLLocation){
        
        LocationManager.sharedInstance.getReverseGeoCodedLocation(location: location) { [weak self](location, placemark, error) in
            var addresstext = ""
            if let subThoroughfare  =  placemark?.subThoroughfare {
                addresstext.append(subThoroughfare)
            }
            
            if let thoroughfare  =  placemark?.thoroughfare {
                addresstext.append(" \(thoroughfare)")
            }
            if let sublocality  =  placemark?.subLocality {
                addresstext.append(" \(sublocality)")
            }
            
            if let locality  =  placemark?.locality {
                addresstext.append(" \(locality)")
            }
            
            if let postalCode  =  placemark?.postalCode {
                addresstext.append(" \(postalCode)")
            }
            
            if let administrativeArea  =  placemark?.administrativeArea {
                addresstext.append(" \(administrativeArea)")
            }
            
            if let country  =  placemark?.country {
                addresstext.append(" \(country)")
            }
            
            self?.currentMarker?.title = R.string.localizable.checkInCheckInAddress()
            self?.currentMarker?.snippet = addresstext
            self?.addressSelected = addresstext
            self?.cordinatesSelected = location?.coordinate
        }
    }
    
    //MARK:-  BUTTON ACTIONS
    
    @IBAction func actionBAck(_ sender: Any) {
        UIApplication.getTopMostViewController()?.dismiss(animated: true)
    }
    
    @IBAction func actionDoneSelectingCheckInPlace(_ sender: Any) {
        if let address = addressSelected , let coord  = cordinatesSelected {
            delegate?.CheckInPlaceAndCoordinateSelected(address: address, coordinates: coord)
            UIApplication.getTopMostViewController()?.dismiss(animated: true)
        }
    }
    
    //MARK:-  SEARCH BAR DELEGATES
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        LocationManager.sharedInstance.showAutocomplete(vc: self)
        LocationManager.sharedInstance.placeCompletionHandler = { [weak self] item in
            guard let item = item else{return}
            var completeName = ""
            if let name = item.name{
                completeName.append(name)
            }
            if let address = item.formattedAddress{
                completeName.append(", \(address)")
            }
            
            
            self?.addressSelected = completeName
            self?.cordinatesSelected = item.coordinate
            self?.setupMarker(loc: CLLocation.init(latitude: item.coordinate.latitude, longitude: item.coordinate.longitude), getAddress: false)
            
//            self?.mapView.clear()
//            self?.currentMarker = GMSMarker(position:CLLocationCoordinate2D.init(latitude: item.coordinate.latitude, longitude: item.coordinate.longitude))
//            self?.currentMarker?.icon = R.image.ic_m_location_pin()
//            self?.mapView.animate(toLocation: item.coordinate)
//            self?.mapView.animate(toZoom: 10.0)
//            self?.currentMarker?.map = self?.mapView
//            self?.mapView.selectedMarker = self?.currentMarker
            
            self?.currentMarker?.title = R.string.localizable.checkInCheckInAddress()
            self?.currentMarker?.snippet = completeName
            
        }
        return true
    }
    
    
    
    
}
