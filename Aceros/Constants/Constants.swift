//
//  Constants.swift
//  Electric_Scanner
//
//  Created by Apple on 26/04/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

enum AppColor {
    
    case themeColor
    case shadowColorBlack
    case subThemeColor
    func getColor() -> UIColor{
        switch self {
        case .themeColor:
            return UIColor(red:0.28, green:0.57, blue:0.87, alpha:1)
            
        case .shadowColorBlack:
            return UIColor.black
            
        case .subThemeColor:
            return UIColor.darkGray
        }
       
    }
}

enum AddClientErrors: Error {
    case enterClientName
    case enterClientPosition
    case enterPhoneNumber
    case enterEmail
    case enterValidEmail
    case enterValidPhoneNumber
    
    public var message:String {
        switch self {
        case .enterClientName:
            return "Please enter client name."
        case .enterClientPosition:
            return "Please enter client position in the company."
        case .enterPhoneNumber:
            return "Please enter client mobile number."
        case .enterEmail:
            return "Please enter email address."
        case .enterValidEmail:
            return "Please enter valid email address"
        case .enterValidPhoneNumber:
            return "Please enter valid phone number"
        }
    }
    
}

enum TableCellID: String {
    case SettingsTableViewCell = "SettingTableViewCell"
    case TimelineTableViewCell = "TimelineTableViewCell"
    case BuildingClientsTableViewCell = "BuildingClientsTableViewCell"
    case CompanyAddedTableViewCell = "CompanyAddedTableViewCell"
    case ClientsListTableViewCell = "ClientsListTableViewCell"
    case AddPhotosCollectionViewCellAdd = "AddPhotosCollectionViewCellAdd"
    case AddPhotosCollectionViewCell = "AddPhotosCollectionViewCell"
    case QuestionsTableViewCell = "QuestionsTableViewCell"
    case SearchTableViewCell = "SearchTableViewCell"
}

enum CollectionCellIds :String{
    case TicketTypesCollectionViewCell = "TicketTypesCollectionViewCell"
}

enum notificationIdentifier:String{
    case ApplicationDidBecomeActive = "ApplicationDidBecomeActive"
}


struct RegexExpressions {
    static let emailRegex = "[A-Z0-9a-z._%+-]{1,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    static let phoneRegex = "[0-9]{6,14}"
}
