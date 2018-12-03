
import Foundation
import ObjectMapper
open class EAApiError:Codable{
    var HTTPCode:Int = 200
    var epResultCode:Int = 0
    var desp:String {
        return ""
    }
  //  var para:AxHttpParameter!
    var epErrorMsg:String=""

    var reason:String = ""
    //var timestamp:Date=defaultDate as Date
    
    var respMsg:String = ""////返回状态说明
    var respCode:String = ""////返回状态码
    var message:String = ""

}
//extension EAApiError{
//    open  var description: String {
//        if HTTPCode != 200 {
//            
//            return para.basePath.rawValue + para.path + ":\(reason):"  + respMsg + message
//        }
////        return para.basePath.rawValue + para.path + ":"  + epErrorMsg
//        
//        return para.basePath.rawValue + para.path + ":\(reason):"  + epErrorMsg
//    }
//}
