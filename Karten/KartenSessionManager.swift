import Foundation


struct statics {
    static var instance : KartenSessionManager?
    static var once : dispatch_once_t = 0
    static var kKartenTokenKey : String? = "kKartenTokenKey"
    static var kKartenLastUsernameKey : String? = "kKartenLastUsernameKey"
}

@objc class KartenSessionManager {
    
    class func isSessionValid()->Bool {
//        if KartenSessionManager.getToken() != nil {
//            return true
//        }
        return false
    }
    
    private class func sharedInstance()->KartenSessionManager! {
        dispatch_once(&statics.once, {
            statics.instance = KartenSessionManager()
        })
        return statics.instance
    }
    
    class func getToken()->String
    {
        var token : String = NSUserDefaults.standardUserDefaults().stringForKey(statics.kKartenTokenKey)
        return token
    }
    
    class func setToken(token : String)
    {
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: statics.kKartenTokenKey)
    }
    
    class func setLastUsedUsername(username : String)
    {
        NSUserDefaults.standardUserDefaults().setObject(username, forKey: statics.kKartenLastUsernameKey)
    }
    
    class func lastUsedUsername()->String
    {
        return NSUserDefaults.standardUserDefaults().stringForKey(statics.kKartenLastUsernameKey)
    }
}