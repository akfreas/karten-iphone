import Foundation


public enum KTCardContentHostingViewOrder {
    case TermFirst
    case DefinitionFirst
}

class KTQuizViewController : UIViewController, MDCSwipeToChooseDelegate     {
    
    var order                                  = KTCardContentHostingViewOrder.TermFirst
    var frontHostingView                       : KTCardContentHostingView!
    var backHostingView                        : KTCardContentHostingView!
    var quizCards                              : [KTCard]!
    var config                                 = KTUIConfigurationUtil.utilWithPrefix("QuizViewController")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(order: KTCardContentHostingViewOrder) {
        self.init(nibName: nil, bundle: nil)
        self.order = order
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        frontHostingView = popHostingView(frontHostingViewFrame())
        view.addSubview(frontHostingView)
        
        backHostingView = popHostingView(backHostingViewFrame())
        view.insertSubview(backHostingView, belowSubview:frontHostingView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = config.colorForKey("BackgroundColor")
    }
    
    
    func popHostingView(frame: CGRect) -> KTCardContentHostingView {
        
        var options = MDCSwipeToChooseViewOptions()
        options.delegate = self
        options.threshold = 120.0
        options.likedText = "KNOW"
        options.nopeText = "NOPE"
        options.onPan = {(state: MDCPanState!) in
            
        }
        
        var view : KTCardContentHostingView!
        if quizCards.count > 0 {
            view = KTCardContentHostingView.hostingViewForCard(quizCards[0], order: order, frame: frame, options: options)
        } else {
        }
        return view
    }
    
    private func frontHostingViewFrame() -> CGRect {
        var horizontalPadding = CGFloat(20.0)
        var topPadding = CGFloat(80.0)
        var bottomPadding = CGFloat(200.0)
        return CGRectMake(horizontalPadding, topPadding, CGRectGetWidth(self.view.frame) - CGFloat(horizontalPadding*2), CGRectGetHeight(self.view.frame) - CGFloat(bottomPadding))
    }
    
    private func backHostingViewFrame() -> CGRect {
        var frontFrame = frontHostingViewFrame()
        return CGRectMake(frontFrame.origin.x,
            frontFrame.origin.y + CGFloat(10.0),
            CGRectGetWidth(frontFrame),
            CGRectGetHeight(frontFrame))
    }
    
    //MARK:  MDCSwipeToChooseDelegate
    
    func view(view: UIView!, wasChosenWithDirection direction: MDCSwipeDirection) {
        
        
        
        frontHostingView = backHostingView
        backHostingView = popHostingView(frontHostingViewFrame())
        if quizCards.count > 0 {
            var currentCard = quizCards[0]
            var score = currentCard.knowledgeScore.integerValue
            if direction == MDCSwipeDirection.Left {
                score++
            } else if direction == MDCSwipeDirection.Right {
                score--
            }
            currentCard.knowledgeScore = NSNumber(integer: score)
            NSManagedObjectContext.MR_defaultContext().MR_saveOnlySelfAndWait()
            quizCards.removeAtIndex(0)
        }
        if let cardView = backHostingView {
            cardView.alpha = 0.0
            self.view.insertSubview(cardView, belowSubview:frontHostingView)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                cardView.alpha = 1.0
            })
        }
    }
    
}