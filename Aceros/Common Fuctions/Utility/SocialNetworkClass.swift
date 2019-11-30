//
//
//import UIKit
//import FBSDKLoginKit
//import FBSDKCoreKit
////import EZSwiftExtensions
//import SwiftyJSON
//import GoogleSignIn
//import Material
//import NVActivityIndicatorView
//import ObjectMapper
//
//
//typealias SuccessBlock = (_ fbId: String?,_ first : String?,_ last : String?, _ email : String?,_ img : URL? ) -> ()
//typealias responseBlock = (_ result: Any? ) -> ()
//
//class SocialNetworkClass: NSObject, GIDSignInDelegate,NVActivityIndicatorViewable{
//    
//    static let shared = SocialNetworkClass()
//    var responseBack : SuccessBlock?
//    var response : responseBlock?
//    //let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "78bvjrqlymesy1",clientSecret: "WRRXCtS2yQEJFFCy",state: "987654321",permissions: ["r_basicprofile","r_emailaddress"],redirectUrl: "https://www.example.com/auth/linkapp"))
//    
//    //MARK: Facebook
//    
//    func facebookLogin(responseBlock : @escaping SuccessBlock) {
//        
//        responseBack = responseBlock
//        
//        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
//        fbLoginManager.logOut()
//        Utility.shared.hideLoader()
//        
//        fbLoginManager.logIn(withReadPermissions: ["email","public_profile","user_friends"],from: UIApplication.getTopMostViewController(), handler: {[weak self] (result, error) -> Void in
//            if (error == nil){
//                if let fbloginresult = result{
//                    if(fbloginresult.isCancelled) {
//                        Utility.shared.hideLoader()
//                    } else if(fbloginresult.grantedPermissions.contains("email")) {
//                        self?.handleFbResult()
//                    }
//                    else{
//                        Utility.shared.hideLoader()
//                        self?.handleFbResult()
//                        
//                        
//                      //  UtilityFunctions.showAlertMessage(alert: "", message: "Email permissions are restricted from Facebook. Please provide email permissions to proceed", viewController: /UIApplication.getTopMostViewController(), buttonText: StaticStrings.ok.rawValue)
//                    }
//                }else{Utility.shared.hideLoader()}
//            }else{Utility.shared.hideLoader()}
//        })
//        
//    }
//    
//    
//    func handleFbResult()  {
//        
//        if (FBSDKAccessToken.current() != nil){
//            
//            Utility.shared.showLoader()
//            
//            FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields": "id, first_name, last_name,email,picture.width(300).height(300)"]).start(completionHandler: {[weak self] (connection, result, error) in
//                
//                self?.hanleResponse(result:(result as AnyObject?))
//            })
//        }else{Utility.shared.hideLoader()}
//        
//    }
//    
//    
//    func hanleResponse(result : AnyObject?)
//    {
//        if let dict = result as? Dictionary<String, AnyObject>{
//            let response = JSON(dict)
//            let facebookId = dict["id"] as? String
//            let email = dict["email"] as? String
//            let first = dict["first_name"] as? String
//            let last = dict["last_name"] as? String
//            let imageUrl = response["picture"]["data"]["url"].url
//            
//            self.responseBack?(facebookId,first,last,email,imageUrl)
//            
//        }else{
//            Utility.shared.hideLoader()
//            
//        }
//    }
//    
//    
//    //Mark:- LinkedIn
//    
////    func linkedinLogin(responseBlock : @escaping responseBlock)
////    {
////        response = responseBlock
////
////        linkedinHelper.authorizeSuccess({(lsToken)  ->  Void in
////            self.requestForDetails()
////
////        }, error: {  (error) -> Void in
////            Utility.shared.removeLoader()
////
////        }, cancel: { () -> Void in
////
////            debugPrint("User cancelled" )
////            Utility.shared.removeLoader()
////        })
////    }
//    
////    func requestForDetails()
////    {
////        linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions)?format=json",requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
////            
////            let json = JSON((response as LSResponse).jsonObject)
////            
////            do {
////                if let response = self.response{
////                    response(try SocialLoginModal(attributes: json.dictionaryValue))
////                }
////            } catch _ {}
////            
////            
////        })
////        { (error) -> Void in
////            Utility.shared.removeLoader()
////        }
////        
////    }
//    
//    //MARK: Google
//    
//    func googleLogin(responseBlock : @escaping SuccessBlock){
//      
//        responseBack = responseBlock
//        GIDSignIn.sharedInstance().delegate = self
// 
//        
//    }
//    
//    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
//        if (error == nil) {
//            Utility.shared.showLoader()
//            
//            let googleId = user.userID
//            let email = user.profile.email
//            let first = user.profile.givenName
//            let last = user.profile.familyName
//            let imageUser = user.profile.imageURL(withDimension: 100)
//            
//            self.responseBack?(googleId,first,last,email,imageUser)
//            
//        } else {
//            debugPrint(error.localizedDescription)
//            Utility.shared.hideLoader()
//        }
//    }
//    
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
//              withError error: Error!) {
//    }
//    
//    
//    // Present a view that prompts the user to sign in with Google
//    func sign(_ signIn: GIDSignIn!,
//              present viewController: UIViewController!) {
//         viewController.view.layoutIfNeeded()
//
// 
//        UIApplication.getTopMostViewController()?.present(viewController, animated: true, completion: nil)
//    }
//    
//    // Dismiss the "Sign in with Google" view
//    func sign(_ signIn: GIDSignIn!,
//              dismiss viewController: UIViewController!) {
//        UIApplication.getTopMostViewController()?.dismiss(animated: true)
//    }
//    
//    
//
//    
//    
//}
//
