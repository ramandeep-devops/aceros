//
//  BuildingDetailViewController.swift
//  Aceros
//
//  Created by Apple on 18/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import Lightbox


class BuildingDetailViewController: UIViewController,BuildingClientsTableViewCellDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var heightScrollContent: NSLayoutConstraint!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblBuildingType: UILabel!
    @IBOutlet weak var lblNavDate: UILabel!
    
    @IBOutlet weak var lblClientHeader: UILabel!
    
    // MARK: - Variables
    private var dataSource: TableViewDataSource? {
        didSet{
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
        }
    }
    
    var checkInId:Int?
    var checkInData : CheckIns?
    private var infoWindow = BuildingIconView()
    
    var arrCompany = [[String:String]]()
    var arrImages = [String]()
    var arrLightBoxImages = [LightboxImage]()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
        self.getCheckInDetails()
    }
    
    func viewSetup(){
        self.setupTableView()
            }
    
    // MARK: - Setup TableView
    fileprivate func setupTableView() {
        tableView.register(UINib(nibName: TableCellID.BuildingClientsTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: TableCellID.BuildingClientsTableViewCell.rawValue)
        tableView.tableFooterView = UIView()
        
        dataSource = TableViewDataSource(items: arrCompany , height: UITableView.automaticDimension, tableView: tableView , cellIdentifier: TableCellID(rawValue: TableCellID.BuildingClientsTableViewCell.rawValue), isFromType : false)
        
        dataSource?.configureCellBlock = { [weak self]( cell , item , indexPath) in
            guard let cell = cell as? BuildingClientsTableViewCell else {return}
            cell.delegate = self
            cell.btnMore.tag = indexPath.row
            
            let obj = self?.arrCompany[indexPath.row]
            cell.lblDesc.text = obj?["name"]
        }
        
        //        dataSource?.aRowSelectedListener = { [weak self] indexPath in
        //            guard let self = self else { return }
        //        }
        
        tableView.isScrollEnabled = false
        self.tableView.reloadData()
    }
    
    //MARK: - Building client cell delegate
    
    func reloadRowAtIndex(index: Int) {
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableviewHeight.constant = self.tableView.contentSize.height
            self.heightScrollContent.constant =  700.0 + self.tableviewHeight.constant
        }
    }
    
    //MARK: - Update View from api data
    
    func updateView(){
        let obj = checkInData?.checkindata?.checkin
        let buildingCategory = /obj?.progress_type
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
        
        self.infoWindow = loadNiB()
        self.infoWindow.imgBuilding.image = buildingImage
        let tempLoc = CLLocationCoordinate2D.init(latitude:/obj?.source_lat?.toDouble(), longitude: /obj?.source_lng?.toDouble())
        self.mapView.animate(to: GMSCameraPosition.init(target: tempLoc, zoom: 18))
        let currentMarker = GMSMarker(position: tempLoc)
        currentMarker.iconView = self.infoWindow
        currentMarker.map = self.mapView
        
        lblAddress.text = /obj?.location
        let type = obj?.building_type
        
        let val = CommonData.arrayDropDown?.buildings?.filter{$0.id == type}
        lblBuildingType.text = /val?.first?.bname
        
        lblNavDate.text = /obj?.updated_at?.toDate()?.toString(format: "d MMM, h:mm a")
        
        let cmpnyString =  /obj?.company_detail
        let cmpnyData = cmpnyString.data(using: .utf8)!
        let msgNoClients = R.string.localizable.popNoClinetsInBuilding()
        
        do {
            let companies = try JSONSerialization.jsonObject(with: cmpnyData, options: .allowFragments)
            if let arrCmpny = companies as? Array<[String:String]> {
                if !arrCmpny.isEmpty{
                    arrCompany = arrCmpny
                    self.dataSource?.items = arrCompany
                    self.reloadRowAtIndex(index: 0)
                }
                else{
                    self.lblClientHeader.text = msgNoClients
                }
            }
            else{
                self.lblClientHeader.text = msgNoClients
            }
        }
        catch{
            self.lblClientHeader.text = msgNoClients
        }
        
        checkInData?.checkindata?.checkin_images?.forEach({ (item) in
            self.arrImages.append(/item.media_url)
            
             let buildingImage =  APIConstants.imageBasePath + "\(/item.media_url)"
            
             arrLightBoxImages.append(LightboxImage(imageURL: URL(string: buildingImage)!))
        })
        
        collectionView.reloadData()
    }
    // MARK: - Load Xib
    
    func loadNiB() -> BuildingIconView {
        let infoWindow = BuildingIconView.instanceFromNib() as! BuildingIconView
        return infoWindow
    }
    
    // MARK: - Button Action
    @IBAction func actionBack(_ sender: Any) {
        UIApplication.topViewController()?.popVC()
    }
    
    
}

// MARK: - Collection View Delegates and data source

extension BuildingDetailViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPhotosCollectionViewCellUploaded", for: indexPath) as! AddPhotosCollectionViewCell
        let userImage =  APIConstants.imageBasePath + arrImages[indexPath.row]
        cell.imgView.kf.setImage(with: URL.init(string: userImage), placeholder: R.image.ic_logo(), options:nil, progressBlock: nil, completionHandler: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Create an instance of LightboxController.
        
        let controller = LightboxController(images: arrLightBoxImages )
      
        // Use dynamic background.
        controller.dynamicBackground = true

        // Present your controller.
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - API Requests
extension BuildingDetailViewController {
    
    func getCheckInDetails(){
        
        let checkInResponse:ResultCallback<CheckIns?,ResponseStatus> = {result in
            
            switch result {
            case .success(let data):
                guard let _ = data else{return}
                self.checkInData = data
                self.updateView()
                
            case .failure(let error):
                print(error)
                
            }
        }
        
        HomeTarget.getCheckInDetails(id: self.checkInId).requestCodable(showLoader: true, response: checkInResponse)
    }
    
}
