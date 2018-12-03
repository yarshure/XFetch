//
//  APITest.swift
//  MappTest
//
//  Created by yarshure on 3/12/2018.
//  Copyright © 2018 yarshure. All rights reserved.
//

import Foundation
class API:AxHttp {
    //Desc 用户登录
    static func login(req:LoginReqModel,onSuccess:@escaping (_:LoginRespModel)->Void, onFail:@escaping (_ response:EAApiError?)->Void){
        let para = AxHttpParameter(path: "/user/login", method: .post, basePath: .api)
        para.addParaKey("requestBody", value: req.updateSign())
        para.addHeaderKey("content-type", value: "application/json")
        self.doHttpWithPara(para, onSuccess: onSuccess , onFail: onFail)
    }
}
