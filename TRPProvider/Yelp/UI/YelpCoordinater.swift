//
//  YelpCoordinater.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 13.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation

import UIKit
public class YelpCoordinater {
    
    private(set) var reservation: Reservation
    private(set) var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController,  reservation: Reservation) {
        self.navigationController = navigationController
        self.reservation = reservation
    }
    
    
}

//MARK: - RESERVATİON
extension YelpCoordinater {
    
    private func openReservationVC() {
        let viewModel = ReservationViewModel(date: reservation.date,
                                             time: reservation.time,
                                             covers: reservation.covers)
        let vc = ReservationViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    
}

//MARK: - USERINFO
extension YelpCoordinater {
    private func openUserInfoVC() {
        //let viewModel = ReservationUserInfoViewModel()
        
    }
}


//MARK: - SUCCESS
extension YelpCoordinater {
    
}
