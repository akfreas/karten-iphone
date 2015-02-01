import UIKit

@objc public class KTViewFriendsViewController: UIViewController, KTFriendSelectionDelegate  {

    let selectionController : KTFriendSelectionViewController
    var user : KTUser?
    
    public init(user: KTUser) {
        self.selectionController = KTFriendSelectionViewController(user: user)
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
//    
//    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        self.selectionController = KTFriendSelectionViewController(user: user)
//
//        super.init(nibName: nil, bundle: nil)
//    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    
    
    //MARK KTFriendSelectionDelegate
    
    public func friendsList(friendsList: KTFriendSelectionViewController!, didSelectFriend selectedFriend: KTUser!) {
        let profileController = KTProfileViewController()
        profileController.user = selectedFriend
        self.navigationController?.pushViewController(profileController, animated: true)
    }
    
    func configureSelectionController() {
        self.addChildViewController(selectionController)
        self.view.addSubview(selectionController.view)
        selectionController.showSearchBar = false
        selectionController.delegate = self
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureSelectionController()
        // Do any additional setup after loading the view.
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
