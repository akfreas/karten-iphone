import Foundation
import UIKit

@objc class LoginViewController : UIViewController {
    
    @IBOutlet var usernameField : UITextField!
    @IBOutlet var passwordField : UITextField!
    @IBOutlet var loginButton : UIButton!
    @IBOutlet var signUpButton : UIButton!
    @IBOutlet var continueButton : UIButton!
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nil, bundle: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createPasswordField()
        self.createUsernameField()
        self.createLoginButton()
        self.addLayoutConstraints()
        self.view.backgroundColor = UIColor(white: 0.7, alpha: 1)
        usernameField.becomeFirstResponder()
    }
    
    func createUsernameField() {
        usernameField = UITextField()
        usernameField.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        usernameField.placeholder = "Username"
        usernameField.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(usernameField)
    }
    
    func createPasswordField() {
        passwordField = UITextField()
        passwordField.placeholder = "Password"
        passwordField.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        passwordField.secureTextEntry = true
        passwordField.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(passwordField)
    }
    
    func createLoginButton() {
        loginButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        loginButton.setTitle("Login", forState: UIControlState.Normal)
        loginButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(loginButton)
    }
    
    func createSignUpButton() {
        signUpButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
        self.view.addSubview(signUpButton)
    }
    
    func addLayoutConstraints() {
        self.view.addConstraints(
            [NSLayoutConstraint(item: usernameField,
                attribute: NSLayoutAttribute.CenterX,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.CenterX,
                multiplier: 1.0,
                constant: 0.0),
            NSLayoutConstraint(item: usernameField,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.GreaterThanOrEqual,
                toItem: self.topLayoutGuide,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1.0,
                constant: 44.0),
            NSLayoutConstraint(item: usernameField,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1.0,
                constant: 44.0),
            NSLayoutConstraint(item: usernameField,
                attribute: NSLayoutAttribute.Width,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.Width,
                multiplier: 0.75,
                constant: 0.0),
            NSLayoutConstraint(item: passwordField,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: usernameField,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1.0,
                constant: 20.0),
            NSLayoutConstraint(item: passwordField,
                attribute: NSLayoutAttribute.CenterX,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.CenterX,
                multiplier: 1.0,
                constant: 0.0),
            NSLayoutConstraint(item: passwordField,
                attribute: NSLayoutAttribute.Width,
                relatedBy: NSLayoutRelation.Equal,
                toItem: usernameField,
                attribute: NSLayoutAttribute.Width,
                multiplier: 1.0,
                constant: 0.0),
            NSLayoutConstraint(item: passwordField,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: usernameField,
                attribute: NSLayoutAttribute.Height,
                multiplier: 1.0,
                constant: 0.0),
            NSLayoutConstraint(item: loginButton,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: passwordField,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1.0,
                constant: 10.0),
            NSLayoutConstraint(item: loginButton,
                attribute: NSLayoutAttribute.CenterX,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.CenterX,
                multiplier: 1.0,
                constant: 0.0),
            NSLayoutConstraint(item: loginButton,
                attribute: NSLayoutAttribute.Width,
                relatedBy: NSLayoutRelation.Equal,
                toItem: usernameField,
                attribute: NSLayoutAttribute.Width,
                multiplier: 1.0,
                constant: 0.0),
            NSLayoutConstraint(item: loginButton,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: usernameField,
                attribute: NSLayoutAttribute.Height,
                multiplier: 1.0,
                constant: 0.0)])
        self.view.setNeedsLayout()
    }
}