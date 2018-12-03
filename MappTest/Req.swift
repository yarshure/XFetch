//
//  Req.swift
//  MappTest
//
//  Created by yarshure on 3/12/2018.
//  Copyright © 2018 yarshure. All rights reserved.
//

import Foundation
class LoginReqModel:Codable {
    var appOs:String = "iOS"////应用系统
    
    var imei:String = "string"////设备识别码
    var appVer:String = "1"////应用版本号
    
    var iccid:String = "string"////SIM卡标识
    
    var imsi:String = "string"////用户标识
    var randomStr:String = "string"
    var sign:String = "00000000"
    var mobileNum:String = ""////手机号码
    var fcmId:String = ""////Firebase云消息ID
    var password:String = ""////登录密码
   var sessionId:String = "string"
     func updateSign() -> Data {
        let newp = DataCache.shared.doEncrypto(self.password)
       // self.fcmId = "string"//DataCache.shared.fcmToken
        self.password = newp
        let enc = JSONEncoder()
        do {
            let r = try enc.encode(self)
            return r
        }catch let e {
            print(e)
        }
        return Data()//self.toJSON()
    }
}
struct LoginRespModel:Codable {
    var sessionId:String = ""////会话ID
    var respMsg:String = ""////返回状态说明
    var respCode:String = ""////返回状态码
    var signKey:String = ""////会话签名密钥
}
