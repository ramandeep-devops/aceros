//
//  SearchBuildingViewController.swift
//  Aceros
//
//  Created by Apple on 06/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

protocol SearchBuildingViewControllerDelegate {
    func selectedBuilding(isSelected:Bool,building:Places?)
}

class SearchBuildingViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Variables
    
    private var dataSource: TableViewDataSource? {
        didSet{
            tableView.dataSource = dataSource
            tableView.delegate = dataSource
        }
    }
    
    var arrPlaces : [Places]?{
        didSet{
            self.dataSource?.items = self.arrPlaces
            self.tableView.reloadData()
        }
    }
    var delegate:SearchBuildingViewControllerDelegate?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    // MARK: - Custom Methods
    
    func setupView(){
        if let cancelButton : UIButton = searchBar.value(forKey: "_cancelButton") as? UIButton{
            cancelButton.isEnabled = true
        }
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): AppColor.themeColor.getColor()], for: .normal)
        self.setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchBuildings(text: "")
    }
    
    // MARK: - Setup Table View
    
    fileprivate func setupTableView() {
        
        tableView.register(UINib(nibName: TableCellID.SearchTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: TableCellID.SearchTableViewCell.rawValue)
        tableView.tableFooterView = UIView()
        
        dataSource = TableViewDataSource(items: arrPlaces , height: UITableView.automaticDimension, tableView: tableView , cellIdentifier: TableCellID(rawValue: TableCellID.SearchTableViewCell.rawValue), isFromType : false)
        
        dataSource?.configureCellBlock = {( cell , item , indexPath) in
            guard let cell = cell as? SearchTableViewCell else {return}
            let obj = item as? Places
            cell.lblName.text = obj?.building_name
            cell.lblAddress.text = obj?.location
        }
        
        dataSource?.aRowSelectedListener = { [weak self] indexPath in
            guard let self = self else { return }
            self.delegate?.selectedBuilding(isSelected: true, building: self.arrPlaces?[indexPath.row])
            UIApplication.topViewController()?.dismissVC(completion: nil)
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Search Bar Delegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate?.selectedBuilding(isSelected: false, building: nil)
        UIApplication.topViewController()?.dismissVC(completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        self.searchBuildings(text: searchText)
    }
    
    // MARK: - Api search request
    
    func searchBuildings(text :String?){
        var isLoader = false
        if text == ""{
            isLoader = true
        }
        
        let searchResponse:ResultCallback<SearchPlace?,ResponseStatus> = {[weak self] result in
          
                switch result {
                case .success(let data):
                    
                    guard let data = data else { return }
                    if (/data.success).boolValue{
                        print("result")
                        self?.arrPlaces = data.places
                    }
                    else{
                        print("no result")
                    }
                case .failure( _):
                    return
                }
        }
        
        HomeTarget.searchBuilding(search: /text).requestCodable(showLoader: isLoader, response: searchResponse)
    }
}
