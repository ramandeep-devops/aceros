//
//  APIRequest.swift
//  BartAcTransit
//
//  Created by Paradox on 07/03/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//


import Moya
import Foundation
import ObjectMapper


protocol APIRequest {
    var parameters:[String:Any] { get }
    var verbose:Bool { get }

    func request<T: Mappable>(showLoader:Bool, response: @escaping ResultCallback<T?,ResponseStatus>)
    func fetch<ENDPOINT: TargetType, OUTPUT: Mappable>(showLoader:Bool, target: ENDPOINT, response: @escaping ResultCallback<OUTPUT?,ResponseStatus>)
    func requestCodable<T:Codable>(showLoader:Bool, response: @escaping ResultCallback<T?,ResponseStatus>)
    func showLoader()
    func hideLoader()
    
    //    func request<T: Mappable>(showLoader:Bool, decode: @escaping (Mappable?)->T?, response: @escaping ResultCallback<T?,ResponseStatus>)
    //    func fetch<ENDPOINT: TargetType, OUTPUT: Mappable>(showLoader:Bool, target: ENDPOINT, output: OUTPUT, response: @escaping (OUTPUT?,ResponseStatus?)->())
}
var requests: [Cancellable] = []


extension APIRequest {
    
    //MARK: - Print output in console
    var verbose:Bool { get { return true } }

    
    //MARK: - API Request
    func fetch<ENDPOINT: TargetType, OUTPUT: Mappable>(showLoader:Bool, target: ENDPOINT, response: @escaping ResultCallback<OUTPUT?,ResponseStatus>) {
        
        let provider = MoyaProvider<ENDPOINT>(plugins: [NetworkLoggerPlugin(verbose: verbose, responseDataFormatter: JSONResponseDataFormatter)])
        
        if showLoader { self.showLoader() }
        
      let req =   provider.request(target.self) { (result) in
            
            if showLoader { self.hideLoader() }
            
            switch result {
            case .success(let moyaResponse): //Request Success
                
                switch moyaResponse.statusCode {
                case 200, 201:
                    debugPrint("Success")
                    response(.success(data: Mapper<OUTPUT>().map(JSONObject: JSONResponseDicionary(moyaResponse.data))))
                    
                case 401:
                    debugPrint("Session expire")
                    requests.forEach({ (item) in
                        item.cancel()
                    })
                    requests.removeAll()
                    
                    response(.failure(error: ResponseStatus.sessionExpire))
             
                    
                case 500...599:
                    debugPrint("Internal server error")
                    response(.failure(error: ResponseStatus.internalServerError))
                    
                default:
                    debugPrint("request error")
                    
                    let dict = JSONResponseDicionary(moyaResponse.data)
                    if let errMsg = dict["msg"] as? String {
                        response(.failure(error: ResponseStatus.clientError(message: errMsg)))
                    }
                    else{
                        response(.failure(error: ResponseStatus.clientError(message: "Something went wrong!!")))
                    }
                   
                }
                
            case .failure(let error): //Request Failure
                response(.failure(error: .underLying(error: error)))
            }
        }
        
        requests.append(req)
        
        
    }
    
    func fetchCodable<ENDPOINT: TargetType, OUTPUT: Codable>(showLoader:Bool, target: ENDPOINT, response: @escaping ResultCallback<OUTPUT?,ResponseStatus>) {
        
        let provider = MoyaProvider<ENDPOINT>(plugins: [NetworkLoggerPlugin(verbose: verbose, responseDataFormatter: JSONResponseDataFormatter)])
        
        if showLoader { self.showLoader() }
        
        provider.request(target.self) { (result) in
            
            if showLoader { self.hideLoader() }
            
            switch result {
            case .success(let moyaResponse): //Request Success
                
                switch moyaResponse.statusCode {
                case 200, 201:
                    debugPrint("Success")
                    do{
                        let decoder = JSONDecoder()
                        let respData = try decoder.decode(OUTPUT.self, from: moyaResponse.data)
                        response(.success(data: respData))
                    }
                    catch{
                        debugPrint("Success catch")
                    }
                    
                case 401:
                    
                    debugPrint("Session expire")
                    self.logOut()
                    response(.failure(error: ResponseStatus.sessionExpire))
                    
                case 500...599:
                    debugPrint("Internal server error")
                    response(.failure(error: ResponseStatus.internalServerError))
                    
                default:
                    debugPrint("request error")
                    
                    let dict = JSONResponseDicionary(moyaResponse.data)
                    if let errMsg = dict["msg"] as? String {
                        response(.failure(error: ResponseStatus.clientError(message: errMsg)))
                    }
                }
                
            case .failure(let error): //Request Failure
                response(.failure(error: .underLying(error: error)))
            }
        }
    }
    
    //MARK: - Logout
    fileprivate func logOut() {
        Singleton.shared.userData = nil
        if !(/UIApplication.topViewController()?.isKind(of:LoginViewController.self)){
            guard let vc = R.storyboard.login.loginViewController() else { return }
            UIApplication.topViewController()?.pushVC(vc)
        }
        
        
    }
}

