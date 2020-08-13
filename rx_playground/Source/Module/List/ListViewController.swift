//
//  ListViewController.swift
//  rx_playground
//
//  Created by JSilver on 2020/08/13.
//

import UIKit

class ListViewController: UIViewController {
    // MARK: - Layout
    
    // MARK: - Property
    private var email: String?
    
    static func instantiate(email: String) -> Self {
        let identifier = String(describing: Self.self)
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("Fail to instantiate \(identifier) view controller.")
        }
        
        viewController.email = email
        
        return viewController
    }
}
