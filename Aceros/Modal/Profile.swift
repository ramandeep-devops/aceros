/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Profile : Codable {
	let id : Int?
	let imei : String?
	let u_id : String?
	let user_role : Int?
	let user_level : Int?
	let manager_id : Int?
	let access_token : String?
	let fullname : String?
	let email : String?
	let password : String?
	let pwd_salt : String?
	let image : String?
	let address : String?
	let gender : String?
	let lat : String?
	let lng : String?
	let country_code : String?
	let phone : String?
	let dob : String?
	let region : String?
	let conveyance : String?
	let allowance_per_km : Int?
	let daily_allowance : Int?
	let accomodation_allowance : Int?
	let is_verified : Int?
	let is_block : Int?
	let reg_id : String?
	let is_admin : Int?
	let is_day_in : Int?
    let is_day_out : Int?

	let is_password_change : Int?
	let dayin_timing : String?
	let last_password_changed : String?
	let last_logged_in : String?
	let created_at : String?
	let updated_at : String?
	let deleted_at : String?
	let designation_name : String?
	let designation_code : String?
	let manager_fullname : String?
	let distance : Int?
	let price : Int?
	let travel_time : Int?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case imei = "imei"
		case u_id = "u_id"
		case user_role = "user_role"
		case user_level = "user_level"
		case manager_id = "manager_id"
		case access_token = "access_token"
		case fullname = "fullname"
		case email = "email"
		case password = "password"
		case pwd_salt = "pwd_salt"
		case image = "image"
		case address = "address"
		case gender = "gender"
		case lat = "lat"
		case lng = "lng"
		case country_code = "country_code"
		case phone = "phone"
		case dob = "dob"
		case region = "region"
		case conveyance = "conveyance"
		case allowance_per_km = "allowance_per_km"
		case daily_allowance = "daily_allowance"
		case accomodation_allowance = "accomodation_allowance"
		case is_verified = "is_verified"
		case is_block = "is_block"
		case reg_id = "reg_id"
		case is_admin = "is_admin"
		case is_day_in = "is_day_in"
        case is_day_out = "is_day_out"
		case is_password_change = "is_password_change"
		case dayin_timing = "dayin_timing"
		case last_password_changed = "last_password_changed"
		case last_logged_in = "last_logged_in"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case deleted_at = "deleted_at"
		case designation_name = "designation_name"
		case designation_code = "designation_code"
		case manager_fullname = "manager_fullname"
		case distance = "distance"
		case price = "price"
		case travel_time = "travel_time"
	}

    
    
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		imei = try values.decodeIfPresent(String.self, forKey: .imei)
		u_id = try values.decodeIfPresent(String.self, forKey: .u_id)
		user_role = try values.decodeIfPresent(Int.self, forKey: .user_role)
		user_level = try values.decodeIfPresent(Int.self, forKey: .user_level)
		manager_id = try values.decodeIfPresent(Int.self, forKey: .manager_id)
		access_token = try values.decodeIfPresent(String.self, forKey: .access_token)
		fullname = try values.decodeIfPresent(String.self, forKey: .fullname)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		password = try values.decodeIfPresent(String.self, forKey: .password)
		pwd_salt = try values.decodeIfPresent(String.self, forKey: .pwd_salt)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		gender = try values.decodeIfPresent(String.self, forKey: .gender)
		lat = try values.decodeIfPresent(String.self, forKey: .lat)
		lng = try values.decodeIfPresent(String.self, forKey: .lng)
		country_code = try values.decodeIfPresent(String.self, forKey: .country_code)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		dob = try values.decodeIfPresent(String.self, forKey: .dob)
		region = try values.decodeIfPresent(String.self, forKey: .region)
		conveyance = try values.decodeIfPresent(String.self, forKey: .conveyance)
		allowance_per_km = try values.decodeIfPresent(Int.self, forKey: .allowance_per_km)
		daily_allowance = try values.decodeIfPresent(Int.self, forKey: .daily_allowance)
		accomodation_allowance = try values.decodeIfPresent(Int.self, forKey: .accomodation_allowance)
		is_verified = try values.decodeIfPresent(Int.self, forKey: .is_verified)
		is_block = try values.decodeIfPresent(Int.self, forKey: .is_block)
		reg_id = try values.decodeIfPresent(String.self, forKey: .reg_id)
		is_admin = try values.decodeIfPresent(Int.self, forKey: .is_admin)
		is_day_in = try values.decodeIfPresent(Int.self, forKey: .is_day_in)
        is_day_out = try values.decodeIfPresent(Int.self, forKey: .is_day_out)
		is_password_change = try values.decodeIfPresent(Int.self, forKey: .is_password_change)
		dayin_timing = try values.decodeIfPresent(String.self, forKey: .dayin_timing)
		last_password_changed = try values.decodeIfPresent(String.self, forKey: .last_password_changed)
		last_logged_in = try values.decodeIfPresent(String.self, forKey: .last_logged_in)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		deleted_at = try values.decodeIfPresent(String.self, forKey: .deleted_at)
		designation_name = try values.decodeIfPresent(String.self, forKey: .designation_name)
		designation_code = try values.decodeIfPresent(String.self, forKey: .designation_code)
		manager_fullname = try values.decodeIfPresent(String.self, forKey: .manager_fullname)
		distance = try values.decodeIfPresent(Int.self, forKey: .distance)
		price = try values.decodeIfPresent(Int.self, forKey: .price)
		travel_time = try values.decodeIfPresent(Int.self, forKey: .travel_time)
	}

}
