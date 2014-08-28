import Foundation
import UIKit


@objc class KartenNetworkTokenManager {
    
    
    class func createAuthorizationHeaderString()->String
    {
        let token : String = KartenSessionManager.getToken()
        var formattedHeaderString : String
        if countElements(token) > 0 {
            formattedHeaderString = String(format: "Authorization : Token %@", token)
        } else {
            formattedHeaderString = ""
        }
        
        return formattedHeaderString
    }
    
}