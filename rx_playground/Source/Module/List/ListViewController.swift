//
//  ListViewController.swift
//  rx_playground
//
//  Created by JSilver on 2020/08/13.
//

import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {
    // MARK: - Layout
    @IBOutlet private weak var colorView: UIView!
    
    @IBOutlet private weak var redSlider: UISlider!
    @IBOutlet private weak var redValueLabel: UILabel!
    
    @IBOutlet private weak var greenSlider: UISlider!
    @IBOutlet private weak var greenValueLabel: UILabel!
    
    @IBOutlet private weak var blueSlider: UISlider!
    @IBOutlet private weak var blueValueLabel: UILabel!
    
    @IBOutlet private weak var nameTextField: UITextField!
    
    @IBOutlet private weak var hexTextField: UITextField!
    
    @IBOutlet private weak var createButton: UIButton!
    
    @IBOutlet private weak var colorTableView: UITableView!
    
    // MARK: - Property
    private var email: String?
    
    private var disposeBag = DisposeBag()
    
    static func instantiate(email: String) -> Self {
        let identifier = String(describing: Self.self)
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("Fail to instantiate \(identifier) view controller.")
        }
        
        viewController.email = email
        
        return viewController
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        bind()
    }
    
    private func bind() {
        /* Write down here */
    }
    
    private func setUpLayout() {
        title = "🎉 \(email ?? "Unknown") 🎉"
        
        colorView.layer.cornerRadius = 20
        
        redSlider.minimumValue = 0
        redSlider.maximumValue = 255
        redSlider.value = 127
        
        greenSlider.minimumValue = 0
        greenSlider.maximumValue = 255
        greenSlider.value = 127
        
        blueSlider.minimumValue = 0
        blueSlider.maximumValue = 255
        blueSlider.value = 127
        
        createButton.layer.cornerRadius = 20
    }
}
