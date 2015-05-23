import Foundation


protocol KTStackActionOverlayDelegate {
    
    func overlay(overlay: KTStackActionOverlay, wantsToDeleteStack:KTstack)
}

class KTStackActionOverlay : UIView {
    
    var delete = UIView()
    var share = UIView()
    
    
    override init(frame: CGRect) {
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}