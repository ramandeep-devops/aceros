//
//  Login+API.swift
//  Electric_Scanner
//
//  Created by Paradox on 18/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//


import Moya
import Foundation
import ObjectMapper

enum LoginTarget {
    case login(username: String, password: String)
    case passwordReset(email: String)
}

extension LoginTarget: TargetType, APIRequest {
    
    var baseURL: URL {
        return URL(string: APIConstants.basepath)!
    }
    
    var path: String {
        switch self {
        case .login(_): return APIConstants.login
        case .passwordReset(_): return APIConstants.passwordReset
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
        default: return .requestParameters(parameters: self.parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var parameters: [String : Any] {
        switch self {
        case .login(let username, let password):
            return ["phone": username, "password": password]
            
        case .passwordReset(let email):
            return ["email": email]
       
        }
    }
    
    func request<T:Mappable>(showLoader: Bool, response: @escaping (Result<T?, ResponseStatus>) -> Void) {
        fetch(showLoader: showLoader, target: self, response: response)
    }
    
    func requestCodable<T>(showLoader: Bool, response: @escaping (Result<T?, ResponseStatus>) -> Void) where T : Decodable, T : Encodable {
        fetchCodable(showLoader: true, target: self, response: response)
    }
    
}
