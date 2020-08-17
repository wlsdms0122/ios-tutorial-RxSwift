//
//  ListViewController.swift
//  rx_playground
//
//  Created by JSilver on 2020/08/13.
//

import Foundation
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
    private var colors = BehaviorSubject<[Color]>(value: [])
    
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
        hexTextField.rx.text
            .orEmpty
            .filter { $0.count > 6 }
            .map { String($0.dropLast()) }
            .bind(to: hexTextField.rx.text)
            .disposed(by: disposeBag)
        
        let textFieldColor = hexTextField.rx.text
            .orEmpty
            .filter { $0.count == 6 }
            .compactMap { [weak self] in self?.rgb(from: $0) }
            .share()
        
        textFieldColor.map { Float($0.0) }
            .bind(to: redSlider.rx.value)
            .disposed(by: disposeBag)
        
        textFieldColor.map { Float($0.1) }
            .bind(to: greenSlider.rx.value)
            .disposed(by: disposeBag)
        
        textFieldColor.map { Float($0.2) }
            .bind(to: blueSlider.rx.value)
            .disposed(by: disposeBag)
        
        let sliderColor = Observable.combineLatest(
            redSlider.rx.value
                .asObservable()
                .map { Int($0) },
            greenSlider.rx.value
                .asObservable()
                .map { Int($0) },
            blueSlider.rx.value
                .asObservable()
                .map { Int($0) }
        )
        
        sliderColor.compactMap { [weak self] in self?.hex(from: $0, green: $1, blue: $2) }
            .debug()
            .bind(to: hexTextField.rx.text)
            .disposed(by: disposeBag)
        
        Observable.merge(textFieldColor, sliderColor)
            .map { (CGFloat($0) / 255, CGFloat($1) / 255, CGFloat($2) / 255) }
            .map { UIColor(red: $0, green: $1, blue: $2, alpha: 1) }
            .bind(to: colorView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        createButton.rx.tap
            .withLatestFrom(
                Observable.combineLatest(
                    nameTextField.rx.text
                        .orEmpty
                        .map { $0.isEmpty ? "Unknown" : $0 },
                    hexTextField.rx.text
                        .orEmpty
                )
            )
            .map { Color(title: $0, hex: $1) }
            .do(onNext: { [weak self] _ in self?.nameTextField.text = nil })
            .scan([]) { [$1] + $0 }
            .bind(to: colors)
            .disposed(by: disposeBag)
        
        colors.bind(to: colorTableView.rx.items(
            cellIdentifier: String(describing: ColorTableViewCell.self),
            cellType: ColorTableViewCell.self
        )) { index, item, cell in
            cell.backgroundColor = UIColor(hex: "#\(item.hex)")
            cell.titleLabel.text = item.title
            cell.colorLabel.text = item.hex
        }
            .disposed(by: disposeBag)
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
    
    private func rgb(from code: String) -> (Int, Int, Int)? {
        let color = code.split(length: 2)
            .map { Int($0, radix: 16) }
        
        guard let red = color[0], let green = color[1], let blue = color[2] else { return nil }
        return (red, green, blue)
    }
    
    private func hex(from red: Int, green: Int, blue: Int) -> String {
        String(format: "%02X%02X%02X", red, green, blue)
    }
}

struct Color {
    let title: String
    let hex: String
}
