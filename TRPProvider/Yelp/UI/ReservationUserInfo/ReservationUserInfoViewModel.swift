//
//  ReservationUserInfoViewModel.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 8.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation

struct ReservationUserInfoCellModel {
    var title: String
    var contentType: ReservationUserInfoViewModel.CellContentType
}

public class ReservationUserInfoViewModel {
    
    enum CellContentType {
        case userName, lastName, email, phone
    }
    
    var numberOfCells: Int { return cellViewModels.count }
    var cellViewModels: [ReservationUserInfoCellModel] = []
    
    public init() {}
    
    public func start() {
        createData()
    }
    
    private func createData() {
        var cells = [ReservationUserInfoCellModel]()
        cells.append(.init(title: "Name", contentType: .userName))
        cells.append(.init(title: "Last Name", contentType: .lastName))
        cells.append(.init(title: "Email", contentType: .email))
        cells.append(.init(title: "Phone", contentType: .phone))
        cellViewModels = cells
    }
    
    
    func getCellViewModel(at indexPath: IndexPath) -> ReservationUserInfoCellModel {
        return cellViewModels[indexPath.row]
    }
}
