

import Foundation

public class EAApiConsts{
 
   public static var serverUrl:String  {
        get {
            
           return "please update"
        }
    }
  
    static var apiDataFormatStr:String = "yyyy-MM-ddTHH:mm:ss.SSSZ"
    static var apiModelDefaultDate:Date = Date(timeIntervalSince1970: 0)
    public static var apiTimeoutTime:Double = 15
    //static var refer =
    static var  df:DateFormatter {
        let d = DateFormatter()
        d.dateFormat = apiDataFormatStr
        return d
    }

}
