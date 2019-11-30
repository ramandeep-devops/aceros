/* 
 Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar
 
 */

import Foundation
struct CheckInAttributes : Codable {
    let success : Int?
    let msg : String?
    let dropdowns : Dropdowns?
    
    enum CodingKeys: String, CodingKey {
        
        case success = "success"
        case msg = "msg"
        case dropdowns = "dropdowns"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Int.self, forKey: .success)
        msg = try values.decodeIfPresent(String.self, forKey: .msg)
        dropdowns = try values.decodeIfPresent(Dropdowns.self, forKey: .dropdowns)
    }
    
}

struct Buildings : Codable {
    let id : Int?
    let bname : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case bname = "bname"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        bname = try values.decodeIfPresent(String.self, forKey: .bname)
    }
    
}

struct Sales : Codable {
    let id : Int?
    let sale_name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case sale_name = "sale_name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        sale_name = try values.decodeIfPresent(String.self, forKey: .sale_name)
    }
}

struct Dropdowns : Codable {
    let status : [Status]?
    let progess : [Progess]?
    let persons : [Persons]?
    let buildings : [Buildings]?
    let sales :     [Sales]?
    let purpose :[Purpose]?
    let questions :[Questions]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case progess = "progess"
        case persons = "persons"
        case buildings = "buildings"
        case sales = "sales"
        case purpose = "pur_of_visit"
        case questions = "questions"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent([Status].self, forKey: .status)
        progess = try values.decodeIfPresent([Progess].self, forKey: .progess)
        persons = try values.decodeIfPresent([Persons].self, forKey: .persons)
        buildings = try values.decodeIfPresent([Buildings].self, forKey: .buildings)
        sales = try values.decodeIfPresent([Sales].self, forKey: .sales)
        purpose = try values.decodeIfPresent([Purpose].self, forKey: .purpose)
        questions = try values.decodeIfPresent([Questions].self, forKey: .questions)
        
    }
    
}

struct Questions : Codable {
    let id : Int?
    let quest : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case quest = "quest"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        quest = try values.decodeIfPresent(String.self, forKey: .quest)
    }
    
}


struct Purpose : Codable {
    let id : Int?
    let sname : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case sname = "sname"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        sname = try values.decodeIfPresent(String.self, forKey: .sname)
    }
    
}

struct Persons : Codable {
    let id : Int?
    let prs_name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case prs_name = "prs_name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        prs_name = try values.decodeIfPresent(String.self, forKey: .prs_name)
    }
    
}


struct Status : Codable {
    let id : Int?
    let sname : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case sname = "sname"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        sname = try values.decodeIfPresent(String.self, forKey: .sname)
    }
    
}


struct Progess : Codable {
    let id : Int?
    let prgs_name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case prgs_name = "prgs_name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        prgs_name = try values.decodeIfPresent(String.self, forKey: .prgs_name)
    }
    
}
