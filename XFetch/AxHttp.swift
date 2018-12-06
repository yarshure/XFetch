//
//  AxHttpProtocol.swift
//  TestQoodApi
//
//  Created by peng(childhood@me.com) on 15/6/19.
//  Copyright (c) 2015年 peng(childhood@me.com). All rights reserved.
//

import Foundation
//import SwiftyJSON
//import ObjectMapper
import Just
public enum HTTPMethod:CustomStringConvertible{
    public var description: String {
        switch self {
        case .post:
            return "post"
        case .get:
            return "get"
        case .put:
            return "put"
        default:
            return "delete"
        }
    }
    
    case post
    case get
    case put
    case delete
    
}
public enum EABasePath:String {
    case api = "/api"
  
}
public class AxHttpParameter:NSObject{
    
    var baseURL:String?
   // var attr:String = "nodata" //用来parser json
    var path:String=""
    var basePath:EABasePath
    var httpMethod:HTTPMethod = .post
    var paras:[String:AnyObject]=[:]
    var headers:[String:String]=[:]
    public init(path:String,method:HTTPMethod,basePath:EABasePath ){
        self.path = path
        self.httpMethod = method
        self.basePath = basePath
        super.init()
//        let hime:String =  "354855021748748"
//        self.addHeaderKey("h-ime",value:hime)
//        let hims:String =   "460023192787105" //UserCache.share.phone//
//        self.addHeaderKey("h-ims",value:hims)
//        let hnoncestr:String =  "a475f0a7e1bc773521de494403b6ce19"
//        self.addHeaderKey("h-nonce-str",value:hnoncestr)
//        let hsign:String =  "cd6a1a15421189de23d7309feebff8d7"
//        self.addHeaderKey("h-sign",value:hsign)
//        let hsigntype:String =  "MD5"
//        self.addHeaderKey("h-sign-type",value:hsigntype)
//        let hversion:String =  "1.0"
//        self.addHeaderKey("h-version",value:hversion)
//        self.addHeaderKey("api_key", value: "api_key")
        
//        var imei:String = ""////设备识别码
//        var iccid:String = ""////SIM卡标识
//        var imsi:String = ""////用户标识
        
    }
   public func addHeaderKey(_ key:String, value:String){
        if (!key.isEmpty) && (!value.isEmpty){
            self.headers[key]=value
        }
    }
    
    public func addParaKey<T>(_ key:String, value:T){
        if (!key.isEmpty) {
            self.paras[key] =  value as AnyObject?

        }
    }

    
    override public var description: String {
        return "path:\(path),method:\(httpMethod),paras:\(paras),headers:\(headers)"
    }
}
internal extension Dictionary {
    mutating func merge<K, V>(_ dictionaries: Dictionary<K, V>...) {
        for dict in dictionaries {
            for (key, value) in dict {
                self.updateValue(value as! Value, forKey: key as! Key)
            }
        }
    }
}
extension AxHttpParameter{
    func fullPath(_ basestr:String) -> String{
        
        
        if let b = baseURL {
            //let x = b as NSString
            return  b  + self.basePath.rawValue + self.path
        }else {
            //let x = basestr + "/" +  self.basePath.description
            return  basestr  + self.basePath.rawValue + self.path
            
        }
        
    }
    func fullHeaders(_ systemHeader:[String:String]) ->[String:String]{
        self.headers.merge(systemHeader)
        return self.headers
    }
}
extension String {
    func stringByAddingPercentEncodingForFormUrlencoded() -> String{
        let ssString = self as NSString
        return ssString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!;
        
    }
}
class  AxJust{
    static func processHttpResonse(_ r:HTTPResult,onSuccess:(_ responseString:AnyObject?)->Void, onFail:(_ httpCode:Int?,_ reason:String?,_ responseString:AnyObject?)->Void){
        if r.ok{
            if r.content != nil {
                onSuccess(r.content as AnyObject?)
            }else {
                onSuccess(r.json as AnyObject?)
            }
            
        }else{
            onFail(r.statusCode,r.reason,r.json as AnyObject?)
        }
    }
    static func doJustHttpWithPara(_ url:String,method:HTTPMethod,para:[String:AnyObject],headers:[String:String], onSuccess:@escaping (_ response:AnyObject?)->Void, onFail:@escaping (_ httpCode:Int?,_ reason:String?,_ responseString:AnyObject?)->Void){
        let u = url.stringByAddingPercentEncodingForFormUrlencoded()
        switch method{
        case .get:
            Just.get(u, params:para, headers:headers,timeout:EAApiConsts.apiTimeoutTime) { r in self.processHttpResonse(r,onSuccess:onSuccess,onFail:onFail) }
        case .post:
            if let jsonDict = para["json"] {
                 Just.post(u,json:jsonDict, headers:headers,timeout:EAApiConsts.apiTimeoutTime){ r in self.processHttpResonse(r,onSuccess:onSuccess,onFail:onFail) }
            }else if let requestBody = para["requestBody"]{
                Just.post(u,headers:headers, timeout:EAApiConsts.apiTimeoutTime, requestBody:(requestBody as! Data)){ r in self.processHttpResonse(r,onSuccess:onSuccess,onFail:onFail) }
            } else {
                
                Just.post(u,data:para,headers:headers,timeout:EAApiConsts.apiTimeoutTime){ r in self.processHttpResonse(r,onSuccess:onSuccess,onFail:onFail) }
            }
            
        case .put:
            Just.put(u,data:para,headers:headers,timeout:EAApiConsts.apiTimeoutTime){ r in self.processHttpResonse(r, onSuccess: onSuccess, onFail: onFail) }
        case .delete:
            Just.delete(u,headers:headers,timeout:EAApiConsts.apiTimeoutTime){r in self.processHttpResonse(r, onSuccess: onSuccess, onFail: onFail) }
       
        }
    }
}

  open  class AxHttp:NSObject{
    @objc static var baseUrl:String = EAApiConsts.serverUrl
    @objc static var globalHeaders:[String:String]=[:]
    @objc static var unAuthCb:(() ->Void)?
    @objc static var logCb:((_ msg:String,_ file:String,_ line:Int,_ time:Date)->Void)?
    @objc static var isDebugOn:Bool = true
    
    static func log(_ msg:String,file:String=#file,line:Int=#line,time:Date=Date()){
        if let logcb = self.logCb{
            logcb(msg,file,line,time)
        }
    }
    
    static func setHeaderValue(_ value:String, forKey:String){
        if (!value.isEmpty) && (!forKey.isEmpty){
            self.globalHeaders[forKey]=value
        }
        
        
    }
    static func logPara(_ para:AxHttpParameter){
        if self.isDebugOn{
            self.log("http para:\(para)")
        }
    }
    static func logResponse(_ resp:AnyObject?){
        if self.isDebugOn{
            self.log("http response:\(String(describing: resp))")
        }
    }
    static func callUnAuthCb(){
        if  let unAuthCb = AxHttp.unAuthCb{
            unAuthCb()
        }
    }
    
    
    public static func doHttpWithPara<T:Decodable>(_ para:AxHttpParameter, onSuccess:@escaping (_:T?,EAApiError?)->Void){
        self.logPara(para)
        let url = para.fullPath(baseUrl)
    
        AxJust.doJustHttpWithPara(url, method: para.httpMethod, para: para.paras as [String : AnyObject], headers: para.fullHeaders(globalHeaders), onSuccess: {
            responseJson in
            if let data = responseJson as? Data {
                let decoder = JSONDecoder()
                let t = try! decoder.decode(T.self, from: data)
                DispatchQueue.main.async{onSuccess(t,nil)}
                
                
            }else {
                 let decoder = JSONDecoder()
                if let objJson = responseJson as? [String:AnyObject]{
                    
                }
                let x = try! decoder.decode(T.self, from: Data())
                DispatchQueue.main.async{onSuccess(x,nil)}
            }
        }, onFail: {
            httpCode,reason,responseJson in
            let error = EAApiError()
            
            if let r = reason {
                error.reason = r
            }
            DispatchQueue.main.async{onSuccess(nil,error)}
        })
    }
    public static func doHttpWithPara<T:Decodable>(_ para:AxHttpParameter, onSuccess:@escaping (_:[T]?,EAApiError?)->Void){
        self.logPara(para)
        AxJust.doJustHttpWithPara(para.fullPath(baseUrl), method: para.httpMethod, para: para.paras as [String : AnyObject], headers: para.fullHeaders(globalHeaders), onSuccess: {
            responseJson in
            self.logResponse(responseJson)
            
            DispatchQueue.main.async{onSuccess(nil,nil)}
        }, onFail: {
            httpCode,reason,responseJson in
            let error = EAApiError()
            
            if let r = reason {
                error.reason = r
            }
            DispatchQueue.main.async{onSuccess(nil,error)}
        })
    }
    public static func doHttpWithPara<T:Decodable>(_ para:AxHttpParameter, onSuccess:@escaping (_:[T]?,EAApiError?)->Void,objMapper: @escaping (_ json:AnyObject?)->[T]?){
        self.logPara(para)
        AxJust.doJustHttpWithPara(para.fullPath(baseUrl), method: para.httpMethod, para: para.paras as [String : AnyObject], headers: para.fullHeaders(globalHeaders), onSuccess: {
            responseJson in
            self.logResponse(responseJson)
            let obj = objMapper(responseJson)
            DispatchQueue.main.async{onSuccess(obj,nil)}
        }, onFail: {
            httpCode,reason,responseJson in
            let error = EAApiError()
            
            if let r = reason {
                error.reason = r
            }
            DispatchQueue.main.async{onSuccess(nil,error)}
        })
    }
    public static func doHttpWithPara<T:Decodable>(_ para:AxHttpParameter, onSuccess:@escaping (_:T?,EAApiError?)->Void,objMapper: @escaping (_ json:AnyObject?)->T?){
        self.logPara(para)
        AxJust.doJustHttpWithPara(para.fullPath(baseUrl), method: para.httpMethod, para: para.paras as [String : AnyObject], headers: para.fullHeaders(globalHeaders), onSuccess: {
            responseJson in
            self.logResponse(responseJson)
            let obj = objMapper(responseJson)
            DispatchQueue.main.async{onSuccess(obj,nil)}
        }, onFail: {
            httpCode,reason,responseJson in
            let error = EAApiError()
            
            if let r = reason {
                error.reason = r
            }
            DispatchQueue.main.async{onSuccess(nil,error)}
        })
    }
    public static func doHttpWithPara<T:Decodable>(_ para:AxHttpParameter, onSuccess:@escaping (_:[T]?,EAApiError?)->Void,objMapper: @escaping (_ json:AnyObject?)->T? ){
        self.logPara(para)
        AxJust.doJustHttpWithPara(para.fullPath(baseUrl), method: para.httpMethod, para: para.paras as [String : AnyObject], headers: para.fullHeaders(globalHeaders), onSuccess: {
            responseJson in
            self.logResponse(responseJson)
            let obj = objMapper(responseJson)
            DispatchQueue.main.async{onSuccess(obj as? [T],nil)}
        }, onFail: {
            httpCode,reason,responseJson in
            let error = EAApiError()
            
            if let r = reason {
                error.reason = r
            }
            DispatchQueue.main.async{onSuccess(nil,error)}
        })
    }
    public static func doHttpWithPara(_ para:AxHttpParameter, onSuccess:@escaping (_:AnyObject?,EAApiError?)->Void){
        self.logPara(para)
        AxJust.doJustHttpWithPara(para.fullPath(baseUrl), method: para.httpMethod, para: para.paras as [String : AnyObject], headers: para.fullHeaders(globalHeaders), onSuccess: {
            responseJson in
            self.logResponse(responseJson)
            if let objJson=responseJson as? [String:AnyObject]{
                DispatchQueue.main.async{onSuccess(objJson as AnyObject,nil)}
            }else{
                DispatchQueue.main.async{onSuccess(nil,nil)}
            }
        }, onFail: {
            httpCode,reason,responseJson in
            let error = EAApiError()
            
            if let r = reason {
                error.reason = r
            }
            DispatchQueue.main.async{onSuccess(nil,error)}
        })
    }
    public static func downloadFile(_ url:String,toPath:String,timeout:Double = EAApiConsts.apiTimeoutTime,progress:((Double)->Void)?=nil,complete:@escaping (Bool)->Void){
        
        Just.get(url, timeout: timeout, asyncProgressHandler: {
            p in
            if let progress = progress{
                progress(Double(p.percent))
            }
        }){
            r in
            if r.ok{
                if let content = r.content{
                    //content.writeToFile(toPath, atomically: true)
                    let u = URL.init(fileURLWithPath: toPath)
                    try! content.write(to: u)
                    
                    complete(true)
                }else{
                    self.log("error,empty content,\(String(describing: r.response))")
                    complete(false)
                }
            }else{
                self.log("download file error:\(r.reason,r.error)")
                complete(false)
            }
        }
    }
    public static func uploadFile(_ url:String,filename:String,file:String,headers:[String:String],para:[String:AnyObject],timeout:Double = EAApiConsts.apiTimeoutTime,progress:((Double)->Void)?=nil,complete:@escaping (Bool)->Void){
        //        if let fileurl = NSURL(fileURLWithPath: file){
        //            Just.post(url, headers: headers,data:para, files: [filename:HTTPFile.URL(fileurl,nil)], timeout: timeout, asyncProgressHandler: {
        //                p in
        //                if let progress = progress{
        //                    progress(Double(p.percent))
        //                }
        //            }){
        //                r in
        //                if r.ok{
        //                    complete(true)
        //                }else{
        //                    self.log("upload file error:\(headers,r.url,r.reason,r.error,r.text)")
        //                    complete(false)
        //                }
        //            }
        //        }
        
        let fileurl = URL(fileURLWithPath: file)
        Just.post(url, data:para,headers: headers, files: [filename:HTTPFile.url(fileurl,"")], timeout: timeout, asyncProgressHandler: {
            p in
            if let progress = progress{
                progress(Double(p.percent))
            }
        }){
            r in
            if r.ok{
                complete(true)
            }else{
                self.log("upload file error:\(headers,r.url,r.reason,r.error,r.text)")
                complete(false)
            }
        }
    }
}
