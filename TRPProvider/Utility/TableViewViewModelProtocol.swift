//
//  TableViewViewModelProtocol.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 23.01.2022.
//  Copyright © 2022 Tripian Inc. All rights reserved.
//

import Foundation
public protocol TableViewViewModelProtocol {
    
    associatedtype T
    
    var cellViewModels: [T] { get }
    
    var numberOfCells: Int { get }
    
    func getCellViewModel(at indexPath: IndexPath) -> T
    
    func getImageUrl(at indexPath: IndexPath, width: Int, height: Int) -> URL?
}

extension TableViewViewModelProtocol {
    
    public func getImageUrl(at indexPath: IndexPath, width: Int, height: Int) -> URL? {return nil}
    
}
