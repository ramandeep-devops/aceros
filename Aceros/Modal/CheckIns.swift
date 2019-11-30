 
  
 import Foundation
 
 struct CheckIns : Codable {
    let success : Int?
    let msg : String?
    let checkindata : Checkindata?
    
    enum CodingKeys: String, CodingKey {
        
        case success = "success"
        case msg = "msg"
        case checkindata = "checkindata"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Int.self, forKey: .success)
        msg = try values.decodeIfPresent(String.self, forKey: .msg)
        checkindata = try values.decodeIfPresent(Checkindata.self, forKey: .checkindata)
    }
    
 }
 
 
 struct Checkindata : Codable {
    let checkin_detail : [Checkin_detail]?
    let user_detail : User_detail?
    let checkin : Checkin?
    let checkin_images : [Checkin_images]?
    let day_in : Day_in?
    
    enum CodingKeys: String, CodingKey {
        
        case checkin_detail = "checkin_detail"
        case user_detail = "user_detail"
        case checkin = "checkin"
        case checkin_images = "checkin_images"
        case day_in = "day_in"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        checkin_detail = try values.decodeIfPresent([Checkin_detail].self, forKey: .checkin_detail)
        user_detail = try values.decodeIfPresent(User_detail.self, forKey: .user_detail)
        checkin = try values.decodeIfPresent(Checkin.self, forKey: .checkin)
        checkin_images = try values.decodeIfPresent([Checkin_images].self, forKey: .checkin_images)
        day_in =  try values.decodeIfPresent(Day_in.self, forKey: .day_in)
 }
    
 }
 
 struct Day_in:Codable{
    let dayin_timing : String?
    let dayout_timing : String?
    
    enum CodingKeys: String, CodingKey {
        case dayin_timing = "dayin_timing"
        case dayout_timing = "dayout_timing"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dayin_timing = try values.decodeIfPresent(String.self, forKey: .dayin_timing)
        dayout_timing = try values.decodeIfPresent(String.self, forKey: .dayout_timing)
    }
 }
 
 
 struct Checkin_detail : Codable {
    let id : Int?
    let building_name : String?
    let contact_person : String?
    let progress_type : Int?
    let source_lat : String?
    let source_lng : String?
    let created_at : String?
    let user_id : Int?
    let location : String?
    let building_type : Int?
    let status_type : Int?
    let updated_at : String?
    let company_detail : String?
    let sale_type : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case building_name = "building_name"
        case contact_person = "contact_person"
        case progress_type = "progress_type"
        case source_lat = "source_lat"
        case source_lng = "source_lng"
        case created_at = "created_at"
        case user_id = "user_id"
        case location = "location"
        case building_type = "building_type"
        case status_type = "status_type"
        case updated_at = "updated_at"
        case company_detail = "company_detail"
        case sale_type = "sale_type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        building_name = try values.decodeIfPresent(String.self, forKey: .building_name)
        contact_person = try values.decodeIfPresent(String.self, forKey: .contact_person)
        progress_type = try values.decodeIfPresent(Int.self, forKey: .progress_type)
        source_lat = try values.decodeIfPresent(String.self, forKey: .source_lat)
        source_lng = try values.decodeIfPresent(String.self, forKey: .source_lng)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        building_type = try values.decodeIfPresent(Int.self, forKey: .building_type)
        status_type = try values.decodeIfPresent(Int.self, forKey: .status_type)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        company_detail = try values.decodeIfPresent(String.self, forKey: .company_detail)
        sale_type = try values.decodeIfPresent(Int.self, forKey: .sale_type)
    }
    
 }

 
 
 struct User_detail : Codable {
    let server_time : Server_time?
    let region : String?
    let user_level : Int?
    let conveyance : String?
    let daily_allowance : Int?
    let id : Int?
    let is_admin : Int?
    let created_at : String?
    let is_day_out : Int?
    let designation_name : String?
    let pwd_salt : String?
    let last_password_changed : String?
    let allowance_per_km : Int?
    let address : String?
    let accomodation_allowance : Int?
    let deleted_at : String?
    let u_id : String?
    let reg_id : String?
    let last_logged_in : String?
    let fullname : String?
    let dob : String?
    let email : String?
    let image : String?
    let access_token : String?
    let lng : String?
    let designation_code : String?
    let user_role : Int?
    let gender : String?
    let lat : String?
    let country_code : String?
    let is_password_change : Int?
    let updated_at : String?
    let manager_id : Int?
    let is_verified : Int?
    let manager_fullname : String?
    let password : String?
    let phone : String?
    let imei : String?
    let is_block : Int?
    let dayin_timing : String?
    let is_day_in : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case server_time = "server_time"
        case region = "region"
        case user_level = "user_level"
        case conveyance = "conveyance"
        case daily_allowance = "daily_allowance"
        case id = "id"
        case is_admin = "is_admin"
        case created_at = "created_at"
        case is_day_out = "is_day_out"
        case designation_name = "designation_name"
        case pwd_salt = "pwd_salt"
        case last_password_changed = "last_password_changed"
        case allowance_per_km = "allowance_per_km"
        case address = "address"
        case accomodation_allowance = "accomodation_allowance"
        case deleted_at = "deleted_at"
        case u_id = "u_id"
        case reg_id = "reg_id"
        case last_logged_in = "last_logged_in"
        case fullname = "fullname"
        case dob = "dob"
        case email = "email"
        case image = "image"
        case access_token = "access_token"
        case lng = "lng"
        case designation_code = "designation_code"
        case user_role = "user_role"
        case gender = "gender"
        case lat = "lat"
        case country_code = "country_code"
        case is_password_change = "is_password_change"
        case updated_at = "updated_at"
        case manager_id = "manager_id"
        case is_verified = "is_verified"
        case manager_fullname = "manager_fullname"
        case password = "password"
        case phone = "phone"
        case imei = "imei"
        case is_block = "is_block"
        case dayin_timing = "dayin_timing"
        case is_day_in = "is_day_in"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        server_time = try values.decodeIfPresent(Server_time.self, forKey: .server_time)
        region = try values.decodeIfPresent(String.self, forKey: .region)
        user_level = try values.decodeIfPresent(Int.self, forKey: .user_level)
        conveyance = try values.decodeIfPresent(String.self, forKey: .conveyance)
        daily_allowance = try values.decodeIfPresent(Int.self, forKey: .daily_allowance)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        is_admin = try values.decodeIfPresent(Int.self, forKey: .is_admin)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        is_day_out = try values.decodeIfPresent(Int.self, forKey: .is_day_out)
        designation_name = try values.decodeIfPresent(String.self, forKey: .designation_name)
        pwd_salt = try values.decodeIfPresent(String.self, forKey: .pwd_salt)
        last_password_changed = try values.decodeIfPresent(String.self, forKey: .last_password_changed)
        allowance_per_km = try values.decodeIfPresent(Int.self, forKey: .allowance_per_km)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        accomodation_allowance = try values.decodeIfPresent(Int.self, forKey: .accomodation_allowance)
        deleted_at = try values.decodeIfPresent(String.self, forKey: .deleted_at)
        u_id = try values.decodeIfPresent(String.self, forKey: .u_id)
        reg_id = try values.decodeIfPresent(String.self, forKey: .reg_id)
        last_logged_in = try values.decodeIfPresent(String.self, forKey: .last_logged_in)
        fullname = try values.decodeIfPresent(String.self, forKey: .fullname)
        dob = try values.decodeIfPresent(String.self, forKey: .dob)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        access_token = try values.decodeIfPresent(String.self, forKey: .access_token)
        lng = try values.decodeIfPresent(String.self, forKey: .lng)
        designation_code = try values.decodeIfPresent(String.self, forKey: .designation_code)
        user_role = try values.decodeIfPresent(Int.self, forKey: .user_role)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        lat = try values.decodeIfPresent(String.self, forKey: .lat)
        country_code = try values.decodeIfPresent(String.self, forKey: .country_code)
        is_password_change = try values.decodeIfPresent(Int.self, forKey: .is_password_change)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        manager_id = try values.decodeIfPresent(Int.self, forKey: .manager_id)
        is_verified = try values.decodeIfPresent(Int.self, forKey: .is_verified)
        manager_fullname = try values.decodeIfPresent(String.self, forKey: .manager_fullname)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        imei = try values.decodeIfPresent(String.self, forKey: .imei)
        is_block = try values.decodeIfPresent(Int.self, forKey: .is_block)
        dayin_timing = try values.decodeIfPresent(String.self, forKey: .dayin_timing)
        is_day_in = try values.decodeIfPresent(Int.self, forKey: .is_day_in)
    }
    
 }
 struct Server_time : Codable {
    let date : String?
    let timezone : String?
    let timezone_type : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case date = "date"
        case timezone = "timezone"
        case timezone_type = "timezone_type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        timezone = try values.decodeIfPresent(String.self, forKey: .timezone)
        timezone_type = try values.decodeIfPresent(Int.self, forKey: .timezone_type)
    }
    
 }
 
 struct Checkin : Codable {
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
    }
    
 }

 
 struct Checkin_images : Codable {
    let id : Int?
    let checkin_id : Int?
    let thumbnail_url : String?
    let media_url : String?
    let category : String?
    let media_type : String?
    let created_at : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case checkin_id = "checkin_id"
        case thumbnail_url = "thumbnail_url"
        case media_url = "media_url"
        case category = "category"
        case media_type = "media_type"
        case created_at = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        checkin_id = try values.decodeIfPresent(Int.self, forKey: .checkin_id)
        thumbnail_url = try values.decodeIfPresent(String.self, forKey: .thumbnail_url)
        media_url = try values.decodeIfPresent(String.self, forKey: .media_url)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        media_type = try values.decodeIfPresent(String.self, forKey: .media_type)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
    }
    
 }
