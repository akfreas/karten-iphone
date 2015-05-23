import Foundation

func defaultAttrs() -> [NSObject : AnyObject] {
    
    var para = NSMutableParagraphStyle()
    para.alignment = NSTextAlignment.Center
    var attrs = [NSObject : AnyObject]()
    attrs[
        NSFontAttributeName] = UIFont(name: "HelveticaNeue-Light", size: 26.0)
    attrs[NSParagraphStyleAttributeName] = para
    return attrs
}

public class KTCardContentView : UIView {
    
    public var text                         : String! {
        didSet {
            updateTextView()
        }
    }
    public var formatting                   : [String : AnyObject]!
    
    private var textView                    = UITextView()
    
    init() {
        super.init(frame: CGRectZero)
        addTextView()
        addLayoutConstraints()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private Functions
    
    private func addTextView() {
        textView.editable = false
        textView.selectable = false
        addSubview(textView)
    }
    
    private func addLayoutConstraints() {
        textView.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: self)
        textView.autoPinEdge(ALEdge.Right, toEdge: ALEdge.Right, ofView: self)
        textView.autoCenterInSuperview()
        textView.autoSetDimension(ALDimension.Height, toSize: 60.0)
        textView.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: self)
    }
    
    private func updateTextView() {
        textView.attributedText = NSAttributedString(string: text, attributes: defaultAttrs())
        textView.layoutIfNeeded()
    }
    
}