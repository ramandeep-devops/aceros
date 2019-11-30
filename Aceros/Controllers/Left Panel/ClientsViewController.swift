//
//  ClientsViewController.swift
//  Aceros
//
//  Created by Apple on 25/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import GoogleMaps

struct markerInfo {
    var id  = ""
}

class ClientsViewController: UIViewController, AddClientViewControllerDelegate , ClientDetailViewControllerDelegate{
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: GMSMapView!
    
    private var infoWindow = BuildingIconView()
    var currentMarker:GMSMarker?
    var clientMarker:GMSMarker?
    var arrClients = [Checkdayin]()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
        self.getClientList()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    
    // MARK: - Custom Methods
    
    func viewSetup(){
        zoomAndPinInitialCurrentLocation()
        self.mapView.delegate = self
    }
    
    func reloadClients() {
        self.mapView.clear()
        self.getClientList()
    }
    
    // MARK: - Action
    
    @IBAction func actionBack(_ sender: Any) {
        UIApplication.topViewController()?.popVC()
    }
    
    @IBAction func actionAddClient(_ sender: Any) {
        guard let vc = R.storyboard.leftPanel.addClientViewController() else {return}
        vc.delegate = self
        UIApplication.topViewController()?.pushVC(vc)
    }
    
    @IBAction func actionListView(_ sender: Any) {
        guard let vc = R.storyboard.leftPanel.clientsListViewController() else {return}
        vc.arrClients = self.arrClients
        UIApplication.topViewController()?.pushVC(vc)
    }
    
    //MARK: - Map View Functions
    func zoomAndPinInitialCurrentLocation(){
        
        // update first last last saved location
        let longlast = UserDefaults.standard.value(forKey: "lastUpdatedLong") as? Double
        let latlast = UserDefaults.standard.value(forKey: "lastUpdatedLat") as? Double
        
        if let long = longlast , let  lat = latlast {
            LatestCurrentLocationUser.location  = CLLocation.init(latitude: lat, longitude: long)
            self.mapView.animate(to: GMSCameraPosition.init(target: CLLocationCoordinate2D.init(latitude: lat, longitude: long), zoom: 12.0))
            currentMarker = GMSMarker(position:CLLocationCoordinate2D.init(latitude: lat, longitude: long))
            currentMarker?.icon = R.image.ic_m_location_pin()
            currentMarker?.map = self.mapView
        }
        
        // start Location manger
        LocationManager.sharedInstance.getLocation { [weak self](location, error) in
            if error == nil{
                guard let loc = location else{return}
                self?.currentMarker?.map = nil
                LatestCurrentLocationUser.location = loc
                self?.mapView.animate(to: GMSCameraPosition.init(target: loc.coordinate , zoom: 12.0))
                self?.currentMarker = GMSMarker(position: loc.coordinate)
                self?.currentMarker?.icon = R.image.ic_m_location_pin()
                self?.currentMarker?.map = self?.mapView
                self?.currentMarker?.zIndex = 1
                
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
}


//MARK: - Map View Functions And Delgates

extension ClientsViewController: GMSMapViewDelegate{
    
    func addBuildingMarkers(){
        arrClients.forEach { (item) in
            self.infoWindow = loadNiB()
            self.infoWindow.imgBuilding.image = R.image.ic_client_mapCopy6()
            self.infoWindow.imgBuilding.contentMode  = .center
            let tempLoc = CLLocationCoordinate2D.init(latitude: /item.lati?.toDouble(), longitude: /item.lng?.toDouble())
            clientMarker = GMSMarker(position: tempLoc)
            clientMarker?.iconView = self.infoWindow
            clientMarker?.map = self.mapView
            clientMarker?.userData = markerInfo.init(id: /item.id?.toString)
        }
    }
    
    func loadNiB() -> BuildingIconView {
        let infoWindow = BuildingIconView.instanceFromNib() as! BuildingIconView
        return infoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if marker == clientMarker{
            let data = marker.userData as? markerInfo
            guard let vc = R.storyboard.leftPanel.clientDetailViewController() else { return false  }
            let item = self.arrClients.filter{$0.id == data?.id.toInt()}
            vc.data =  item.first
            vc.delegate = self
            UIApplication.topViewController()?.pushVC(vc)
        }
        
        return true
    }
}

//MARK: - APi Requests
extension ClientsViewController{
    
    func getClientList(){
        
        let clientResp:ResultCallback<ClientList?,ResponseStatus> = {[weak self] result in
            
            switch result {
            case .success(let data):
                guard let data = data else{return}
                if let arr = data.client_list?.checkdayin{
                    self?.arrClients = arr
                }
                self?.addBuildingMarkers()
                
            case .failure(let error):
                UtilityFunctions.makeToast(text: error.localizedDescription, type: .error)
            }
        }
        HomeTarget.listClient().requestCodable(showLoader: true, response: clientResp)
    }
    
    
    func updateClients() {
        self.mapView.clear()
        self.zoomAndPinInitialCurrentLocation()
        self.getClientList()
    }
}
