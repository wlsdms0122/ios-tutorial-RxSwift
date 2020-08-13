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
    
    static func instantiate() -> Self {
        let identifier = String(describing: Self.self)
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("Fail to instantiate \(identifier) view controller.")
        }
        return viewController
    }
    
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
        let email = BehaviorSubject<String>(value: "")
        
        emailTextField.rx.text
            .orEmpty
            .bind(to: email)
            .disposed(by: disposeBag)
        
        let isEmailValidated = email
            .compactMap { [weak self] in self?.validate(email: $0) }
        
        Observable.combineLatest(email, isEmailValidated)
            .map { $0.isEmpty || $1 }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] in self?.setEmail(validated: $0) })
            .disposed(by: disposeBag)
        
        let password = BehaviorSubject<String>(value: "")
        
        passwordTextField.rx.text
            .orEmpty
            .bind(to: password)
            .disposed(by: disposeBag)
        
        let isPasswordValidated = password
            .compactMap { [weak self] in self?.validate(password: $0) }
        
        Observable.combineLatest(password, isPasswordValidated)
            .map { $0.isEmpty || $1 }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] in self?.setPassword(validated: $0) })
            .disposed(by: disposeBag)
        
        let isValidated = Observable.combineLatest(isEmailValidated, isPasswordValidated)
            .map { $0 && $1 }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            
        isValidated.drive(signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        isValidated
            .drive(onNext: { [weak self] in self?.setSignUp(enabled: $0) })
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .withLatestFrom(Observable.combineLatest(email, password))
            .subscribe(onNext: { [weak self] in self?.signUp(email: $0, password: $1) })
            .disposed(by: disposeBag)
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
