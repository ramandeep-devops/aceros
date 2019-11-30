//
//  ClientList.swift
//  Aceros
//
//  Created by Apple on 02/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

struct ClientList : Codable {
    let success : Int?
    let msg : String?
    let client_list : Client_list?
    
    enum CodingKeys: String, CodingKey {
        
        case success = "success"
        case msg = "msg"
        case client_list = "client_list"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Int.self, forKey: .success)
        msg = try values.decodeIfPresent(String.self, forKey: .msg)
        client_list = try values.decodeIfPresent(Client_list.self, forKey: .client_list)
    }
    
}

struct Client_list : Codable {
    let checkdayin : [Checkdayin]?
    let questions : [Questions]?
    
    enum CodingKeys: String, CodingKey {
        
        case checkdayin = "checkdayin"
        case questions = "questions"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        checkdayin = try values.decodeIfPresent([Checkdayin].self, forKey: .checkdayin)
        questions = try values.decodeIfPresent([Questions].self, forKey: .questions)
    }
    
}


struct Checkdayin : Codable {
    let id : Int?
    let answer : String?
    let created_at : String?
    let mobile : String?
    let emails_id : String?
    let user_id : String?
    let added_by : Int?
    let address : String?
    let visit_motive : String?
    let updated_at : String?
    let client_id : String?
    let lng : String?
    let name : String?
    let lati : String?
    let interaction :String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case answer = "answer"
        case created_at = "created_at"
        case mobile = "mobile"
        case emails_id = "emails_id"
        case user_id = "user_id"
        case added_by = "added_by"
        case address = "address"
        case visit_motive = "visit_motive"
        case updated_at = "updated_at"
        case client_id = "client_id"
        case lng = "lng"
        case name = "name"
        case lati = "lati"
        case interaction = "interaction"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        answer = try values.decodeIfPresent(String.self, forKey: .answer)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        emails_id = try values.decodeIfPresent(String.self, forKey: .emails_id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        added_by = try values.decodeIfPresent(Int.self, forKey: .added_by)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        visit_motive = try values.decodeIfPresent(String.self, forKey: .visit_motive)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        client_id = try values.decodeIfPresent(String.self, forKey: .client_id)
        lng = try values.decodeIfPresent(String.self, forKey: .lng)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        lati = try values.decodeIfPresent(String.self, forKey: .lati)
        interaction = try values.decodeIfPresent(String.self, forKey: .interaction)
    }
    
}
