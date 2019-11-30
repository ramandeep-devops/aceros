//
//  AddCheckInViewController.swift
//  Aceros
//
//  Created by Apple on 17/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import GooglePlaces
import ActionSheetPicker_3_0
import IBAnimatable

protocol AddCheckInViewControllerDelegate:AnyObject {
    func showTimeLineController()
}

enum dropDownType {
    case status
    case progress
    case persons
    case buildings
    case sales
}

class AddCheckInViewController: UIViewController,addCompanyVcDelegate,SearchBuildingViewControllerDelegate,CheckInPlacePickerViewControllerDelegate{
    
    // MARK: - Outlets
    
    @IBOutlet weak var btnSwitchBuildingType: UISwitch!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollectionConstraint: NSLayoutConstraint!
    @IBOutlet weak var tfCheckInLocation: UITextField!
    @IBOutlet weak var tfBuildingType: UITextField!
    @IBOutlet weak var tfBuildingProgress: UITextField!
    @IBOutlet weak var tfPossibleSales: UITextField!
    @IBOutlet weak var tfNameOfBuilding: UITextField!
    @IBOutlet weak var TfTelePhone: UITextField!
    @IBOutlet weak var tfStatus: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightScrollContentView: NSLayoutConstraint! // initially 1200
    @IBOutlet weak var btnChangeOld: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var tvDesc: AnimatableTextView!
    @IBOutlet weak var tvNotes: AnimatableTextView!
    @IBOutlet weak var tfTelephoneValue: UITextField!
    
    // MARK: - Properties
    
    var arrBuildingPhotos:[UIImage?] = []{
        didSet{
            if (arrBuildingPhotos.count + arrOldBuildingPhotos.count) > 3{
                heightCollectionConstraint.constant = cellSize + cellSize
                heightScrollContentView.constant += cellSize
            }
            else{
                heightCollectionConstraint.constant = cellSize
            }
            collectionView.reloadData()
        }
    }
    
    var arrOldBuildingPhotos:[String?] = []{
        didSet{
            if (arrBuildingPhotos.count + arrOldBuildingPhotos.count) > 3{
                heightCollectionConstraint.constant = cellSize + cellSize
                heightScrollContentView.constant += cellSize
            }
            else{
                heightCollectionConstraint.constant = cellSize
            }
            collectionView.reloadData()
        }
    }
    
    var arrOldBuildingIds = [String]()
    
    private var dataSource: TableViewDataSource? {
        didSet{
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
        }
    }
    
    var arrCompany = [[String:String]]()
    var cellSize:CGFloat = 0.0
    var delegate:AddCheckInViewControllerDelegate?
    var placesClient: GMSPlacesClient!
    var arrayDropDown : Dropdowns?
    var currentDropDown:dropDownType = .status
    var dictDropDown = [String:String]()
    var checkInCoordinate: CLLocationCoordinate2D?
    var objCompany = [AnyObject](){
        didSet{
            if !objCompany.isEmpty{
                heightScrollContentView.constant += (objCompany.count.toCGFloat * 100.toCGFloat)
            }
        }
    }
    
    var isOldBuildings = false
    var oldBuilding : Places?
    var checkInData : CheckIns?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
    }
    // MARK: - View Setup
    
    func viewSetup(){
        
        self.arrayDropDown  = CommonData.arrayDropDown
        self.setDefaultPickerValues()
        
        //Get checkin drop down data
        self.getCheckInAttributes()
        
        placesClient = GMSPlacesClient.shared()
        
        let height = self.collectionView.frame.width/3 - 20
        heightCollectionConstraint.constant = height
        cellSize = height
        if let img = R.image.ic_cross_img(){
            arrBuildingPhotos.append(img)
        }
        
        self.updateLocation()
    }
    
    func updateLocation(){
        
        LocationManager.sharedInstance.getLocation { [weak self](location, error) in
            if error == nil{
                guard let loc = location else{return}
                LatestCurrentLocationUser.location = loc
                 self?.checkInCoordinate = loc.coordinate
                self?.getAddress()
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
    
    func getAddress(){
        guard let dayInLoc =  LatestCurrentLocationUser.location else {
            return
        }
        
        LocationManager.sharedInstance.getReverseGeoCodedLocation(location: dayInLoc) { [weak self](location, placemark, error) in
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
            
//            self?.tfCheckInLocation.text  = addresstext
            self?.lblAddress.text = addresstext
        }
    }
    
    //MARK: - Reset View For Old Building
    
    func resetOldBuildingAttributes(){
        self.view.endEditing(true)
        
        let status = self.arrayDropDown?.status?.filter{$0.id == oldBuilding?.status_type}
        self.tfStatus.text = status?.first?.sname
        self.dictDropDown["status"] = status?.first?.id?.toString
        
        let person = self.arrayDropDown?.persons?.filter{$0.id == oldBuilding?.contact_person?.toInt()}
        self.TfTelePhone.text = person?.first?.prs_name
        self.dictDropDown["contact"] = person?.first?.id?.toString
        
        let building_type  = self.arrayDropDown?.buildings?.filter{$0.id == oldBuilding?.building_type}
        self.tfBuildingType.text = building_type?.first?.bname
        self.dictDropDown["building"] = building_type?.first?.id?.toString

        
        let progress  = self.arrayDropDown?.progess?.filter{$0.id == oldBuilding?.progress_type}
        self.tfBuildingProgress.text = progress?.first?.prgs_name
        self.dictDropDown["progress"] = progress?.first?.id?.toString

        
        let sales  = self.arrayDropDown?.sales?.filter{$0.id == oldBuilding?.sale_type}
        self.tfPossibleSales.text = sales?.first?.sale_name
        self.dictDropDown["sales"] = sales?.first?.id?.toString
        
        self.lblAddress.text = /oldBuilding?.location
        self.tfNameOfBuilding.text = /oldBuilding?.building_name
        self.tfTelephoneValue.text = /oldBuilding?.contact_detail
        tvNotes.text = /oldBuilding?.notes
        tvDesc.text = /oldBuilding?.description
        
        self.checkInCoordinate = CLLocationCoordinate2D.init(latitude: /Double(/oldBuilding?.source_lat) , longitude: /Double(/oldBuilding?.source_lng))
        self.getBuildingDetail()
    }
    
    // MARK: - Button Action
    
    @IBAction func actionDismissController(_ sender: Any) {
        delegate?.showTimeLineController()
        UIApplication.getTopMostViewController()?.dismiss(animated: true)
    }
    
    @IBAction func actionDoneCheckIn(_ sender: Any) {
        
        if !isOldBuildings{
            if arrBuildingPhotos.count > 1 {
                
                if !(/lblAddress.text?.isEmpty) && tfNameOfBuilding.hasText && tfTelephoneValue.hasText && tvNotes.hasText && tvDesc.hasText{
                    self.addCheckIn()
                }
                else{
                    UtilityFunctions.makeToast(text: R.string.localizable.popFieldsNecessary(), type: .error)
                }
            }
            else{
                UtilityFunctions.makeToast(text: R.string.localizable.popAddPhoto(), type: .error)
            }
        }
        
        else{
            
            if arrOldBuildingPhotos.count >= 1 || arrBuildingPhotos.count > 1 {
                
                if !(/lblAddress.text?.isEmpty) && tfNameOfBuilding.hasText && tfTelephoneValue.hasText && tvNotes.hasText && tvDesc.hasText{
                    self.updateCheckIn()
                }
                else{
                    UtilityFunctions.makeToast(text: R.string.localizable.popFieldsNecessary(), type: .error)
                }
            }
            else{
                UtilityFunctions.makeToast(text: R.string.localizable.popAddPhoto(), type: .error)
            }
        }
    }
    
    @IBAction func actionSwitchBuildingType(_ sender: UISwitch) {
        
        if !sender.isOn{
            guard let vc = R.storyboard.main.searchBuildingViewController() else{return}
            vc.delegate = self
            UIApplication.topViewController()?.presentVC(vc)
        }
        else{
            self.getCheckInAttributes()
            self.lblAddress.text = ""
            self.tfNameOfBuilding.text = ""
            self.tfTelephoneValue.text = ""
            self.tvDesc.text = ""
            self.tvNotes.text = ""
            self.isOldBuildings = false
            self.collectionView.reloadData()
            self.btnChangeOld.isHidden = true
            self.objCompany = []
            self.setupTableView()
        }
    }
    
    @IBAction func actionSearchOld(_ sender: Any) {
        guard let vc = R.storyboard.main.searchBuildingViewController() else{return}
        vc.delegate = self
        UIApplication.topViewController()?.presentVC(vc)
    }
    
    @objc func dismissAlertController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionAddCompany(_ sender: Any) {
        
        UtilityFunctions.showAlertCustom(nativeActionSheet: "Is this a new client?", subTitle: nil, vc: self, senders: ["Yes, new client","No, old client"]) { (_, indx) in
            
            switch indx{
            case 0:
                
//                guard let vc = R.storyboard.leftPanel.addClientViewController() else{return}
//                vc.isCheckIn = true
//                vc.checkInLocation = CLLocation.init(latitude: /self.checkInCoordinate?.latitude, longitude: /self.checkInCoordinate?.longitude)
//                vc.checkInAddress = self.lblAddress.text
//                UIApplication.topViewController()?.pushVC(vc)
                
                
                guard let vc = R.storyboard.main.addCompanyViewController() else{return}
                vc.address = /self.lblAddress.text
                vc.lati = "\(/self.checkInCoordinate?.latitude)"
                vc.lng = "\(/self.checkInCoordinate?.longitude)"
                vc.delegate = self
                UIApplication.topViewController()?.presentVC(vc)
                
            case 1:
                guard let vc = R.storyboard.leftPanel.clientsListViewController() else{return}
                vc.isFromCheckIn = true
                UIApplication.topViewController()?.pushVC(vc)
                
            default:
                print("efe")
                
            }
           
        }
       
    }
    
    @IBAction func actionTapOnCurrentLocationIcon(_ sender: Any) {
        self.updateLocation()
    }
    
    //MARK: - AddCompany delegate
    func addCompany(dic: [String : String]) {
        objCompany.append(dic as AnyObject)
        self.setupTableView()
    }
    
    //MARK: - Search Building delegate

    func selectedBuilding(isSelected: Bool, building: Places?) {
        if !isSelected{
            btnSwitchBuildingType.isOn = true
            self.isOldBuildings = false
            self.btnChangeOld.isHidden = true
        }
        else{
            self.isOldBuildings = true
            self.btnChangeOld.isHidden = false
            self.oldBuilding = building
            self.arrOldBuildingIds = []
            self.arrOldBuildingPhotos = []
            self.resetOldBuildingAttributes()
        }
    }
    
    // MARK: - Setup TableView
    fileprivate func setupTableView() {
        tableView.register(UINib(nibName: TableCellID.CompanyAddedTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: TableCellID.CompanyAddedTableViewCell.rawValue)
        tableView.tableFooterView = UIView()
        
        dataSource = TableViewDataSource(items: objCompany , height: UITableView.automaticDimension, tableView: tableView , cellIdentifier: TableCellID(rawValue: TableCellID.CompanyAddedTableViewCell.rawValue), isFromType : false)
        
        dataSource?.configureCellBlock = { [weak self]( cell , item , indexPath) in
            guard let cell = cell as? CompanyAddedTableViewCell else {return}
            
            let obj = self?.objCompany[indexPath.row]
            cell.lblCompanyName.text = obj?["name"] as? String
            cell.clientEmail.text = obj?["phone"] as? String
            cell.clientPhone.text = obj?["email"] as? String
        }
        
        //        dataSource?.aRowSelectedListener = { [weak self] indexPath in
        //            guard let self = self else { return }
        //        }
        
        tableView.reloadData()
    }
}

extension AddCheckInViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,AddPhotosCollectionViewCellDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = isOldBuildings ? (arrBuildingPhotos.count + arrOldBuildingPhotos.count) : arrBuildingPhotos.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cellCollection =  UICollectionViewCell()
        if indexPath.row == 0{
            let cell:AddPhotosCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: TableCellID.AddPhotosCollectionViewCellAdd.rawValue, for: indexPath) as! AddPhotosCollectionViewCell
            cellCollection = cell
        }
        else{
            let cell:AddPhotosCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: TableCellID.AddPhotosCollectionViewCell.rawValue, for: indexPath) as! AddPhotosCollectionViewCell
            if isOldBuildings{
                
                if indexPath.row <= /arrOldBuildingPhotos.count{
                    let userImage =  APIConstants.imageBasePath + /arrOldBuildingPhotos[indexPath.row - 1]
                    cell.imgView.kf.setImage(with: URL.init(string: userImage), placeholder: R.image.ic_logo(), options:nil, progressBlock: nil, completionHandler: nil)
                  
                }
                else{
                    if let img = arrBuildingPhotos[indexPath.row - /arrOldBuildingPhotos.count]{
                        cell.imgView.image = img
                    }
                }
            }
            else{
                if let img = arrBuildingPhotos[indexPath.row]{
                    cell.imgView.image = img
                }
            }
           
            cell.btnRemove.tag = indexPath.row
            cell.delegate = self
            cellCollection = cell
        }
        return cellCollection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0   {
            if  (arrBuildingPhotos.count + arrOldBuildingPhotos.count) < 6{
                self.openPhotoGallery()
                AttachmentHandler.shared.imagePickedBlock = { [weak self] item in
                    self?.arrBuildingPhotos.append(item.self)
                    if (/self?.arrBuildingPhotos.count + /self?.arrOldBuildingPhotos.count) == 6{
                        UtilityFunctions.makeToast(text: R.string.localizable.popImageLimit(), type: .warning)
                    }
                }
            }
            else{
                UtilityFunctions.makeToast(text: R.string.localizable.popImageLimit(), type: .warning)
            }
        }
    }
    
    func removePhoto(position: Int) {
        if isOldBuildings{
            self.arrOldBuildingPhotos.remove(at: position - 1)
            self.arrOldBuildingIds.remove(at: position - 1)
        }
        else{
            self.arrBuildingPhotos.remove(at: position)
        }
    }
    
    func openPhotoGallery(){
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
    }
}

extension AddCheckInViewController:UITextFieldDelegate{
    
    func googleplaceClientList(){
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                let _ = placeLikelihoodList.likelihoods.first?.place
            }
        })
    }
    
    func CheckInPlaceAndCoordinateSelected(address: String, coordinates: CLLocationCoordinate2D) {
//         self.tfCheckInLocation.text = address
        self.lblAddress.text = address
        self.checkInCoordinate = coordinates
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if tfCheckInLocation.isFirstResponder{
            guard let vc = R.storyboard.main.checkInPlacePickerViewController() else{return}
            vc.delegate = self
            UIApplication.topViewController()?.presentVC(vc)
        }
        
        if tfStatus.isFirstResponder{
            currentDropDown = .status
            self.openActionSheetWithDataSource()
        }
        if tfBuildingType.isFirstResponder{
            currentDropDown = .buildings
            self.openActionSheetWithDataSource()
        }
        if tfBuildingProgress.isFirstResponder{
            currentDropDown = .progress
            self.openActionSheetWithDataSource()
        }
        if TfTelePhone.isFirstResponder{
            currentDropDown = .persons
            self.openActionSheetWithDataSource()
        }
        if tfPossibleSales.isFirstResponder{
            currentDropDown = .sales
            self.openActionSheetWithDataSource()

        }
        
        textField.resignFirstResponder()
    }
}

//MARK: API Requests

extension AddCheckInViewController{
    
    //MARK: - Add CheckIn

    func addCheckIn(){
        
        let checkInResponse:ResultCallback<User?,ResponseStatus>  = {[weak self] result in
            switch result {
            case .success(let data):
                
                guard let _ = data else { return }
                UtilityFunctions.makeToast(text:R.string.localizable.popCheckInSuccess(), type: .success)
                self?.delegate?.showTimeLineController()
                UIApplication.getTopMostViewController()?.dismiss(animated: true)
                
            case .failure(let error):
                UtilityFunctions.makeToast(text: error.localizedDescription, type: .error)
            }
        }
     
        
        // remove first dummy image of collectionview
        var arrImg = self.arrBuildingPhotos
        arrImg.remove(at: 0)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: objCompany, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        
        HomeTarget.checkIn(notes:tvNotes.text,description:tvDesc.text,client_detail:/jsonString,contact_detail:/tfTelephoneValue.text,source_lat: "\(/checkInCoordinate?.latitude)", source_lng: "\(/checkInCoordinate?.longitude)", location: /lblAddress.text, building_type: "\(/self.dictDropDown["building"])", status_type: "\(/self.dictDropDown["status"])", progress_type: "\(/self.dictDropDown["progress"])", sale_type: "\(/self.dictDropDown["sales"])", company_detail: /jsonString, contact_person: "\(/self.dictDropDown["contact"])", building_name: /tfNameOfBuilding.text, user_id: /Singleton.shared.userData?.profile?.id?.toString, access_token: Singleton.shared.userData?.profile?.access_token, building_images: arrImg).requestCodable(showLoader: true, response: checkInResponse)
    }
    
    //MARK: - Add CheckIn
    
    func updateCheckIn(){
        
        let checkInResponse:ResultCallback<User?,ResponseStatus>  = {[weak self] result in
            switch result {
            case .success(let data):
                
                guard let _ = data else { return }
                UtilityFunctions.makeToast(text:R.string.localizable.popCheckInSuccess(), type: .success)
                self?.delegate?.showTimeLineController()
                UIApplication.getTopMostViewController()?.dismiss(animated: true)
                
            case .failure(let error):
                UtilityFunctions.makeToast(text: error.localizedDescription, type: .error)
            }
        }
        
        var token = ""
        if let val = Singleton.shared.userData?.profile?.access_token{
            token = val
        }
        
        var id = ""
        if let val = Singleton.shared.userData?.profile?.id{
            id = val.toString
        }
        
        // remove first dummy image of collectionview
        var arrImg = self.arrBuildingPhotos
        arrImg.remove(at: 0)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: objCompany, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        
       let deletedIds =  arrOldBuildingIds.joined(separator: ",")
        
        HomeTarget.updateBuilding(building_id: /self.checkInData?.checkindata?.checkin?.id?.toString ,source_lat: "\(/checkInCoordinate?.latitude)", source_lng: "\(/checkInCoordinate?.longitude)", location: /lblAddress.text, building_type: "\(/self.dictDropDown["building"])", status_type: "\(/self.dictDropDown["status"])", progress_type: "\(/self.dictDropDown["progress"])", sale_type: "\(/self.dictDropDown["sales"])", company_detail: /jsonString, contact_person: "\(/self.dictDropDown["contact"])", building_name: /tfNameOfBuilding.text, user_id: id, access_token: token, building_images: arrImg, deletedImageIds: deletedIds).requestCodable(showLoader: true, response: checkInResponse)
    }

    
    func getBuildingDetail(){
        
            let checkInResponse:ResultCallback<CheckIns?,ResponseStatus> = {[weak self]result in
                guard let self = self else {
                    return
                }
                switch result {
                    
                case .success(let data):
                    guard let _ = data else{return}
                    self.checkInData = data
                    
                    self.checkInData?.checkindata?.checkin_images?.forEach({ (item) in
                        self.arrOldBuildingPhotos.append(/item.media_url)
                        self.arrOldBuildingIds.append(/item.id?.toString)
                    })
                    
                    let obj = self.checkInData?.checkindata?.checkin
                    let cmpnyString =  /obj?.company_detail
                    let cmpnyData = cmpnyString.data(using: .utf8)!
                    
                    do {
                        let companies = try JSONSerialization.jsonObject(with: cmpnyData, options: .allowFragments)
                        if let arrCmpny = companies as? Array<[String:String]> {
                            self.arrCompany = arrCmpny
                            
                            for item in self.arrCompany{
                                self.objCompany.append(item as AnyObject)
                            }
                            self.setupTableView()
                        }
                    }
                    catch{
                        UtilityFunctions.makeToast(text: "Unable to list companies.", type: .error)
                    }
                    
                case .failure(let error):
                    UtilityFunctions.makeToast(text: error.localizedDescription, type: .error)

                }
            }
            
            HomeTarget.getCheckInDetails(id: oldBuilding?.id).requestCodable(showLoader: true, response: checkInResponse)
    }
    
    //MARK: - Get DropDown Building  Attributes
    
    func getCheckInAttributes(){

        let attribResponse:ResultCallback<CheckInAttributes?,ResponseStatus> = {[weak self] result in
            
            if let self = self{
                switch result {
                case .success(let data):
                    guard let result = data else { return }
                    if /result.success?.boolValue{
                        self.arrayDropDown = result.dropdowns
                        CommonData.arrayDropDown = result.dropdowns
                        self.setDefaultPickerValues()
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
    
    func setDefaultPickerValues(){
        self.tfStatus.text = self.arrayDropDown?.status?.first?.sname
        self.TfTelePhone.text = self.arrayDropDown?.persons?.first?.prs_name
        self.tfBuildingType.text = self.arrayDropDown?.buildings?.first?.bname
        self.tfBuildingProgress.text = self.arrayDropDown?.progess?.first?.prgs_name
        self.tfPossibleSales.text = self.arrayDropDown?.sales?.first?.sale_name
        
        self.dictDropDown["status"] = self.arrayDropDown?.status?.first?.id?.toString
        self.dictDropDown["contact"] = self.arrayDropDown?.persons?.first?.id?.toString
        self.dictDropDown["building"] = self.arrayDropDown?.buildings?.first?.id?.toString
        self.dictDropDown["progress"] = self.arrayDropDown?.progess?.first?.id?.toString
        self.dictDropDown["sales"] = self.arrayDropDown?.sales?.first?.id?.toString
    }
    
    
    //MARK: - Open  picker with datasource
    
    func openActionSheetWithDataSource(){
        var  arr = [String]()
        self.view.endEditing(true)
        
        switch currentDropDown {
        case .status:
            arr = arrayDropDown?.status?.compactMap{$0.sname} ?? []
            
        case .buildings:
            arr = arrayDropDown?.buildings?.compactMap{$0.bname} ?? []
            
        case .persons:
            arr = arrayDropDown?.persons?.compactMap{$0.prs_name} ?? []
            
        case .progress:
            arr = arrayDropDown?.progess?.compactMap{$0.prgs_name} ?? []
            
        case .sales:
            arr = arrayDropDown?.sales?.compactMap{$0.sale_name} ?? []
        }
        
        ActionSheetStringPicker.show(withTitle: /title, rows:arr , initialSelection: 0, doneBlock: { (picker, indx, value) in
            
            self.view.resignFirstResponder()

            switch self.currentDropDown {
            case .status:
                self.tfStatus.text = value as? String
                self.dictDropDown["status"] = self.arrayDropDown?.status?[indx].id?.toString
                self.tfStatus.resignFirstResponder()
            case .buildings:
                self.tfBuildingType.text = value as? String
                self.dictDropDown["building"] = self.arrayDropDown?.buildings?[indx].id?.toString
                self.tfBuildingType.resignFirstResponder()
                
            case .persons:
                self.TfTelePhone.text = value as? String
                self.dictDropDown["contact"] = self.arrayDropDown?.persons?[indx].id?.toString
                self.TfTelePhone.resignFirstResponder()
                
            case .progress:
                self.tfBuildingProgress.text = value as? String
                self.dictDropDown["progress"] = self.arrayDropDown?.progess?[indx].id?.toString
                self.tfBuildingProgress.resignFirstResponder()
                
            case .sales:
                self.tfPossibleSales.text = value as? String
                self.dictDropDown["sales"] = self.arrayDropDown?.sales?[indx].id?.toString
                self.tfPossibleSales.resignFirstResponder()
            }
        }, cancel: { (picker) in
            self.view.resignFirstResponder()
            self.view.endEditing(true)
        }, origin: tfStatus)
    }
}

