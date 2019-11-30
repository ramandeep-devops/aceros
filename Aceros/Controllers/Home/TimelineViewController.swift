
//
//  TimelineViewController.swift
//  Aceros
//
//  Created by Apple on 16/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import PullUpController
import IBAnimatable

protocol TimelineViewControllerDelegate: AnyObject {
    func showCheckInConfirmation()
}

class TimelineViewController: PullUpController,TimelineCellDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    //Header View
    @IBOutlet weak var tableHeaderViewTop: UIView!
    
    //MARK:- Variables
    
    enum InitialState {
        case hidden
        case contracted
        case expanded
    }
    
    var initialPointOffset: CGFloat {
        switch initialState {
        case .hidden :
            return 0.0
        case .contracted:
            return 250.0
        case .expanded:
            return pullUpControllerPreferredSize.height
        }
    }
    
    private var dataSource: TableViewDataSource? {
        didSet{
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
        }
    }
    var delegate:TimelineViewControllerDelegate?
    var initialState: InitialState = .contracted
    public var portraitSize: CGSize = .zero
    
    
    var arrCheckIns :[Checkin_detail?] = []{
        didSet{
            
            let decoder = JSONDecoder()
            let firstItem = try! decoder.decode(Checkin_detail.self, from: Data("""
{"id": 1}
""".utf8))
            self.arrCheckIns.insert(firstItem, at: 0)
            self.arrCheckIns.insert(firstItem, at: self.arrCheckIns.count )
            dataSource?.items = arrCheckIns as Array<Any>
            guard let table = tableView else {return}
            
            table.reloadData()
        }
    }
    let arrIcon  = [R.image.ic_history_side_m(), R.image.ic_clients_side_m()]
    var viewTop : UIView?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
    }
    
    //MARK:- Custom Methods
    func viewSetup(){
        portraitSize = CGSize(width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height),
                              height: UIScreen.main.bounds.height -  (UIScreen.main.bounds.height/4))
        self.setupTableView()
        tableView.attach(to: self)
        viewTop = tableHeaderViewTop
        self.updateLocation()
    }
    
    func updateLocation(){
        
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
            
            LatestCurrentLocationUser.address = addresstext
            if let table = self?.tableView{
                table.reloadData()
            }
        }
    }
    
    // MARK: - Setup TableView
    fileprivate func setupTableView() {
        tableView.register(UINib(nibName: TableCellID.TimelineTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: TableCellID.SettingsTableViewCell.rawValue)
        tableView.tableFooterView = UIView()
        
        dataSource = TableViewDataSource(items: arrCheckIns as Array<Any> , height: UITableView.automaticDimension, tableView: tableView , cellIdentifier: TableCellID(rawValue: TableCellID.TimelineTableViewCell.rawValue), isFromType : false)
        
        dataSource?.configureCellBlock = { [weak self]( cell , item , indexPath) in
            guard let cell = cell as? TimelineTableViewCell else {return}

            cell.btnCheckIn.tag = indexPath.row
            cell.delegate = self
            cell.viewSeparator.isHidden = false
            
            // Top cell
            if indexPath.row == 0 {
                cell.btnCheckIn.setTitleColor(UIColor.white, for: .normal)
                cell.btnCheckIn.layer.borderWidth = 0.0
                cell.btnCheckIn.backgroundColor = UIColor(red:0.13, green:0.81, blue:0.17, alpha:1)
                cell.btnCheckIn.layer.borderColor = UIColor(red:0.13, green:0.81, blue:0.17, alpha:1).cgColor
                cell.imgCheck.image = R.image.ic_check_point_green()
                cell.btnCheckIn.setTitle("Check in", for: .normal)
                cell.lblAddress.text =  LatestCurrentLocationUser.address
                cell.lblTime.text = Date().toString(format: "h:mm a")
                cell.lblTitle.text = R.string.localizable.profileYouAreAt()
                cell.heightBtnDetail.constant = 40.0
                
                            if   self?.initialState == .expanded{
                                cell.bottomHeight.constant  = 30.0
                                UIView.animate(withDuration: 0.5) {
                                    self?.view.layoutIfNeeded()
                                }
                            }
                            else{
                                cell.bottomHeight.constant  = 150.0
                               
                            }
            }
                // Last Cell (Day In)  cell
                
            else if indexPath.row == /self?.arrCheckIns.count - 1 {

                cell.lblTitle.text = R.string.localizable.profileDayIn()
                cell.heightBtnDetail.constant = 0.0
                cell.imgCheck.image = R.image.ic_check_point_blue()
                cell.lblTime.text = Singleton.shared.userData?.profile?.dayin_timing?.toDate(withFormat: "yyyy-MM-dd HH:mm:ss")?.getTimeOnly()
                cell.lblAddress.text = ""
                cell.viewSeparator.isHidden = true
            }
            else {
                let obj = self?.arrCheckIns[indexPath.row]
                cell.lblAddress.text = /obj?.location
                cell.lblTitle.text = R.string.localizable.profileCheckedIn()
                cell.btnCheckIn.setTitleColor(AppColor.themeColor.getColor(), for: .normal)
                cell.btnCheckIn.layer.borderWidth = 1.0
                cell.btnCheckIn.layer.borderColor =  UIColor(red:0.87, green:0.89, blue:0.92, alpha:1).cgColor
                cell.btnCheckIn.backgroundColor = UIColor.white
                cell.imgCheck.image = R.image.ic_check_point_blue()
                cell.btnCheckIn.setTitle("View details", for: .normal)
                cell.heightBtnDetail.constant = 40.0
                let date = obj?.updated_at?.toDate(withFormat: "yyyy-MM-dd HH:mm:ss")
                cell.lblTime.text = date?.getTimeOnly()

            }
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Hide TimelineView and show confirmation View
    func hideTimelineShowConfirmation(){
        initialState = .hidden
        pullUpControllerMoveToVisiblePoint(initialPointOffset, animated: true) {
            self.delegate?.showCheckInConfirmation()
        }
    }
    
    // MARK: - Timeline (Detail/CheckIn) Delegate method
    func actionCheckInOrDetail(isCheckIn: Bool, indexPath: Int) {
        let _ = isCheckIn ? hideTimelineShowConfirmation() : self.moveToCheckInDetails(id: /self.arrCheckIns[indexPath]?.id)
    }
    
    func moveToCheckInDetails(id:Int?){
        guard let vc = R.storyboard.main.buildingDetailViewController() else{return }
        vc.checkInId = id
        UIApplication.getTopMostViewController()?.pushVC(vc)
    }
    
    //MARK:- Button Action
    @IBAction func actionHeaderCheckIn(_ sender: Any) {
        hideTimelineShowConfirmation()
    }
    
    // MARK: - PullUpController
    override var pullUpControllerPreferredSize: CGSize {
        return portraitSize
    }
    
    override func pullUpControllerDidMove(to point: CGFloat) {
        if point == 250.0{
//            tableView.beginUpdates()
//            self.tableView.tableHeaderView?.alpha = 0.0
//            UIView.animate(withDuration: 0.3) {
//            self.tableView.tableHeaderView = self.tableHeaderViewTop
//                self.tableView.tableHeaderView?.alpha = 1.0
//                self.tableView.endUpdates()
//            }
            self.initialState = .contracted
            tableView.reloadData()

        }
        else{
//            tableView.beginUpdates()
//            self.tableView.tableHeaderView?.alpha = 0.0
//            UIView.animate(withDuration: 0.3) {
//                self.tableView.tableHeaderView = UIView()
//                self.tableView.tableHeaderView?.alpha = 1.0
//                self.tableView.endUpdates()
//            }
            
            self.initialState = .expanded
            //            self.dataSource?.items = self.arrCheckIns as Array<Any>
            tableView.reloadData()
        }
    }
}


