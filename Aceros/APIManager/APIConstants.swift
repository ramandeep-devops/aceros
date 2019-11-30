


import Foundation
import ObjectMapper

internal struct APIConstants {
    //BasePath
//    http://45.232.252.31  original
    static let baseUrl = "http://45.232.252.34"
    static let basepath = "\(baseUrl)/aceros_backend/api/users/"
        static let googleApiKey = "AIzaSyBiBi-y-jreGQjQfu1M1Fnr8WYZxIZIrxw"
    static let imageBasePath = "\(baseUrl)/aceros_backend/"
    
    //Login Signup
    static let login = "login"
    static let passwordReset = "auth/password_reset"
    
    //HomePage
    static let trackpath = "trackpath"
    static let dayOut = "userDayOut"

    static let checkIn = "checkin"
    static let checkInAttributes = "listdropdown"
    static let getUserProfile = "userprofile"
    static let editprofile = "editprofile"
    static let checkIns = "checkins"
    static let logout = "logout"
    static let checkInDetails = "checkindetails"
    static let addclient = "addclient"
    static let listclient = "listclient"
    static let logInteraction = "logInteraction"
    static let places = "places"
    static let editBuilding = "editBuilding"
}



typealias ResultCallback<T,E:Error> = (Result<T,E>)->Void


enum Result<T,E:Error> {
    case success(data: T)
    case failure(error: E)
}

struct DefaultResponse<T>: Mappable where T:Mappable {
    
    var message:String?
    var data:T?
    var array:[T]?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        message <- map["message"]
        data <- map["data"]
        array <- map["results"]
    }
}

struct DefaultResponseCodable : Codable {
    let success : Int?
    let msg : String?
   
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case msg = "msg"
  
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Int.self, forKey: .success)
        msg = try values.decodeIfPresent(String.self, forKey: .msg)
    }
    
}





enum ResponseStatus: Error, LocalizedError {
    case jsonParsingFailure //In case No data found
    case forbidden
    case sessionExpire
    case internalServerError
    case clientError(message: String)
    case underLying(error: Error)
    
    public var localizedDescription: String {
        return self.message
    }
    
    public var errorDescription: String {
        return self.message
    }
    
    private var message:String {
        switch self {
        case .jsonParsingFailure: return "JSON parsing failure"
        case .forbidden: return "Forbidden"
        case .internalServerError: return "Internal Server Error"
        case .sessionExpire: return "Session Expire"
        case .clientError(let message): return message
        case .underLying(let error): return error.localizedDescription
        }
    }
}

//MARK: - Data -> Data(pretty printed)
func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

func JSONResponseDicionary(_ data: Data) -> [String: Any] {
    do {
        let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        guard let safeValue = jsonData as? [String: Any] else { return [:] }
        return safeValue
    } catch {
        debugPrint("Could not convert JSON data into a dictionary.")
        return [:]
    }
}


