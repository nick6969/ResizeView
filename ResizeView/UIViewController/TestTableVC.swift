//
//  TestTableVC.swift
//  ResizeView
//
//  Created by nick on 2021/6/28.
//

import UIKit

protocol TestTableDelegate: AnyObject {
    func didTap(number: Int)
}

final class TestTableVC: UIViewController {
    
    weak var delegate: TestTableDelegate?
        
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.registerCells(types: [
            UITableViewCell.self
        ])
        tableView.backgroundColor = .clear
        tableView.bounces = false
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private let searchBar: UISearchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "This is test"
        view.backgroundColor = .white
        
        [searchBar, tableView].forEach { view.addSubview($0) }
        searchBar
            .mLayChainSafe(pin: .top().horizontal())
            .mLayChain(.height, 50)
        tableView
            .mLayChainSafe(pin: .horizontal().bottom())
            .mLayChain(.top, .equal, searchBar, .bottom, constant: 10)
    }
    
}

extension TestTableVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didTap(number: indexPath.row)
    }
    
}
