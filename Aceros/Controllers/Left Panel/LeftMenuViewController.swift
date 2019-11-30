//
//  LeftMenuViewController.swift
//  Aceros
//
//  Created by Apple on 15/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDisatanceAndTime: UILabel!
    
    // MARK: - Variables
    private var dataSource: TableViewDataSource? {
        didSet{
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
        }
    }
    var delegate:ProfileViewControllerDelegate?
    //    let arrOptions = ["Check in history", "Clients","Day-out"]
    var arrOptions:[String]? = []
    
    let arrIcon  = [R.image.ic_history_side_m(), R.image.ic_clients_side_m(), R.image.ic_clients_side_m()]
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CommonData.arrayCheckIns?.forEach({ (item) in
            print(item?.source_lat)
            print(item?.source_lng)
        })
        
        if CommonData.arrayCheckIns == nil{
            lblDisatanceAndTime.isHidden = true
        }
    }
    
    // MARK: - View Setup
    func viewSetup(){
        
        let data = Singleton.shared.userData?.profile
        if (!(/data?.is_day_out?.boolValue) && !(/data?.is_day_in?.boolValue)){
            arrOptions = [R.string.localizable.panelMenuCheckHistory(), R.string.localizable.panelMenuClients()]
        }
        else{
            arrOptions = [R.string.localizable.panelMenuCheckHistory(), R.string.localizable.panelMenuClients(),R.string.localizable.panelMenuDayOut()]
        }
        self.setupTableView()
        let date = Date().toString(format: "d MMM")
        lblDate.text = "\(R.string.localizable.panelToday())\(date)"
    }
    
    // MARK: - Setup TableView
    fileprivate func setupTableView() {
        tableView.register(UINib(nibName: TableCellID.SettingsTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: TableCellID.SettingsTableViewCell.rawValue)
        tableView.tableFooterView = UIView()
        
        dataSource = TableViewDataSource(items: arrOptions , height: UITableView.automaticDimension, tableView: tableView , cellIdentifier: TableCellID(rawValue: TableCellID.SettingsTableViewCell.rawValue), isFromType : false)
        
        dataSource?.configureCellBlock = { [weak self]( cell , item , indexPath) in
            guard let cell = cell as? SettingTableViewCell else {return}
            cell.lblTitle.text = self?.arrOptions?[indexPath.row]
            cell.imgView.image = self?.arrIcon[indexPath.row]
            let data = Singleton.shared.userData?.profile
            if indexPath.row == 2{
                if (/data?.is_day_out?.boolValue) || (!(/data?.is_day_out?.boolValue) && !(/data?.is_day_in?.boolValue)){
                    cell.lblTitle.text = R.string.localizable.panelAlreadyDayOut()
                }
                else{
                    cell.lblTitle.text = R.string.localizable.panelDayOut()
                }
            }
        }
        
        dataSource?.aRowSelectedListener = { [weak self] indexPath in
            guard let _ = self else { return }
            
            if indexPath.row == 0{
                guard let vc = R.storyboard.main.checkInHistoryViewController() else{return}
                UIApplication.topViewController()?.pushVC(vc)
            }
            else if  indexPath.row == 1{
                guard let vc = R.storyboard.leftPanel.clientsViewController() else {return}
                UIApplication.topViewController()?.pushVC(vc)
            }
            else{
                let data = Singleton.shared.userData?.profile
                if (/data?.is_day_out?.boolValue) || (!(/data?.is_day_out?.boolValue) && !(/data?.is_day_in?.boolValue)){
                    UtilityFunctions.makeToast(text:R.string.localizable.panelMsgDayout(), type: .error)
                }
                else{
                    self?.dayOutUser()
                }
            }
            
        }
        tableView.reloadData()
    }
    
    // MARK: - Button Action
    @IBAction func actionLogout(_ sender: Any) {
        
        let logoutResponse:ResultCallback<User?,ResponseStatus>  = { result in
            switch result {
            case .success(let data):
                guard let _ = data else { return }
                if (/data?.success).boolValue{
                    self.logOut()
                }
                else{
                    UtilityFunctions.makeToast(text: /data?.msg, type: .error)
                }
            case .failure(let error):
                UtilityFunctions.makeToast(text: error.localizedDescription, type: .error)
            }
        }
        
        HomeTarget.logout().requestCodable(showLoader: true, response: logoutResponse)
    }
    
    //MARK: - Logout
    fileprivate func logOut() {
        Singleton.shared.userData = nil
        guard let vc = R.storyboard.login.loginViewController() else { return }
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    //MARK: - DayOut API Request
    
    func dayOutUser(){
        let dayOutResponse:ResultCallback<User?,ResponseStatus>  = { result in
            switch result {
            case .success(let data):
                guard let _ = data else { return }
                
                if (/data?.success).boolValue{
                    self.delegate?.updateHomeScreen(isDayOut: true, isProfileUpdated: false)
                    UtilityFunctions.makeToast(text:R.string.localizable.popDayOutSucceess(), type: .success)
                    UIApplication.getTopMostViewController()?.dismiss(animated: true)
                }
                else{
                    UtilityFunctions.makeToast(text: /data?.msg, type: .error)
                }
            case .failure(let error):
                UtilityFunctions.makeToast(text: error.localizedDescription, type: .error)
                return
            }
        }
        
        HomeTarget.userDayOut(access_token: /Singleton.shared.userData?.profile?.access_token).requestCodable(showLoader: true, response: dayOutResponse)
    }
}
