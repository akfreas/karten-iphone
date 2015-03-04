import Foundation
import UIKit

@objc public class KTNewProfileViewController : KMCollectionViewController {
    
    var user : KTUser?
    
    public init(user: KTUser) {
        
        super.init()
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
