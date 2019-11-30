//
//  AddClientViewController.swift
//  Aceros
//
//  Created by Apple on 01/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import IBAnimatable
import ActionSheetPicker_3_0

protocol AddClientViewControllerDelegate {
    func reloadClients()
}

class AddClientViewController: UIViewController,GMSMapViewDelegate {
    // MARK: - Outlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tfClientName: UITextField!
    @IBOutlet weak var tfPosition: UITextField!
    @IBOutlet weak var lblPurpose: UILabel!
    @IBOutlet weak var tfMobileNo: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tvAddress: AnimatableTextView!
    @IBOutlet weak var tfPurpose: UITextField!
    @IBOutlet weak var viewMotiveOfVisit: UIView!
    @IBOutlet weak var heightViewMotiveOfVisit: NSLayoutConstraint!
    @IBOutlet weak var topSpaceMotiveOfVisit: NSLayoutConstraint!
    @IBOutlet weak var viewPositionInCompany: UIView!
    @IBOutlet weak var heightViewPositionInCompany: NSLayoutConstraint!
    
    @IBOutlet weak var topSpacePositionInCompany: NSLayoutConstraint!
    
    // MARK: - Variables
    var currentMarker:GMSMarker?
    var delegate:AddClientViewControllerDelegate?
    var isCheckIn = false
    var checkInLocation:CLLocation?
    var checkInAddress :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfPurpose.isUserInteractionEnabled = false
        
        if isCheckIn{
            self.viewSetupCheckIn()
        }
        else{
            self.viewSetup()
        }
        self.mapView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if isCheckIn{
            debugPrint("do nothing")
        }
        else{
            let loc = CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.zoomTocurrentLocation(location: loc)
        }
      
    }
    
    func viewSetup(){
        
        if  let loc = LatestCurrentLocationUser.location{
            self.zoomTocurrentLocation(location: loc)
        }
        
        self.tfPurpose.text = /CommonData.arrayDropDown?.purpose?[0].sname
        self.tfPurpose.tag = /CommonData.arrayDropDown?.purpose?[0].id
    }
    
    func viewSetupCheckIn(){
        
        if  let loc = checkInLocation{
            self.zoomTocurrentLocation(location: loc)
        }
        
        self.tfPurpose.text = /CommonData.arrayDropDown?.purpose?[0].sname
        self.tfPurpose.tag = /CommonData.arrayDropDown?.purpose?[0].id
        self.tvAddress.text = checkInAddress
        self.viewMotiveOfVisit.isHidden = true
        self.viewPositionInCompany.isHidden = true
        self.heightViewPositionInCompany.constant = 0.0
        self.topSpacePositionInCompany.constant = 0.0
        self.heightViewMotiveOfVisit.constant = 0.0
        self.topSpaceMotiveOfVisit.constant = 0.0

    }
    
    func zoomTocurrentLocation(location:CLLocation){
        // update first last last saved location
        
        self.mapView.clear()
        self.mapView.animate(to: GMSCameraPosition.init(target: CLLocationCoordinate2D.init(latitude: location.coordinate.latitude, longitude: location.coordinate.latitude), zoom: 14.0))
        currentMarker = GMSMarker(position:CLLocationCoordinate2D.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        currentMarker?.icon = R.image.ic_client_mapCopy6()
        self.mapView.animate(toLocation: location.coordinate)
        currentMarker?.map = self.mapView
        
        if !isCheckIn{
            self.getAddress(location: location)
        }
        
    }
    
    
    func getAddress(location:CLLocation){
        
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
    
    self?.tvAddress.text = addresstext
    }
    }
    
    func showMotivePicker(){
        
        let arr = CommonData.arrayDropDown?.purpose?.compactMap{$0.sname}
        
        ActionSheetStringPicker.show(withTitle: /title, rows:arr , initialSelection: 0, doneBlock: { (picker, indx, value) in
            self.tfPurpose.text = value as? String
            self.tfPurpose.tag = /CommonData.arrayDropDown?.purpose?[indx].id
            self.tfPurpose.resignFirstResponder()
            
        }, cancel: { (picker) in
            print("e")
        }, origin: tfPurpose)
    }
 
    
    func ValidateForm() throws {
        if /tfClientName.text?.isEmpty{throw AddClientErrors.enterClientName}
        if /tfPosition.text?.isEmpty{throw AddClientErrors.enterClientPosition}
        if /tfMobileNo.text?.isEmpty{throw AddClientErrors.enterPhoneNumber}
        if /tfEmail.text?.isEmpty{throw AddClientErrors.enterEmail}
        if !(/tfEmail.text?.isEmail){throw AddClientErrors.enterValidEmail}
        if !(/tfMobileNo.text?.isNumber) {throw AddClientErrors.enterValidPhoneNumber}
        if /tfMobileNo.text?.count < 4 ||  /tfMobileNo.text?.count > 16 {throw AddClientErrors.enterValidPhoneNumber}
    }
    
    //MARK: - Button Action
    
    @IBAction func actionSaveCLient(_ sender: Any) {
        do{
            try self.ValidateForm()
            self.saveClient()
        }
        catch {
            if let val =  error as? AddClientErrors{
            UtilityFunctions.makeToast(text: val.message, type: .error)
            }
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        UIApplication.topViewController()?.popVC()
    }
    
    //MARK: - API Requests
    
    func saveClient(){
        
        let addClientResponse:ResultCallback<User?,ResponseStatus>  = {[weak self] result in
            
            switch result {
            case .success(let data):
                guard let data = data else {return}
                if /data.success?.boolValue{
                    self?.delegate?.reloadClients()
                    UIApplication.topViewController()?.popVC()
                    UtilityFunctions.makeToast(text: R.string.localizable.popClientAdded()  , type: .success)
                }
                
            case .failure(let error):
                UtilityFunctions.makeToast(text: error.localizedDescription, type: .error)
            }
        }
        
        HomeTarget.addClient(name: /tfClientName.text, c_name: /tfClientName.text, mobile: /tfMobileNo.text, visit_motive: /tfPurpose.tag.toString, emails_id: /tfEmail.text, lati: "\(/currentMarker?.position.latitude)", lng: "\(/currentMarker?.position.longitude)", address: /tvAddress.text).requestCodable(showLoader: true, response: addClientResponse)
    }
    
    
}

extension AddClientViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if tfPurpose.isFirstResponder{
            self.showMotivePicker()
        }
    }
    
}
