//
//  ReservationUserInfoViewController.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 8.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import UIKit
public class ReservationUserInfoViewController: UIViewController {
    
    private(set) var viewModel: ReservationUserInfoViewModel
    private(set) var tableView = UITableView()
    private var continueButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Apply", for: .normal)
        btn.backgroundColor = UIColor.blue
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(applyPressed), for: UIControl.Event.touchUpInside)
        btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btn.layer.cornerRadius = 6
        return btn
    }()
    
    public init(viewModel: ReservationUserInfoViewModel = ReservationUserInfoViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        //Todo: -  Coordinater'a taşınacak
        viewModel.start()
        setupButtonUI()
        setupTableView()
    }
    
    private func setupButtonUI() {
        view.addSubview(continueButton)
        continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        if #available(iOS 11.0, *) {
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        }else {
            continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        }
    }
    
    @objc func applyPressed() {}
    
}

extension ReservationUserInfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: continueButton.topAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(ReservationUserInfoCell.self, forCellReuseIdentifier: "userInfoCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 95
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userInfoCell", for: indexPath) as! ReservationUserInfoCell
        let model = viewModel.getCellViewModel(at: indexPath)
        
        cell.titleLabel.text = model.title
        cell.inputText.text = "a"
        cell.selectionStyle = .none
        return cell
    }
    
}
