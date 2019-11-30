//
//  Home+API.swift
//  Electric_Scanner
//
//  Created by Paradox on 19/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Moya
import Foundation
import ObjectMapper

enum HomeTarget {
    case userDayIn(start_lat:String?, start_lng:String?, Start_address:String?, Access_token:String)
    case userDayOut(access_token:String)
    case checkIn(notes:String,description:String,client_detail:String?,contact_detail:String,source_lat:String?,source_lng:String?,location:String?,building_type:String?,status_type:String?,progress_type:String?,sale_type:String?,company_detail:String,contact_person:String?,building_name:String?,user_id:String?,access_token:String?,building_images:[UIImage?])
    case checkInAttributes(access_token:String?)
    case getUserProfile(access_token:String?)
    case updateProfile(fullName:String,address:String,image:UIImage?)
    case getCheckIns(date:String?)
    case getCheckInDetails(id:Int?)
    case addClient(name:String?,c_name:String?,mobile:String?,visit_motive:String?,emails_id:String?,lati:String?,lng:String?,address:String?)
    case listClient()
    case logInteraction (client_id:String?,question:String?,answer:Array<Any>)
    case searchBuilding(search:String?)
    case updateBuilding(building_id:String?,source_lat:String?,source_lng:String?,location:String?,building_type:String?,status_type:String?,progress_type:String?,sale_type:String?,company_detail:String,contact_person:String?,building_name:String?,user_id:String?,access_token:String?,building_images:[UIImage?],deletedImageIds:String?)
    case logout()
}

extension HomeTarget: TargetType, APIRequest {
    
    var baseURL: URL {
        return URL(string: APIConstants.basepath)!
    }
    
    var path: String {
        switch self {
        case .userDayIn: return APIConstants.trackpath
        case .userDayOut: return APIConstants.dayOut
        case .checkIn: return APIConstants.checkIn
        case .checkInAttributes: return APIConstants.checkInAttributes
        case .getUserProfile : return APIConstants.getUserProfile
        case .updateProfile: return APIConstants.editprofile
        case .getCheckIns: return APIConstants.checkIns
        case .logout: return APIConstants.logout
        case .getCheckInDetails: return APIConstants.checkInDetails
        case .addClient: return APIConstants.addclient
        case .listClient: return APIConstants.listclient
        case .logInteraction : return APIConstants.logInteraction
        case .searchBuilding: return APIConstants.places
        case .updateBuilding: return APIConstants.editBuilding
        }
    }
    
    var method: Moya.Method {
        switch self {
        default: return .post
        }
    }
    
    var sampleData: Data {
        return Data("No Data found".utf8)
    }
    
    var task: Task {
        switch self {
            
        case .checkIn(_),.updateProfile(_),.updateBuilding(_):
            return .uploadMultipart(multipartBody ?? [])
            
        default: return .requestParameters(parameters: self.parameters, encoding: JSONEncoding.default)
            
        }
    }
    
    var multipartBody: [MultipartFormData]? {
        
        switch self {
            
        case .checkIn(notes: _,_,_,_, _, _, _, _, _, _, _, _, _, _, _, _, let building_images) :
            
            var multipartData = [MultipartFormData]()
            
            for (_,item) in building_images.enumerated(){
                
                if let img = item{
                    let data = img.jpegData(compressionQuality: 0.3) ?? Data()
                    multipartData.append(MultipartFormData.init(provider: .data(data), name: "building_images[]", fileName: "image.jpg", mimeType: "image/jpeg"))
                }
            }
            
            parameters.forEach({ (key, value) in
                
                let tempValue = "\(value)"
                let data = tempValue.data(using: String.Encoding.utf8) ?? Data()
                multipartData.append(MultipartFormData.init(provider: .data(data), name: key))
            })
            
            return multipartData
            
        case .updateBuilding(building_id: _, _, _, _, _, _, _, _, _, _, _, _, _,let building_images,_) :
            
            var multipartData = [MultipartFormData]()
            
            for (_,item) in building_images.enumerated(){
                
                if let img = item{
                    let data = img.jpegData(compressionQuality: 0.3) ?? Data()
                    multipartData.append(MultipartFormData.init(provider: .data(data), name: "building_images[]", fileName: "image.jpg", mimeType: "image/jpeg"))
                }
            }
            
            parameters.forEach({ (key, value) in
                
                let tempValue = "\(value)"
                let data = tempValue.data(using: String.Encoding.utf8) ?? Data()
                multipartData.append(MultipartFormData.init(provider: .data(data), name: key))
            })
            
            return multipartData
            
        case .updateProfile(_ , _ , let image):
            
            var multipartData = [MultipartFormData]()
            
            if let img = image{
                let data = img.jpegData(compressionQuality: 0.3) ?? Data()
                multipartData.append(MultipartFormData.init(provider: .data(data), name: "image", fileName: "image.jpg", mimeType: "image/jpeg"))
            }
            
            parameters.forEach({ (key, value) in
                
                let tempValue = "\(value)"
                let data = tempValue.data(using: String.Encoding.utf8) ?? Data()
                multipartData.append(MultipartFormData.init(provider: .data(data), name: key))
            })
            
            return multipartData
            
        default:
            return nil
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var parameters: [String : Any] {
        switch self {
            
        case .userDayIn(let start_lat   , let start_lng , let Start_address, let Access_token) :
            return ["start_lat":/start_lat,"start_lng":/start_lng,"start_address":/Start_address,"access_token":/Access_token]
            
        case .checkIn(let notes, let description, let client_detail,let contact_detail,let source_lat,let  source_lng, let location, let building_type, let status_type,let  progress_type,let sale_type,let  company_detail,let contact_person,let building_name, let user_id, let access_token, _) :
            return ["notes":/notes,"description":/description,"client_detail":/client_detail,"contact_detail":/contact_detail,"source_lat":/source_lat, "source_lng":/source_lng, "location":/location, "building_type":/building_type, "status_type":/status_type, "progress_type":/progress_type, "sale_type":/sale_type, "company_detail": company_detail,  "contact_person" : /contact_person, "building_name": /building_name, "user_id":/user_id, "access_token": /access_token ]
            
        case .checkInAttributes(_):
            return ["access_token" : /Singleton.shared.userData?.profile?.access_token]
            
        case .getUserProfile(_):
            return ["access_token" : /Singleton.shared.userData?.profile?.access_token]
            
        case .userDayOut(_):
            return ["access_token" : /Singleton.shared.userData?.profile?.access_token]
            
        case .updateProfile(let fullName, let address, _):
            return ["fullname": fullName, "address": address, "access_token" : /Singleton.shared.userData?.profile?.access_token]
            
        case .logout:
            return ["access_token" : /Singleton.shared.userData?.profile?.access_token]
            
        case .getCheckIns(let date):
            return ["access_token" : /Singleton.shared.userData?.profile?.access_token, "checkin_date": /date]
            
        case .getCheckInDetails(let id):
            return ["access_token" : /Singleton.shared.userData?.profile?.access_token, "checkinid": /id]
            
        case .addClient(let name,let c_name,let  mobile,let  visit_motive, let emails_id, let lati ,let lng,let address):
            return ["access_token" : /Singleton.shared.userData?.profile?.access_token, "name": /name, "c_name":/c_name, "mobile":/mobile, "visit_motive":/visit_motive, "emails_id":/emails_id, "lati": /lati, "lng":/lng , "address":/address]
            
        case .listClient:
            return ["access_token" : /Singleton.shared.userData?.profile?.access_token]
            
        case .logInteraction(let client_id,_,let  answer):
            return ["access_token" : /Singleton.shared.userData?.profile?.access_token, "client_id":/client_id, "answer":answer ]
            
        case .searchBuilding(let search):
            return ["access_token" : /Singleton.shared.userData?.profile?.access_token,"search": /search]
            
        case .updateBuilding( let building_id, let source_lat,let  source_lng, let location, let building_type, let status_type,let  progress_type,let sale_type,let  company_detail,let contact_person,let building_name, let user_id, let access_token, _,let deletedImageIds) :
            return ["source_lat":/source_lat, "source_lng":/source_lng, "location":/location, "building_type":/building_type, "status_type":/status_type, "progress_type":/progress_type, "sale_type":/sale_type, "company_detail": company_detail,  "contact_person" : /contact_person, "building_name": /building_name, "user_id":/user_id, "access_token": /access_token, "building_id": /building_id,"delete_image":/deletedImageIds ]
        }
    }
    
    func request<T>(showLoader: Bool, response: @escaping (Result<T?, ResponseStatus>) -> Void) where T : Mappable {
        fetch(showLoader: showLoader, target: self, response: response)
    }
    
    func requestCodable<T>(showLoader: Bool, response: @escaping (Result<T?, ResponseStatus>) -> Void) where T : Decodable, T : Encodable {
        fetchCodable(showLoader: showLoader, target: self, response: response)
    }
}
