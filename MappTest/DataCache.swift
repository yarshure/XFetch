//
//  DateCache.swift
//  UnionpayInt
//
//  Created by yarshure on 10/30/18.
//  Copyright © 2018 yarshure. All rights reserved.
//

import UIKit
import SwiftyRSA
import SwiftyJSON
class DataCache {
    static let shared = DataCache()
    
    var fcmToken:String = ""
    var sessionId:String = ""
   
    var json:JSON?
    
    init() {
        do {
            
            
            guard  let path =  Bundle.main.path(forResource: "currency.json", ofType:nil) else{
                return
            }
            let data = try Data.init(contentsOf: URL.init(fileURLWithPath: path))
        
           self.json = try JSON(data: data)
        }catch let e {
            print(e)
        }
     
    }
    func currency(key:String) ->String{
        if let j = json {
            return j[key].stringValue
        }
        return "¥"
    }
    func doEncrypto(_ pin:String) ->String {
        var  pub:String
        if self.isWalletApp() {
            pub =  "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoAAiW/x+suQEQXoqeKuY1aLwybfgQghcNYMvwK6M3l0uS64EUbTVPyX8lNStN+tHH1dOPfsnC68sZTEOH5h6wp85TFwiQOrfOvvZ04Ewz/rK+KNxz0ZQsU9YVjKxu1SJro7K9GnN9gR9XS1QM76ZXy9KSUUehDRzUsk4Il4B3dSi2b6Ni/c1Qbw3krHRBd1nhbJiVErO0T0CTF4xZzJErzEZz/YGF06ZEeSV8dlPAZ80gJkNEbO/MNOht9wYQRab6mhE3eeUMmzd8zcynBQlAIa4NoX/1+XST6xT9Yxjt3K8sovZreSF3c1KNi+9WFEjhy5icFeXGYLJ2V0FZW7SmQIDAQAB"
        }else {
            pub = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnW4GQaaX5TqvamTLZZoNl2gT/B//Iv6kD9bEhkayhlH2pg6Xz7bF2TUyxQsKwNYQDDJLW4LKiAay2JzYM/EhOzrxQdqUimaDYuI8vLJT0qk+JylnGREoHU+fRb4vwYj/PW+4mC1Uz1CARtb/lIxS7+5snDX8e0NKjrHbTOKEm2l7041nXCqq/x33HBPQuWmhKzRd2hK4bxdANn6cn/ORb2ZlQoDOxsAVX7Vk5f1hW2iIPrUnNS/UHPcJ5XiAtUGA5CiY+4CBcdMn4zhqAhPDrlOpb2JGKwzfYzURqgf4b6PkRfzVBsvNhF9Ey9SfOetDRrMFc9WbMW33cES6c3+vDQIDAQAB"
        }
       
       
        
        guard let pubdata = Data.init(base64Encoded: pub, options: .ignoreUnknownCharacters) else {return ""}
        
        //let stringData =  pub.data(using: .utf8, allowLossyConversion: true)
        do {
            let publicKey = try PublicKey.init(data: pubdata)
            let clear = try ClearMessage(string: pin, using: .utf8)
            let encrypted = try clear.encrypted(with: publicKey, padding: .PKCS1)
            
            // Then you can use:
            //let data = encrypted.data
            let base64String = encrypted.base64String
            return base64String
        }catch let e {
            print(e)
        }
        return ""
    }


    func isWalletApp() ->Bool {
        return true
//         let bId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
//        if bId == "com.yarshure.UnionpayInt2" {
//            return true
//        }
//        return false
    }
    func shopperGetBandCard(){
        let bId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        let uu = "cards://list?calback=client&appid=" + bId
        let u = URL.init(string: uu)!
        if UIApplication.shared.canOpenURL(u) {
            UIApplication.shared.open(u, options: [:]) { (f) in
                print("OK")
            }
        }
    }
 


}
