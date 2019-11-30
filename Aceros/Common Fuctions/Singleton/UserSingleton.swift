

import UIKit
import CoreLocation
//import ObjectMapper
import RMMapper

enum SingletonKeys : String {
    case user = "UserDetails"
}

class Singleton {
    
    static var shared = {
        return Singleton()
    }()
    
    var userData:User? {
        get {
            let val =  UserDefaults.standard.object(User.self, with: SingletonKeys.user.rawValue)
            
            return val
            
        } set {
            if let value = newValue {
                UserDefaults.standard.set(object: value, forKey: SingletonKeys.user.rawValue)
                
            } else {
                UserDefaults.standard.removeObject(forKey: SingletonKeys.user.rawValue)
            }
        }
    }
    
    
    
    
    //    var userData:User? {
    //        get {
    //            guard let data = UserDefaults.standard.rm_customObject(forKey: SingletonKeys.user.rawValue) as? User else { return nil }
    //            return data
    //
    //            UserDefaults.standard.rm
    //
    //        } set {
    //            if let value = newValue {
    //                UserDefaults.standard.rm_setCustomObject(value, forKey: SingletonKeys.user.rawValue)
    //            } else {
    //                UserDefaults.standard.removeObject(forKey: SingletonKeys.user.rawValue)
    //            }
    //        }
    //    }
    
}


//class UserData {
//    
//    static var share: UserData = {
//        return UserData()
//    }()
//   
//    //TODO: Need to handle
//    var loggedInUser: UserModal? {
//        get{
//            
//            guard let data = UserDefaults.standard.rm_customObject(forKey: SingletonKeys.user.rawValue ) else {return nil}
//            return Mapper<UserModal>().map(JSONObject: data as? [String : Any])
//        
//        }
//        set{
//            if let value = newValue{
//                
//                UserDefaults.standard.rm_setCustomObject(value.toJSON(),  forKey: SingletonKeys.user.rawValue)
//
//            }else{
//                
//                 UserDefaults.standard.rm_setCustomObject(nil,  forKey: SingletonKeys.user.rawValue)
//                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
//            }
//        }
//    }
//
//    var loggedInUserDeviceToken: String? {
//        get{
//            guard let userData = UserDefaults.standard.data(forKey: SingletonKeys.deviceToken.rawValue ) else { return nil }
//            return (NSKeyedUnarchiver.unarchiveObject(with: userData) as? String)
//        }
//        set{
//            if let value = newValue{
//                let val = NSKeyedArchiver.archivedData(withRootObject: value)
//                UserDefaults.standard.set(val, forKey: SingletonKeys.deviceToken.rawValue)
//            }else{
//                UserDefaults.standard.set(nil, forKey: SingletonKeys.deviceToken.rawValue)
//            }
//        }
//    }
//}
//
//
//



extension UserDefaults {
    
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }
    
    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
    
}
