import UIKit


@objc public class KTQuizFlashView : UIView {
    
    public var displayText                  : String! {
        didSet {
            configureLabelForCard()
        }
    }
    var centerLabel                         = UILabel()
    var config                              = KTUIConfigurationUtil.utilWithPrefix("QuizFlashView")
    
    public override init() {
        super.init()
        addCenterLabel()
        addLayoutConstraints()
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addCenterLabel() {
        centerLabel.numberOfLines = 0
        self.addSubview(centerLabel)
    }
    
    func addLayoutConstraints() {
        centerLabel.autoAlignAxisToSuperviewAxis(ALAxis.Horizontal)
        centerLabel.autoPinEdge(ALEdge.Right, toEdge: ALEdge.Right, ofView: self)
        centerLabel.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: self)
    }
    
    func configureLabelForCard() {
        centerLabel.attributedText = NSAttributedString(string: displayText, attributes: config.fontAttributesForKey("CenterFontAttributes"))
    }
    
}