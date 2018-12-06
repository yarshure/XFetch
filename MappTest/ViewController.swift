//
//  ViewController.swift
//  MappTest
//
//  Created by yarshure on 3/12/2018.
//  Copyright © 2018 yarshure. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let req = LoginReqModel()
        req.password = "222222"
        req.mobileNum = "111222"
        req.fcmId = "string"
        API.login(req: req, onSuccess: { (resp,e) in
            if let e = e {
                print(e)
            }
            guard let resp = resp else {return}
            print(resp.respCode)
        }) 
        print(req)
        // Do any additional setup after loading the view, typically from a nib.
    }


}

