//
//  HomeMapViewController.swift
//  Aceros
//
//  Created by Apple on 15/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SideMenu
import IBAnimatable
import PullUpController
import GoogleMaps

struct LatestCurrentLocationUser {
    static var location:CLLocation?{
        didSet{
            UserDefaults.standard.set(location?.coordinate.latitude, forKey: "lastUpdatedLat")
            UserDefaults.standard.set(location?.coordinate.longitude, forKey: "lastUpdatedLong")
        }
    }
    static var address = ""
}

struct CommonData{
    static var arrayDropDown : Dropdowns?
    static var arrayCheckIns : [Checkin_detail?]?
}

class HomeMapViewController: UIViewController,TimelineViewControllerDelegate,AddCheckInViewControllerDelegate,ProfileViewControllerDelegate {
    
    //MARK:- Outlets
    
    @IBOutlet weak var btnProfile: AnimatableButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viewDayIn: AnimatableView!
    @IBOutlet var viewConfirmCheckIn: AnimatableView!
    @IBOutlet weak var mapView: GMSMapView!
    
    //MARK:- Variables
    
    var menuLeftNavigationController: UISideMenuNavigationController?
    let pullUpVC = R.storyboard.main.timelineViewController()
    private var infoWindow = BuildingIconView()
    var currentMarker:GMSMarker?
    
    
    var arrPlaces : [Places]?{
        didSet{
            print("All Buildings")
        }
    }
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialViewSetup()
    }
    
    //MARK:- Initial View Setup
    
    func initialViewSetup(){
        
        self.leftMenuSetup()
        
        self.zoomAndPinInitialCurrentLocation()
        
        self.getCheckIns()
        
        self.getUserProfile(isloader: false)
        
        self.getCheckInAttributes()
        
        self.getAllBuildings(text: "")

        
        if let val = Singleton.shared.userData?.profile?.image, val != ""{
            let userImage =  APIConstants.imageBasePath + val
            btnProfile.kf.setImage(with: URL.init(string: userImage), for: .normal, placeholder: R.image.user(), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        if let name =  Singleton.shared.userData?.profile?.fullname, name != ""{
            lblUserName.text = "\(R.string.localizable.homeWelcome()) \(name)"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.zoomAndPinInitialCurrentLocation), name: Notification.Name(notificationIdentifier.ApplicationDidBecomeActive.rawValue), object: nil)
        

        
    }
    
    func alreadyDayInSetup(){
        if let view = viewDayIn{
            view.isHidden = true
        }
        
        if !(/Singleton.shared.userData?.profile?.is_day_out).boolValue{
            self.addPullUpTimelineController()
        }
    }
    
    func freshDaySetup(){
        
        if !(/Singleton.shared.userData?.profile?.is_day_out).boolValue{
            viewDayIn.isHidden = false
            if let vc = self.pullUpVC{
                vc.initialState = .hidden
                vc.pullUpControllerMoveToVisiblePoint(vc.initialPointOffset, animated: true, completion: nil)
            }
        }
        
    }
    
    //MARK: - Left menu setup
    
    func leftMenuSetup(){
        
        guard let leftMenuVc = R.storyboard.main.leftMenuViewController() else{return}
        leftMenuVc.delegate = self
        menuLeftNavigationController = UISideMenuNavigationController(rootViewController: leftMenuVc)
        menuLeftNavigationController?.navigationBar.isHidden = true
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuWidth =  288.0
        SideMenuManager.default.menuShadowRadius = 40.0
        SideMenuManager.default.menuShadowColor = UIColor.black
    }
    
    //MARK: -  Add pull up Timeline vc
    
    func addPullUpTimelineController(){
        if let vc = pullUpVC{
            vc.delegate = self
            vc.initialState = .contracted
            self.addPullUpController(vc, initialStickyPointOffset: vc.initialPointOffset, animated: true)
        }
    }
    
    //MARK:- Profile Controller delegates
    
    func updateHomeScreen(isDayOut: Bool, isProfileUpdated: Bool) {
        if let _ = viewDayIn{
            viewDayIn.isHidden = true
        }
        
        if let vc = self.pullUpVC{
            vc.initialState = .hidden
            vc.pullUpControllerMoveToVisiblePoint(vc.initialPointOffset, animated: true, completion: nil)
        }
        
        self.getUserProfile(isloader: false)
    }
    
    //MARK:- CheckIn Controller delegates
    
    func showTimeLineController() {
        // move up pull up timeline controller
        if let vc = self.pullUpVC{
            vc.initialState = .contracted
            vc.pullUpControllerMoveToVisiblePoint(vc.initialPointOffset, animated: true, completion: nil)
        }
        
        self.getCheckIns()
        self.getAllBuildings(text: "")
    }
    
    //MARK:- Timeline controller delagates
    
    func showCheckInConfirmation() {
        
        if let vc = self.pullUpVC{
            vc.initialState = .hidden
            vc.pullUpControllerMoveToVisiblePoint(vc.initialPointOffset, animated: true, completion: nil)
        }
        
        addAndShowCheckInConfirmation()
    }
    
    func addAndShowCheckInConfirmation(){
        
        if self.view.subviews.contains(viewConfirmCheckIn){
            UIView.animate(withDuration: 0.5, animations: {
                self.viewConfirmCheckIn.alpha = 1.0
            }) { [weak self](result) in
                self?.viewConfirmCheckIn.isHidden = false
            }
        }
        else{
            self.view.addSubview(viewConfirmCheckIn)
            viewConfirmCheckIn.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                viewConfirmCheckIn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
                viewConfirmCheckIn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                viewConfirmCheckIn.widthAnchor.constraint(equalToConstant: 328),
                viewConfirmCheckIn.heightAnchor.constraint(equalToConstant: 304)])
        }
    }
    
    //MARK:- Navigation Bar Button Action
    
    @IBAction func actionShowLeftMenu(_ sender: Any) {
        if let menu = menuLeftNavigationController{
            self.presentVC(menu)
        }
    }
    
    @IBAction func actionProfile(_ sender: Any) {
        guard let vc = R.storyboard.main.profileViewController() else{return}
        vc.delegate = self
        UIApplication.topViewController()?.presentVC(vc)
    }
    
    //MARK: - DayIn Pop-up Action
    
    @IBAction func actionDayIn(_ sender: Any) {
        self.requestDayIn()
    }
    
    //MARK: - CheckIn Pop-up Action
    
    @IBAction func actionCheckIn(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.viewConfirmCheckIn.alpha = 0.0
        }) { [weak self](result) in
            self?.viewConfirmCheckIn.isHidden = true
            guard let vc = R.storyboard.main.addCheckInViewController() else{return}
            vc.delegate = self
            let navController = UINavigationController.init(rootViewController: vc)
            navController.navigationBar.isHidden = true
            UIApplication.getTopMostViewController()?.presentVC(navController)
        }
    }
    
    @IBAction func actionCancelCheckIn(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.viewConfirmCheckIn.alpha = 0.0
        }) { [weak self](result) in
            self?.viewConfirmCheckIn.isHidden = true
            // move up pull up timeline controller
            if let vc = self?.pullUpVC{
                vc.initialState = .contracted
                vc.pullUpControllerMoveToVisiblePoint(vc.initialPointOffset, animated: true, completion: nil)
            }
        }
    }
}

//MARK: - Map View Functions And Delgates

extension HomeMapViewController: GMSMapViewDelegate{
    
    //MARK: - Add Building Markers
    
    func addBuildingMarkers(data:[Checkin_detail?]?){
        
        if !(/data?.isEmpty){
            
            data?.forEach({ (item) in
                self.infoWindow = loadNiB()
                let tempLoc = CLLocationCoordinate2D.init(latitude: /item?.source_lat?.toDouble(), longitude: /item?.source_lng?.toDouble())
                let currentMarker = GMSMarker(position: tempLoc)
                currentMarker.iconView = self.infoWindow
                currentMarker.map = self.mapView
                currentMarker.snippet = /item?.id?.toString
            })
            
        }
    }
    
    func addAllBuildingMarkers(data:[Places]?){
        
        if !(/data?.isEmpty){
            
            data?.forEach({ (item) in
                self.infoWindow = loadNiB()
                
                let buildingCategory = /item.progress_type
                var buildingImage: UIImage?
                switch buildingCategory {
                case 1:
                    buildingImage = R.image.ic_hotel_blue()
                case 2:
                    buildingImage = R.image.ic_hotel_green()
                case 3:
                    buildingImage = R.image.ic_hotel_yellow()
                case 4:
                    buildingImage = R.image.ic_hotel_pink()
                default:
                    buildingImage = R.image.ic_hotel_pink()
                }
                
                self.infoWindow.imgBuilding.image = buildingImage
                
                let tempLoc = CLLocationCoordinate2D.init(latitude: /item.source_lat?.toDouble(), longitude: /item.source_lng?.toDouble())
                let currentMarker = GMSMarker(position: tempLoc)
                currentMarker.iconView = self.infoWindow
                currentMarker.map = self.mapView
                currentMarker.snippet = /item.id?.toString
                currentMarker.zIndex = 0
            })
            
        }
    }
    
    func loadNiB() -> BuildingIconView {
        let infoWindow = BuildingIconView.instanceFromNib() as! BuildingIconView
        return infoWindow
    }
    
    //MARK: - Tap On Marker
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let vc = R.storyboard.main.buildingDetailViewController() else{return true }
        vc.checkInId = /marker.snippet?.toInt()
        UIApplication.getTopMostViewController()?.pushVC(vc)
        return true
    }
    
    func updateLastSavedLocation(){
        // update first last last saved location
        self.currentMarker?.map = nil
        
        let longlast = UserDefaults.standard.value(forKey: "lastUpdatedLong") as? Double
        let latlast = UserDefaults.standard.value(forKey: "lastUpdatedLat") as? Double
        
        if let long = longlast , let  lat = latlast {
            LatestCurrentLocationUser.location  = CLLocation.init(latitude: lat, longitude: long)
            self.mapView.animate(to: GMSCameraPosition.init(target: CLLocationCoordinate2D.init(latitude: lat, longitude: long), zoom: 12.0))
            currentMarker = GMSMarker(position:CLLocationCoordinate2D.init(latitude: lat, longitude: long))
            currentMarker?.icon = R.image.ic_m_location_pin()
            currentMarker?.map = self.mapView
        }
    }
    
    
    //MARK: - Zoom And Pin To Current Location
    
   @objc func zoomAndPinInitialCurrentLocation(){
    
      self.updateLastSavedLocation()
        
        // start Location manager
        
        LocationManager.sharedInstance.getLocation { [weak self](location, error) in
            if error == nil{
                guard let loc = location else{return}
                LatestCurrentLocationUser.location = loc
                self?.currentMarker?.map = nil
                self?.mapView.animate(to: GMSCameraPosition.init(target: loc.coordinate , zoom: 12.0))
                self?.currentMarker = GMSMarker(position: loc.coordinate)
                self?.currentMarker?.icon = R.image.ic_m_location_pin()
                self?.currentMarker?.map = self?.mapView
                self?.currentMarker?.zIndex = 1
                
//                self?.mapView.animate(toViewingAngle: 120)
//                   self?.mapView.animate(toBearing: CLLocationDirection.leastNonzeroMagnitude)
                
                if let vc = self?.pullUpVC{
                    vc.updateLocation()
                }
                
                if let vc = self?.pullUpVC{
                    vc.initialState = .contracted
                    vc.pullUpControllerMoveToVisiblePoint(vc.initialPointOffset, animated: true, completion: nil)
                }
            }
            else{
                
                self?.updateLastSavedLocation()
                if let vc = self?.pullUpVC{
                    vc.initialState = .hidden
                    vc.pullUpControllerMoveToVisiblePoint(vc.initialPointOffset, animated: true, completion: nil)
                }
                
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
    
    //MARK: - Get DropDown Building  Attributes
    
    func getCheckInAttributes(){
        
        let attribResponse:ResultCallback<CheckInAttributes?,ResponseStatus> = {[weak self] result in
            
            if let _ = self{
                switch result {
                case .success(let data):
                    guard let result = data else { return }
                    if /result.success?.boolValue{
                        CommonData.arrayDropDown = data?.dropdowns
                    }
                    
                case .failure(let error):
                    UtilityFunctions.makeToast(text: error.localizedDescription, type: .error)
                }
            }
        }
        
        var token = ""
        if let val = Singleton.shared.userData?.profile?.access_token{
            token = val
        }
        
        HomeTarget.checkInAttributes(access_token: token).requestCodable(showLoader: true, response: attribResponse)
    }
}

//MARK:-  API Requests

extension HomeMapViewController{
    
    //MARK:- Request Get User Profile
    
    func getUserProfile(isloader:Bool){
        
        let profileResponse:ResultCallback<User?,ResponseStatus>  = { [weak self]result in
            switch result {
            case .success(let data):
                guard let user = data else { return }
                if (/data?.success).boolValue{
                    Singleton.shared.userData = user
                    
                    if let val = Singleton.shared.userData?.profile?.image, val != ""{
                        let userImage =  APIConstants.imageBasePath + val
                        self?.btnProfile.kf.setImage(with: URL.init(string: userImage), for: .normal, placeholder: R.image.user(), options: nil, progressBlock: nil, completionHandler: nil)
                    }
                    
                    let _ = (/Singleton.shared.userData?.profile?.is_day_in).boolValue ? (self?.alreadyDayInSetup()) : (self?.freshDaySetup())
                }
                else{
                    UtilityFunctions.makeToast(text: /data?.msg, type: .error)
                }
            case .failure(let error):
                UtilityFunctions.makeToast(text: error.localizedDescription, type: .error)
            }
        }
        
        HomeTarget.getUserProfile(access_token: /Singleton.shared.userData?.profile?.access_token).requestCodable(showLoader: isloader, response: profileResponse)
    }
    
    //MARK:- Request Day In
    
    func requestDayIn() {
        
        guard let dayInLoc =  LatestCurrentLocationUser.location else {
            UtilityFunctions.makeToast(text: R.string.localizable.popNoLocation(), type: .error)
            return
        }
        
        let dayInResponse:ResultCallback<User?,ResponseStatus>  = { result in
            switch result {
            case .success(let data):
                
                guard let _ = data else { return }
                if (/data?.success).boolValue{
                    self.getUserProfile(isloader: false)

                    UIView.animate(withDuration: 0.5, animations: {
                        self.viewDayIn.alpha = 0.0
                    }) { [weak self](result) in
                        self?.viewDayIn.removeFromSuperview()
  
                    }
                }
                else{
                    UtilityFunctions.makeToast(text: /data?.msg, type: .error)
                }
            case .failure(let error):
                UtilityFunctions.makeToast(text: error.localizedDescription, type: .error)
                return
            }
        }
        
        var token = ""
        if let val = Singleton.shared.userData?.profile?.access_token{
            token = val
        }
        
        LocationManager.sharedInstance.getReverseGeoCodedLocation(location: dayInLoc) { (location, placemark, error) in
            
            let text = String(format:"%@ %@ %@ %@ %@ %@",
                              placemark?.subThoroughfare ?? "" ,
                              placemark?.thoroughfare ?? "",
                              placemark?.locality ?? "" ,
                              placemark?.postalCode ?? "",
                              placemark?.administrativeArea ?? "" ,
                              placemark?.country ?? "")
            
            HomeTarget.userDayIn(start_lat: "\(/LatestCurrentLocationUser.location?.coordinate.latitude)", start_lng: "\(/LatestCurrentLocationUser.location?.coordinate.longitude)", Start_address: text, Access_token: token).requestCodable(showLoader: true, response: dayInResponse)
        }
    }
    
    //MARK:- Request Get Current CheckIns
    
    func getCheckIns(){
        
        let checkInsResponse:ResultCallback<CheckIns?,ResponseStatus>  = { result in
            switch result {
            case .success(let data):
                
                guard let _ = data else { return }
                if (/data?.success).boolValue{
                    
                    CommonData.arrayCheckIns = data?.checkindata?.checkin_detail
//                    self.addBuildingMarkers(data: data?.checkindata?.checkin_detail)
                    if let vc = self.pullUpVC{
                        vc.arrCheckIns = data?.checkindata?.checkin_detail?.reversed() ?? []
                    }
                }
                else{
                    UtilityFunctions.makeToast(text: /data?.msg, type: .error)
                }
            case .failure( _):
                return
            }
        }
        
        let strToday = Date().toString(format: "YYYY-MM-dd")
        HomeTarget.getCheckIns(date: strToday).requestCodable(showLoader: false, response: checkInsResponse)
    }
    
    func getAllBuildings(text :String?){
        let searchResponse:ResultCallback<SearchPlace?,ResponseStatus> = {[weak self] result in
            switch result {
            case .success(let data):
                
                guard let data = data else { return }
                if (/data.success).boolValue{
                    self?.arrPlaces = data.places
                    self?.addAllBuildingMarkers(data: self?.arrPlaces)
                }
                else{
                    print("no result")
                }
            case .failure( _):
                return
            }
        }
        
        HomeTarget.searchBuilding(search: /text).requestCodable(showLoader: false, response: searchResponse)
    }
}
