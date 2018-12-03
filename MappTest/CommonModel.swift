//
//  CommonModel.swift

//

import Foundation
import ObjectMapper
open class CommonModel:NSObject,Mappable{
    static var defaultDate:Date = EAApiConsts.apiModelDefaultDate 
    static var defaultDateTransform:DateFormatterTransform = CustomDateFormatTransform(formatString: EAApiConsts.apiDataFormatStr)
    static var defaultUrlTransform:URLTransform = URLTransform()
    
    var dateTransform:DateFormatterTransform{
        return CommonModel.defaultDateTransform
    }
    override open func copy() -> Any {
        if let asCopying = ((self as AnyObject) as? NSCopying) {
            return asCopying.copy(with: nil)
        }else {
            return CommonModel()
        }
        
    }
    var urlTransform:URLTransform{
        return CommonModel.defaultUrlTransform
    }
    @objc var errorCode:Int = 0
    @objc var errMsg:String = ""
    @objc var code:String = ""
    @objc var msg:String = ""
    open func mapping(map: Map){
//        errorCode <- (map["h_err_code"], TransformOf<Int, NSNumber>(fromJSON: { $0?.intValue}, toJSON: { $0.map { NSNumber(value: $0) } }))
//        
//        
//        errMsg <- map["h_err_msg"]
//        
//        msg <- map["msg"]
//        code <- map["h_err_code"]
    }
    
    override init(){super.init()}
    public required init?(map: Map) {
        super.init()
        self.mapping( map: map)
    }
    override open var description:String{
        if let str=self.toJsonString(){ return str }else{ return "\(super.description)"}
    }
    open func toJsonString() -> String?{
        return Mapper().toJSONString(self, prettyPrint: true)
    }
    open func toDictionary() -> [String:Any]?{
        return Mapper().toJSON(self)
    }
    public static func fromDictionary<T:Mappable>(_ dict:Any?) ->T?{
        return Mapper<T>().map(JSON:dict as! [String : Any])
    }
}

extension NSArray{
    func toArrayDictionary() ->[NSDictionary]{
        if let arr:[CommonModel] = {(self as [AnyObject]).filter{$0 is CommonModel} as? [CommonModel]}(){
            let x=Mapper<CommonModel>().toJSONArray(arr)
            return x as [NSDictionary]
        }
        return []
    }
    func toJsonString() -> String?{
        let x=self.toArrayDictionary()
        if let jsondata=try? JSONSerialization.data(withJSONObject: x, options: JSONSerialization.WritingOptions.prettyPrinted),let jsonstr = NSString(data: jsondata, encoding: String.Encoding.utf8.rawValue){
            return jsonstr as String
        }
        return nil
    }
    static func fromArrayDictionary<T:Mappable>(_ objs:Any?) -> [T]?{
        return Mapper<T>().mapArray(JSONObject:objs)
    }
}
