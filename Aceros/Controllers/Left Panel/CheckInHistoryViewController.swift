//
//  CheckInHistoryViewController.swift
//  Aceros
//
//  Created by Apple on 18/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class CheckInHistoryViewController: UIViewController, TimelineCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblHeaderTime: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblNoHistory: UILabel!
    
    private var dataSource: TableViewDataSource? {
        didSet{
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
        }
    }
    
    var dayIn: Day_in?
    
    var arrCheckIns :[Checkin_detail?] = []{
        didSet{
            
            let decoder = JSONDecoder()
            let firstItem = try! decoder.decode(Checkin_detail.self, from: Data("""
                    {"id": 1}
                    """.utf8))
            
            if  dayIn?.dayin_timing != nil  &&  dayIn?.dayin_timing != "" {
                self.arrCheckIns.insert(firstItem, at: self.arrCheckIns.count)
            }
            
            if  dayIn?.dayout_timing != nil  && dayIn?.dayout_timing != ""{
                self.arrCheckIns.insert(firstItem, at: 0 )
            }

            if arrCheckIns.isEmpty{
                guard let table = tableView else {return}
                table.isHidden = arrCheckIns.isEmpty
                lblNoHistory.isHidden = !arrCheckIns.isEmpty
            }
            else{
                dataSource?.items = arrCheckIns as Array<Any>
                guard let table = tableView else {return}
                table.reloadData()
                table.isHidden = arrCheckIns.isEmpty
                lblNoHistory.isHidden = !arrCheckIns.isEmpty
            }
      
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - View Setup
    
    func viewSetup(){
        self.setupTableView()
        self.lblNoHistory.text = R.string.localizable.historyNoHistory()
        self.lblHeaderTime.text = Date().toString(format: "d MMM yyyy")
        self.lblDay.text = R.string.localizable.titleToday()
        self.getCheckIns(strDate: Date().toString(format: "YYYY-MM-dd"))
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
            cell.isHistory = true
            
            // Top cell
            if indexPath.row == /self?.arrCheckIns.count - 1 && (self?.dayIn?.dayin_timing != "") {
                cell.lblTitle.text = R.string.localizable.profileDayIn()
                cell.heightBtnDetail.constant = 0.0
                cell.imgCheck.image = R.image.ic_check_point_blue()
                cell.lblTime.text = self?.dayIn?.dayin_timing?.toDate(withFormat: "yyyy-MM-dd HH:mm:ss")?.getTimeOnly()
                cell.lblAddress.text = ""
                cell.viewSeparator.isHidden = false
            }
                // First from bottom(Day In)  cell
                
            else if indexPath.row == 0  && (self?.dayIn?.dayout_timing != ""){
                
                cell.lblTitle.text = R.string.localizable.profileDayOut()
                cell.heightBtnDetail.constant = 0.0
                cell.imgCheck.image = R.image.ic_check_point_blue()
                cell.lblTime.text = self?.dayIn?.dayout_timing?.toDate(withFormat: "yyyy-MM-dd HH:mm:ss")?.getTimeOnly()
                cell.lblAddress.text = ""
                cell.viewSeparator.isHidden = false
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
    
    func actionCheckInOrDetail(isCheckIn: Bool, indexPath: Int) {
        
        let obj = self.arrCheckIns[indexPath]
        guard let vc = R.storyboard.main.buildingDetailViewController() else{return}
        vc.checkInId = /obj?.id
        UIApplication.getTopMostViewController()?.pushVC(vc)

    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        UIApplication.topViewController()?.popVC()
    }
    
    @IBAction func actionSelectDate(_ sender: UIButton) {
        let picker =    ActionSheetDatePicker.init(title: "Select Date", datePickerMode: .date, selectedDate: Date(), doneBlock: { (picker, date, btn) in
            
            let dater = date as? Date
            self.lblHeaderTime.text = dater?.toString(format: "d MMM yyyy")
            self.lblDay.text = dater?.toString(format: "EEEE")
            self.getCheckIns(strDate: dater?.toString(format: "YYYY-MM-dd") ?? "")
            
        }, cancel: { (_) in
            print("few")
        }, origin: sender)
        
        picker?.maximumDate = Date()
        picker?.show()
    }
}

extension CheckInHistoryViewController{
    func getCheckIns(strDate:String){
        
        let checkInsResponse:ResultCallback<CheckIns?,ResponseStatus>  = {[weak self] result in
            switch result {
            case .success(let data):
                
                guard let _ = data else { return }
                if (/data?.success).boolValue{
                    self?.dayIn = data?.checkindata?.day_in
                    self?.arrCheckIns = data?.checkindata?.checkin_detail ?? []
                }
                else{
                    UtilityFunctions.makeToast(text: /data?.msg, type: .error)
                }
            case .failure( _):
                return
            }
        }
        
        HomeTarget.getCheckIns(date: strDate).requestCodable(showLoader: true, response: checkInsResponse)
    }
}
