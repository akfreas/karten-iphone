import Foundation


extension KTCardContentHostingView {
    class func hostingViewForCard(card: KTCard, order:KTCardContentHostingViewOrder, frame: CGRect, options:MDCSwipeToChooseViewOptions) -> KTCardContentHostingView {
        return hostingView(card.term, definition: card.definition, order: order, frame: frame, options: options)
    }

    class func hostingView(term: String, definition: String, order:KTCardContentHostingViewOrder, frame: CGRect, options:MDCSwipeToChooseViewOptions) -> KTCardContentHostingView {
        
        var hostingView = KTCardContentHostingView(frame: frame, options: options)
        var frontCard = KTCardContentView()
        var backCard = KTCardContentView()
        if order == .TermFirst {
            frontCard.text = term
            backCard.text = definition
        } else if order == .DefinitionFirst {
            backCard.text = term
            frontCard.text = definition
        }
        hostingView.contentViews = [frontCard, backCard]
        return hostingView
    }
}


public class KTCardContentHostingView : MDCSwipeToChooseView {
    
    public var contentViews                    : [KTCardContentView]! {
        didSet {
            configureContentViews()
        }
    }
    private var tapGesture                     : UITapGestureRecognizer!
    
    
    var displayedContentView            : KTCardContentView! {
        return contentViews[0]
    }
    
    override init!(frame: CGRect, options: MDCSwipeToChooseViewOptions!) {
        super.init(frame: frame, options: options)
        backgroundColor = UIColor.whiteColor()
        tapGesture = UITapGestureRecognizer(target: self, action: "flipContent")
        addGestureRecognizer(tapGesture)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private Functions
    
    private func configureContentViews() {
        if displayedContentView.superview == nil {
            addSubview(displayedContentView)
        }
        addLayoutConstraints()
    }
    
    private func addLayoutConstraints() {
        displayedContentView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
    }
    
    public func flipContent() {
        
        var previousView = displayedContentView
        contentViews.removeAtIndex(0)
        contentViews.append(previousView)
        UIView.transitionFromView(previousView, toView: displayedContentView, duration: 0.2, options: UIViewAnimationOptions.TransitionFlipFromRight) { (finished) -> Void in
        }
        
    }
    
}