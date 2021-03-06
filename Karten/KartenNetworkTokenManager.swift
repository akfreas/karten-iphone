import Foundation
import UIKit


@objc class KartenNetworkTokenManager {
    
    
    class func createAuthorizationHeaderString()->String
    {
        let token : String = KartenSessionManager.getToken()
        var formattedHeaderString : String
        if count(token) > 0 {
            formattedHeaderString = String(format: "Token %@", token)
        } else {
            formattedHeaderString = ""
        }
        
        return formattedHeaderString
    }
    
}