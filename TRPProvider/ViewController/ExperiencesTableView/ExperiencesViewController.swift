//
//  ExperiencesViewController.swift
//  TRPCoreKit
//
//  Created by Evren Yaşar on 15.09.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
import TRPUIKit

public protocol ExperiencesViewControllerDelegate: AnyObject {
    func experiencesVCOpenTour(_ navigationController: UINavigationController?, viewController: UIViewController, tourId: Int)
}


public class ExperiencesViewController: TRPBaseUIViewController {
    
    private var tableView: EvrTableView = EvrTableView()
    private var viewModel: ExperiencesViewModel
    public weak var delegate: ExperiencesViewControllerDelegate?
    
    init(viewModel: ExperiencesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Experiences"
        
    }
    
    public override func setupViews() {
        super.setupViews()
        addCloseButton(position: .left)
        setupTableView()
        viewModel.start()
    }
    
}

extension ExperiencesViewController: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func setupTableView() {
        tableView = EvrTableView(frame: CGRect.zero)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register1(cellClass: ExperiencesCell.self)
        tableView.setEmptyText("No experiences yet.")
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0);
        tableView.separatorStyle = .none
        tableView.isHiddenEmptyText = true
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue1(cellClass: ExperiencesCell.self, forIndexPath: indexPath)
        
        let model = viewModel.getCellViewModel(at: indexPath)
        cell.titleLabel.text = model.title
        cell.updateData(model.datas)
        cell.selectedTourAction = selectedTour(_:)
        cell.selectionStyle = .none
        return cell
    }
    
    private func selectedTour(_ tourId: Int) {
        delegate?.experiencesVCOpenTour(self.navigationController, viewController: self, tourId: tourId) 
    }
    
}


extension ExperiencesViewController: ExperiencesViewModelDelegate {
    
    public override func viewModel(dataLoaded: Bool) {
        tableView.reloadData()
    }
    
    func experiencesViewModelShowEmptyWarning() {
        tableView.isHiddenEmptyText = false
    }
}
