/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Places : Codable {
	let id : Int?
	let user_id : Int?
	let location : String?
	let source_lat : String?
	let source_lng : String?
	let building_type : Int?
	let status_type : Int?
	let progress_type : Int?
	let sale_type : Int?
	let building_name : String?
	let contact_person : String?
	let company_detail : String?
	let created_at : String?
	let updated_at : String?
	let is_deleted : Int?
	let deleted_at : String?
    let contact_detail :String?
    let notes : String?
    let description :String?
    let client_detail :String?
    
	enum CodingKeys: String, CodingKey {

		case id = "id"
		case user_id = "user_id"
		case location = "location"
		case source_lat = "source_lat"
		case source_lng = "source_lng"
		case building_type = "building_type"
		case status_type = "status_type"
		case progress_type = "progress_type"
		case sale_type = "sale_type"
		case building_name = "building_name"
		case contact_person = "contact_person"
		case company_detail = "company_detail"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case is_deleted = "is_deleted"
		case deleted_at = "deleted_at"
        case contact_detail = "contact_detail"
        case notes = "notes"
        case description = "description"
        case client_detail = "client_detail"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
		location = try values.decodeIfPresent(String.self, forKey: .location)
		source_lat = try values.decodeIfPresent(String.self, forKey: .source_lat)
		source_lng = try values.decodeIfPresent(String.self, forKey: .source_lng)
		building_type = try values.decodeIfPresent(Int.self, forKey: .building_type)
		status_type = try values.decodeIfPresent(Int.self, forKey: .status_type)
		progress_type = try values.decodeIfPresent(Int.self, forKey: .progress_type)
		sale_type = try values.decodeIfPresent(Int.self, forKey: .sale_type)
		building_name = try values.decodeIfPresent(String.self, forKey: .building_name)
		contact_person = try values.decodeIfPresent(String.self, forKey: .contact_person)
		company_detail = try values.decodeIfPresent(String.self, forKey: .company_detail)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		is_deleted = try values.decodeIfPresent(Int.self, forKey: .is_deleted)
		deleted_at = try values.decodeIfPresent(String.self, forKey: .deleted_at)
        contact_detail = try values.decodeIfPresent(String.self, forKey: .contact_detail)
        notes = try values.decodeIfPresent(String.self, forKey: .notes)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        client_detail = try values.decodeIfPresent(String.self, forKey: .client_detail)


        
	}

}
