

import UIKit
import SwiftMessages

typealias AlertBlock = (_ success: AlertTag) -> ()

enum Alert : String{
    case success = "Success"
    case oops = "Error "
    case login = "Login Successfull"
    case ok = "Ok"
    case cancel = "Cancel"
    case error = "Error"
    case newAppointment = "You have a new request for a service"
    case sorry = "Sorry"
    case emp = ""
    case scan = "BLE Scan"
    case noPropertyFound = "No property found"
}

enum AlertTag {
    case done
    case yes
    case no
}

class Alerts: NSObject {
    
    static let shared = Alerts()
    
    func showAlertOnTop(type: Theme, title: String,message: String, layout: MessageView.Layout){
        let view = MessageView.viewFromNib(layout: layout)
        switch type {
        case .warning:
            view.configureTheme(.warning)
            view.configureContent(title: title, body: message)
            view.button?.isHidden = true
            view.configureDropShadow()
            
        default:
            debugPrint("dfad")
        }
        
        SwiftMessages.show(view: view)
    }
    
    func runThisAfterDelay(seconds: Double, after: @escaping () -> Void) {
        runThisAfterDelay(seconds: seconds, queue: DispatchQueue.main, after: after)
    }
    
    func runThisAfterDelay(seconds: Double, queue: DispatchQueue, after: @escaping () -> Void) {
        let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        queue.asyncAfter(deadline: time, execute: after)
    }
    
}


//MARK:- PROTOCOL
protocol OptionalType { init() }





