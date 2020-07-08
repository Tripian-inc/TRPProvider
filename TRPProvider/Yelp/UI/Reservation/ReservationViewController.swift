//
//  ReservationViewController.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 7.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import UIKit
public class ReservationViewController: UIViewController {
    
    private(set) var viewModel: ReservationViewModel
    private(set) var tableView = UITableView()
    
    
    public init(viewModel: ReservationViewModel = ReservationViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        viewModel.start()
        setupTableView()
        //Todo: -  Coordinater'a taşınacak
        viewModel.delegate = self
    }
    
}

extension ReservationViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(ReservationDatePickerCell.self, forCellReuseIdentifier: "datePicker")
        tableView.register(ReservationPeople.self, forCellReuseIdentifier: "people")
        tableView.register(ReservationAlternativeHour.self, forCellReuseIdentifier: "alternativeHour")
        tableView.register(ReservationExplainCell.self, forCellReuseIdentifier: "explainText")
        
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
        
        let model = viewModel.getCellViewModel(at: indexPath)
        
        if model.contentType == .date || model.contentType == .time{
            let dateCell = makeDateCell(tableView: tableView, cellForRowAt: indexPath, model: model)
            return dateCell
        }else if model.contentType == .people {
            let dateCell = makePeopleCell(tableView: tableView, cellForRowAt: indexPath, model: model)
            return dateCell
        }else if model.contentType == .alternativeTime {
            let dateCell = makeAlternaviteHourCell(tableView: tableView, cellForRowAt: indexPath, model: model)
            return dateCell
        }else if model.contentType == .explain {
            let dateCell = makeExplainCell(tableView: tableView, cellForRowAt: indexPath, model: model)
            return dateCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = "IndexPath \(indexPath.row)"
        return cell
    }
    
}

extension ReservationViewController {
    
    private func makeDateCell(tableView: UITableView, cellForRowAt indexPath: IndexPath, model: ReservationCellModel) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "datePicker", for: indexPath) as! ReservationDatePickerCell
        cell.titleLabel.text = model.title
        cell.selectionStyle = .none
        if model.contentType == .date {
            cell.inputText.text = viewModel.date
        }else {
            cell.inputText.text = viewModel.time
        }
        return cell
    }
    
    private func makePeopleCell(tableView: UITableView, cellForRowAt indexPath: IndexPath, model: ReservationCellModel) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "people", for: indexPath) as! ReservationPeople
        cell.titleLabel.text = model.title
        cell.inputText.text = "\(viewModel.people)"
        cell.selectionStyle = .none
        return cell
    }
    
    private func makeAlternaviteHourCell(tableView: UITableView, cellForRowAt indexPath: IndexPath, model: ReservationCellModel) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alternativeHour", for: indexPath) as! ReservationAlternativeHour
        cell.titleLabel.text = model.title
        
        cell.updateHours(viewModel.hours)
        cell.selectionStyle = .none
        return cell
    }
    
    
    private func makeExplainCell(tableView: UITableView, cellForRowAt indexPath: IndexPath, model: ReservationCellModel) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "explainText", for: indexPath) as! ReservationExplainCell
        cell.titleLabel.text = model.title
        cell.explainLabel.text = viewModel.explainText
        cell.selectionStyle = .none
        return cell
    }
}

extension ReservationViewController: ReservationViewModelDelegate {
    public func reservationVM(dataLoaded: Bool) {
        tableView.reloadData()
    }
    
    public func reservationVM(showLoader: Bool) {
        
    }
    
    public func reservationVM(error: Error) {
        
    }
}
