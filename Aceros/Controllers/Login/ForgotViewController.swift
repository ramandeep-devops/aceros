//
//  ForgotViewController.swift
//  Aceros
//
//  Created by Apple on 25/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ForgotViewController: UIViewController {
    
    @IBOutlet weak var tfPhone: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionSend(_ sender: Any) {
    }
    
    @IBAction func actionBack(_ sender: Any) {
        UIApplication.topViewController()?.popVC()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
