//
//  ReservationViewModel.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 7.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation

public struct ReservationCellModel {
    public var title: String
    public var contentType: ReservationViewModel.CellContentType
}

public protocol ReservationViewModelDelegate: class {
    func reservationVM(dataLoaded: Bool)
    func reservationVM(showLoader: Bool)
    func reservationVM(error: Error)
    func reservationVMChangeButtonStatus()
    func reservationVMAlternativeHoursLoaded()
}


public class ReservationViewModel {
    
    private var placeId = "rC5mIHMNF5C1Jtpb2obSkA"
    
    public enum CellContentType {
        case date, time, people, alternativeTime, explain
    }
    
    enum ButtonStatus: String {
        case findATable = "Find a Table"
        case makeAreservation = "Make A Reservation"
    }
    
    public weak var delegate: ReservationViewModelDelegate?
    private(set) var model: YelpBusiness?
    //Data of UI
    public var numberOfCells: Int { return cellViewModels.count }
    public var cellViewModels: [ReservationCellModel] = []
    public var date: String
    public var time: String = "16:00" {
        didSet {
            delegate?.reservationVM(dataLoaded: true)
        }
    }
    public var people: Int = 2
    public var explainText = "Mock Explain"
    public var hours: [String] = [] {
        didSet {
            delegate?.reservationVM(dataLoaded: true)
        }
    }
    var fetchNewHour = false
    var buttonStatus: ButtonStatus = .findATable {
        didSet {
            delegate?.reservationVMChangeButtonStatus()
        }
    }
    
    public init(date: String, time: String, covers: Int) {
        self.date = date
        self.time = time
        self.people = covers
    }
    
    func start() {
        createData()
        fetchBusinessInfo(withId: placeId)
        fetchOpeningsHour(id: placeId, covers: people, date: date, time: time)
    }
    
    private func createData() {
        var cells = [ReservationCellModel]()
        cells.append(.init(title: "Notes from the Business", contentType: .explain))
        cells.append(.init(title: "Party Size", contentType: .people))
        cells.append(.init(title: "Date", contentType: .date))
        cells.append(.init(title: "Time", contentType: .time))
        cells.append(.init(title: "Alternative Time", contentType: .alternativeTime))
        cellViewModels = cells
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> ReservationCellModel {
        return cellViewModels[indexPath.row]
    }
    
    public func updateDate(_ date: String ){
        fetchNewHour = true
        self.date = date
    }
    
    public func findATable() {
        hours = []
        fetchOpeningsHour(id: placeId, covers: people, date: date, time: time)
    }
    
    public func clearATable() {
        hours = []
        buttonStatus = .findATable
    }
}

//TODO: - DOMAIN MODELE TASINACAK
extension ReservationViewModel {
    private func fetchBusinessInfo(withId id: String) {
        delegate?.reservationVM(showLoader: true)
        YelpApi(isProduct: true).business(id: id) {[weak self] (result) in
            self?.delegate?.reservationVM(showLoader: false)
            switch result {
            case .success(let model):
                self?.model = model
                self?.updateUiWithBusinessMode(model)
            case .failure(let error):
                self?.delegate?.reservationVM(error: error)
            }
        }
    }
    
    private func fetchOpeningsHour(id: String, covers: Int, date: String, time: String) {
        delegate?.reservationVM(showLoader: true)
        YelpApi(isProduct: false).openings(businessId: id, covers: covers, date: date, time: time) { [weak self] result in
            self?.delegate?.reservationVM(showLoader: false)
            switch result {
            case .success(let model):
                let converted = model.reservationTimes.compactMap({$0})
                self?.openingHoursTimeParser(times: converted)
                self?.fetchNewHour = false
                self?.buttonStatus = .makeAreservation
                self?.delegate?.reservationVMAlternativeHoursLoaded()
            case .failure(let error):
                self?.delegate?.reservationVM(error: error)
            }
        }
    }
    
}

//MARK: - MODEL TO UI
extension ReservationViewModel{
    
    private func openingHoursTimeParser(times: [YelpReservationTime]) {
        guard let reservationTime = matchDateWithReservationsTime(date: date, times: times) else {return}
        hours = reservationTime.times.map{$0.time}
    }
    
    private func matchDateWithReservationsTime(date: String, times: [YelpReservationTime]) -> YelpReservationTime? {
        return times.first(where: {$0.date == date})
    }
    
    private func updateUiWithBusinessMode(_ model: YelpBusiness) {
        if let message = model.messaging, let useCaseText = message.useCaseText {
            explainText = useCaseText
        }
        delegate?.reservationVM(dataLoaded: true)
    }
}

