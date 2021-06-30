//
//  BaseTestVC.swift
//  ResizeView
//
//  Created by nick on 2021/6/28.
//

import UIKit

class BaseTestVC: UIViewController, TestTableDelegate {
    
    private var number: Int = 0 {
        didSet {
            numberLabel.text = "\(number)"
        }
    }
    private lazy var testButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Test", for: .normal)
        button.addTarget(self, action: #selector(didTap(test:)), for: .touchUpInside)
        button.backgroundColor = .green
        return button
    }()
    private lazy var addButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Add", for: .normal)
        button.addTarget(self, action: #selector(didTap(add:)), for: .touchUpInside)
        button.backgroundColor = .systemRed
        return button
    }()
    private let numberLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 36)
        label.textColor = .red
        label.text = "\(0)"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        [numberLabel, addButton, testButton].forEach { view.addSubview($0) }

        numberLabel
            .mLayChainSafe(pin: .top(20))
            .mLayChain(.centerX, .equal, view)
            .mLayChain(.height, 50)
        addButton
            .mLayChain(.centerX, .equal, view)
            .mLayChain(size: CGSize(width: 200, height: 80))
            .mLayChain(.bottom, .equal, view, .centerY, constant: -30)
        testButton
            .mLayChain(.centerX, .equal, view)
            .mLayChain(size: CGSize(width: 200, height: 80))
            .mLayChain(.top, .equal, view, .centerY, constant: 30)
    }
    
    @objc
    private func didTap(add button: UIButton) {
        number += 1
    }
    
    @objc
    private func didTap(test button: UIButton) {
        tapTest()
    }
    
    func tapTest() { }
    
    // MARK: - TestTableDelegate
    func didTap(number: Int) {
        self.number = number
    }
    
}
