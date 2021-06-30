//
//  HomeVC.swift
//  ResizeView
//
//  Created by nick on 2021/6/28.
//

import UIKit

final class HomeVC: UIViewController {
    
    private lazy var after15Button: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("AFTER 15", for: .normal)
        button.addTarget(self, action: #selector(didTap(after:)), for: .touchUpInside)
        button.backgroundColor = .red
        return button
    }()
    private lazy var beforButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("BEFORE 15", for: .normal)
        button.addTarget(self, action: #selector(didTap(before:)), for: .touchUpInside)
        button.backgroundColor = .red
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        [after15Button, beforButton].forEach { view.addSubview($0) }
        
        after15Button
            .mLayChain(.centerX, .equal, view)
            .mLayChain(size: CGSize(width: 200, height: 80))
            .mLayChain(.bottom, .equal, view, .centerY, constant: -30)
        beforButton
            .mLayChain(.centerX, .equal, view)
            .mLayChain(size: CGSize(width: 200, height: 80))
            .mLayChain(.top, .equal, view, .centerY, constant: 30)
    }
    
    @objc
    private func didTap(before button: UIButton) {
        let nextVC: Before15TestVC = Before15TestVC()
        nextVC.view.backgroundColor = .purple
        navigationController?.pushViewController(nextVC, animated: true)
    }

    @objc
    private func didTap(after button: UIButton) {
        let nextVC: After15TestVC = After15TestVC()
        nextVC.view.backgroundColor = .brown
        navigationController?.pushViewController(nextVC, animated: true)
    }

}
