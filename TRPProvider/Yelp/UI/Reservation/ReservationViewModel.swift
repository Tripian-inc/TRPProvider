//
//  ReservationViewModel.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 7.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation

struct ReservationCellModel {
    var title: String
    var contentType: ReservationViewModel.CellContentType
}

public protocol ReservationViewModelDelegate: class {
    func reservationVM(dataLoaded: Bool)
    func reservationVM(showLoader: Bool)
    func reservationVM(error: Error)
}


public class ReservationViewModel {
    
    private var placeId = "rC5mIHMNF5C1Jtpb2obSkA"
    
    enum CellContentType {
        case date, time, people, alternativeTime, explain
    }
    
    public weak var delegate: ReservationViewModelDelegate?
    private(set) var model: YelpBusiness?
    var numberOfCells: Int { return cellViewModels.count }
    var cellViewModels: [ReservationCellModel] = []
    var date: String = "2020-09-09"
    var time: String = "16:00"
    var people: Int = 2
    var explainText = "Mock Explain"
    var hours: [String] = ["10:00", "11:00", "12:00"] {
        didSet {
            print("Data geldin \(hours)")
            delegate?.reservationVM(dataLoaded: true)
        }
    }
    
    public init() {}
    
    func start() {
        createData()
        fetchBusinessInfo(withId: placeId)
        fetchOpeningsHour(id: placeId, covers: people, date: date, time: time)
    }
    
    private func createData() {
        var cells = [ReservationCellModel]()
        cells.append(.init(title: "Date", contentType: .date))
        cells.append(.init(title: "Time", contentType: .time))
        cells.append(.init(title: "Party Size", contentType: .people))
        cells.append(.init(title: "Notes from the Business", contentType: .explain))
        cells.append(.init(title: "Alternative Time", contentType: .alternativeTime))
        cellViewModels = cells
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> ReservationCellModel {
        return cellViewModels[indexPath.row]
    }
}

//TODO: - DOMAIN MODELE TASINACAK
extension ReservationViewModel {
    private func fetchBusinessInfo(withId id: String) {
        YelpApi( isProduct: true).business(id: id) {[weak self] (result) in
            switch result {
            case .success(let model):
                self?.model = model
            case .failure(let error):
                print("[ERROR] VM \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchOpeningsHour(id: String, covers: Int, date: String, time: String) {
        YelpApi(isProduct: false).openings(id: id, covers: covers, date: date, time: time) { [weak self] result in
            switch result {
            case .success(let model):
                let converted = model.reservationTimes.compactMap({$0})
                self?.openingHoursTimeParser(times: converted)
            case .failure(let error):
                print("[ERROR] VM \(error.localizedDescription)")
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
}

