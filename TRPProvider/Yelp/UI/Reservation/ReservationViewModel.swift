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

public class ReservationViewModel {
    
    enum CellContentType {
        case date, time, people, alternativeTime
    }
    
    var numberOfCells: Int { return cellViewModels.count }
    var cellViewModels: [ReservationCellModel] = []
    
    public init() {}
    
    func start() {
        createData()
    }
    
    private func createData() {
        var cells = [ReservationCellModel]()
        cells.append(.init(title: "Date", contentType: .date))
        cells.append(.init(title: "Time", contentType: .time))
        cells.append(.init(title: "Party Size", contentType: .people))
        cells.append(.init(title: "Alternative Time", contentType: .alternativeTime))
        
        cellViewModels = cells
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> ReservationCellModel {
        return cellViewModels[indexPath.row]
    }
}
