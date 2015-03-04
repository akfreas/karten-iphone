import Foundation
import UIKit

public class KTProfileAggregateDataSource : KMCollectionViewAggregateDataSource
{
    var user : KTUser?
    
    public init(user: KTUser) {
        super.init()
        self.user = user
    }
    
}
