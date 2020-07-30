//
//  MainViewController.swift
//  rx_playground
//
//  Created by JSilver on 2020/07/28.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    // MARK: - Layout
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: - Property
    private var disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        bind()
    }
    
    private func setUpLayout() {
        emailContainerView.layer.cornerRadius = 20
        emailContainerView.layer.borderColor = UIColor(red: 221 / 255, green: 76 / 255, blue: 76 / 255, alpha: 1).cgColor
        
        passwordContainerView.layer.cornerRadius = 20
        passwordContainerView.layer.borderColor = UIColor(red: 221 / 255, green: 76 / 255, blue: 76 / 255, alpha: 1).cgColor
        
        passwordTextField.isSecureTextEntry = true
        
        signUpButton.layer.cornerRadius = 20
    }
    
    private func bind() {
        /* Write down here */
    }
    
    private func signUp(email: String, password: String) {
        let alertController = UIAlertController(
            title: "🎉 Wellcome!! 🎉",
            message: "Your email is \(email)",
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(
                title: "Confirm",
                style: .default,
                handler: { _ in alertController.dismiss(animated: true, completion: nil) }
            )
        )
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func validate(email: String) -> Bool {
        email.regex(pattern: "^\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$")
    }
    
    private func validate(password: String) -> Bool {
        password.count > 8
    }
    
    private func setEmail(validated: Bool) {
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.fromValue = validated ? 3 : 0
        animation.toValue = validated ? 0 : 3
        animation.duration = 0.3
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        
        emailContainerView.layer.add(animation, forKey: "borderWidth")
    }
    
    private func setPassword(validated: Bool) {
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.fromValue = validated ? 3 : 0
        animation.toValue = validated ? 0 : 3
        animation.duration = 0.3
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        
        passwordContainerView.layer.add(animation, forKey: "borderWidth")
    }
    
    private func setSignUp(enabled: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.signUpButton.backgroundColor = enabled ?
                UIColor(red: 211 / 255, green: 93 / 255, blue: 174 / 100, alpha: 1) :
                UIColor(red: 81 / 255, green: 81 / 255, blue: 81 / 255, alpha: 1)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension String {
    func regex(pattern: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: pattern)
        return regex?.firstMatch(in: self, range: NSRange(location: 0, length: count)) != nil
    }
}
