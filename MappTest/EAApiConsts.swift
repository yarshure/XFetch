

import Foundation

class EAApiConsts{
 
    static var serverUrl:String  {
        get {
            
                //
            //    return "https://umpstest.unionpayintl.com/camswallet"
            return  "http://101.231.72.72:22165" //
            //}
            //return "https://umpstest.unionpayintl.com/camstpapi"
            // return  "http://101.231.72.72:23165" //
        }
    }
  
    static var apiDataFormatStr:String = "yyyy-MM-ddTHH:mm:ss.SSSZ"
    static var apiModelDefaultDate:Date = Date(timeIntervalSince1970: 0)
    static var apiTimeoutTime:Double = 15
    //static var refer =
    static var  df:DateFormatter {
        let d = DateFormatter()
        d.dateFormat = apiDataFormatStr
        return d
    }

}
