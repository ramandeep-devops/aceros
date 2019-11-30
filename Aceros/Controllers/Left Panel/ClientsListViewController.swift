//
//  ClientsListViewController.swift
//  Aceros
//
//  Created by Apple on 25/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import IBAnimatable

class ClientsListViewController: UIViewController, ClientDetailViewControllerDelegate, UISearchBarDelegate, AddClientViewControllerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lblNoresult: UILabel!
    @IBOutlet weak var viewBottom: AnimatableView!
    
    // MARK: - Variables
    
    private var dataSource: TableViewDataSource? {
        didSet{
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
        }
    }
    
    var arrClients = [Checkdayin](){
        didSet{
            if let _ = self.tableView, let _  = self.lblNoresult{
                if arrClients.isEmpty{ self.tableView.isHidden = true } else{self.tableView.isHidden = false}
                self.lblNoresult.text = R.string.localizable.popNosearchReasult()
            }
        }
    }
    var arrAllClients = [Checkdayin](){
        didSet{
            if let _ = self.tableView, let _  = self.lblNoresult{
                if arrAllClients.isEmpty{ self.tableView.isHidden = true } else{self.tableView.isHidden = false}
                self.lblNoresult.text = R.string.localizable.popNoClientsAvailable()
            }
        }
    }
    
    var isFromCheckIn = false
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ =  self.arrClients.isEmpty ? ( getClientList()): (self.arrAllClients = self.arrClients)
        setupTableView()
        let _ = isFromCheckIn ? ( viewBottom.isHidden = true) : (viewBottom.isHidden = false)
    }
    
    // MARK: - Custom Methods / Delegates
    
    func updateClients() {
        self.getClientList()
    }
    
    func reloadClients() {
        self.getClientList()
        
    }
    
    // MARK: - Button Action
    
    @IBAction func actionAddClient(_ sender: Any) {
        guard let vc = R.storyboard.leftPanel.addClientViewController() else {return}
        vc.delegate = self
        UIApplication.topViewController()?.pushVC(vc)
    }
    
    @IBAction func actionMapClients(_ sender: Any) {
        UIApplication.getTopMostViewController()?.popVC()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        UIApplication.getTopMostViewController()?.popVC()
    }
    
    
    // MARK: - Setup TableView
    
    fileprivate func setupTableView() {
        
        tableView.register(UINib(nibName: TableCellID.ClientsListTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: TableCellID.ClientsListTableViewCell.rawValue)
        tableView.tableFooterView = UIView()
        
        dataSource = TableViewDataSource(items: arrClients , height: UITableView.automaticDimension, tableView: tableView , cellIdentifier: TableCellID(rawValue: TableCellID.ClientsListTableViewCell.rawValue), isFromType : false)
        
        dataSource?.configureCellBlock = {( cell , item , indexPath) in
            guard let cell = cell as? ClientsListTableViewCell else {return}
            let obj = item as? Checkdayin
            cell.lblname.text = obj?.name
            cell.lblPlace.text = obj?.address
            cell.lblDate.text = obj?.created_at?.toDate()?.toString(format: "MMM d, yyyy")
            
            let str = obj?.interaction
            
            var  isLoggedIn = false
            let interactionData = str?.data(using: .utf8)!
            
            do {
                let companies = try JSONSerialization.jsonObject(with: interactionData!, options: .allowFragments)
                if let arrCmpny = companies as? Array<[String:String]> {
                    
                    for item in arrCmpny{
                        if item["answer"] != ""{
                            isLoggedIn = true
                            break
                        }
                    }
                }
            }
            catch{
                isLoggedIn = false
                print("error in parsing string to json")
            }
            
            if !isLoggedIn{
                cell.lblInteractionStatus.text = "Interaction not logged"
                cell.lblInteractionStatus.textColor = UIColor(red:1, green:0.27, blue:0.27, alpha:1)
            }
            else{
                cell.lblInteractionStatus.text = "Interaction logged"
                cell.lblInteractionStatus.textColor = UIColor(red:0.18, green:0.79, blue:0.57, alpha:1)
            }
        }
        
        dataSource?.aRowSelectedListener = { [weak self] indexPath in
            guard let self = self else { return }
            
            guard let vc = R.storyboard.leftPanel.clientDetailViewController() else { return  }
            vc.data =  self.arrClients[indexPath.row]
            vc.delegate = self
            UIApplication.topViewController()?.pushVC(vc)
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Api Request Get Clients
    
    
    func getClientList(){
        
        let clientResp:ResultCallback<ClientList?,ResponseStatus> = {[weak self] result in
            
            switch result {
            case .success(let data):
                guard let data = data else{return}
                if let arr = data.client_list?.checkdayin{
                    self?.arrClients = arr
                    self?.arrAllClients = arr
                    self?.dataSource?.items = self?.arrClients
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                UtilityFunctions.makeToast(text: error.localizedDescription, type: .error)
            }
            
        }
        
        HomeTarget.listClient().requestCodable(showLoader: true, response: clientResp)
    }
    
    // MARK: - Search Bar Delegates
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == ""{
            self.arrClients = self.arrAllClients
            self.dataSource?.items = self.arrClients
            self.tableView.reloadData()
        }
        else{
            
            let val = self.arrAllClients
            let filtered = val.filter { /$0.name?.containsIgnoringCase(find: searchText) }
            self.arrClients = filtered
            self.dataSource?.items = self.arrClients
            self.tableView.reloadData()
        }
        
        
    }
    
    
    
}
