//
//  ClientDetailViewController.swift
//  Aceros
//
//  Created by Apple on 25/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import GoogleMaps


protocol ClientDetailViewControllerDelegate {
    func updateClients()
}

class ClientDetailViewController: UIViewController , QuestionsTableViewCellDelegate{
    

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var heightScrollContentView: NSLayoutConstraint!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblBuildingType: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var tfMotiveOfVisit: UITextField!
    
    // MARK: - Variables
    private var dataSource: TableViewDataSource? {
        didSet{
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
        }
    }
    
    var cellSize:CGFloat = 0.0
    var data:Checkdayin?
    var currentMarker:GMSMarker?
    private var infoWindow = BuildingIconView()
    let arrQuest = CommonData.arrayDropDown?.questions
    var arrToSend = [[String:String]]()
    var delegate:ClientDetailViewControllerDelegate?

    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupview()
    }
    
    func setupview(){
        
        self.lblDate.text = data?.created_at?.toDate()?.toString(format: "MMM d, yyyy")
        self.lblCity.text = "Chandigarh"
        self.lblName.text = /data?.name
        self.lblAddress.text = /data?.address
        self.lblPosition.text = "iOS Developer"
        self.lblPhoneNumber.text = data?.mobile
        let obj = CommonData.arrayDropDown?.purpose?.filter{$0.id == data?.visit_motive?.toInt()}
        self.tfMotiveOfVisit.text = obj?.first?.sname
        self.tfMotiveOfVisit.isUserInteractionEnabled = false
        
        let interactionString =   /data?.interaction
        let interactionData = interactionString.data(using: .utf8)!
    

        
        do {
            let companies = try JSONSerialization.jsonObject(with: interactionData, options: .allowFragments)
            if let arrCmpny = companies as? Array<[String:String]> {
                
                arrCmpny.forEach { (dic) in
                    
                    let dict = ["question":dic["question"] ?? "", "answer":dic["answer"] ?? ""]
                    arrToSend.append(dict)
                }
                
                
            }
            
            else{
                        for item in arrQuest ?? []{
                            let dict = ["question":"\(/item.quest)", "answer":""]
                            arrToSend.append(dict)
                        }
            }
        }
        catch{
            print("error in parsing string to json")
        }
        
        print(arrToSend)
        setupTableView()
        
        self.infoWindow = loadNiB()
        self.infoWindow.imgBuilding.image = R.image.ic_client_mapCopy6()
        let tempLoc = CLLocationCoordinate2D.init(latitude: /data?.lati?.toDouble(), longitude: /data?.lng?.toDouble())
        let currentMarker = GMSMarker(position: tempLoc)
        currentMarker.iconView = self.infoWindow
        self.mapView.animate(to: GMSCameraPosition.init(target: tempLoc, zoom: 18))
        currentMarker.map = self.mapView
        
        
    }
    
    func loadNiB() -> BuildingIconView {
        let infoWindow = BuildingIconView.instanceFromNib() as! BuildingIconView
        return infoWindow
    }
    
    
    // MARK: - Setup TableView
    fileprivate func setupTableView() {
        
        heightScrollContentView.constant += (/arrQuest?.count * 140).toCGFloat
        
        tableView.register(UINib(nibName: TableCellID.QuestionsTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: TableCellID.QuestionsTableViewCell.rawValue)
        tableView.tableFooterView = UIView()
        
        dataSource = TableViewDataSource(items: arrQuest , height: UITableView.automaticDimension, tableView: tableView , cellIdentifier: TableCellID(rawValue: TableCellID.QuestionsTableViewCell.rawValue), isFromType : false)
        
        dataSource?.configureCellBlock = { [weak self]( cell , item , indexPath) in
            guard let cell = cell as? QuestionsTableViewCell else {return}
            let obj = self?.arrQuest?[indexPath.row]
            cell.tvAnswer.tag = /obj?.id
            cell.delegate = self
            cell.lblQuesName.text = "Q.\(indexPath.row + 1) " + /obj?.quest
            
            let objVal = self?.arrToSend[indexPath.row]
            cell.tvAnswer.text = objVal?["answer"]
        }
        
        tableView.reloadData()
    }

    // MARK: - Button Action
    @IBAction func actionBack(_ sender: Any) {
        UIApplication.getTopMostViewController()?.popVC()
    }
    
    @IBAction func actionSave(_ sender: Any) {
        
        let respLogging:ResultCallback<User?,ResponseStatus> = {[weak self ]result in
            
            switch result {
            case .success(let data):
                guard let _ = data else { return}
                self?.delegate?.updateClients()
                UIApplication.topViewController()?.popVC()
                
            case .failure(let error):
                UtilityFunctions.makeToast(text: error.localizedDescription, type: .error)
            }
        }
        
        HomeTarget.logInteraction(client_id: /data?.id?.toString, question: "", answer: arrToSend).requestCodable(showLoader: true, response: respLogging)
    }
    
    //MARK: Question cell delegate (updating on textview end editing)
    
    func updateAnswerObject(indx: Int, answer: String?) {
        
            let obj = arrQuest?.filter{$0.id == indx}.first
        
        let dict = ["question":"\(/obj?.quest)", "answer": /answer]
        arrToSend.insert(dict, at: indx - 1)
        arrToSend.remove(at: indx)
        
        print(arrToSend)

        
        
    }
 
}
