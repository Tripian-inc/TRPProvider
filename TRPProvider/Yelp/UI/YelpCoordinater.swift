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
    private var reservationViewController: ReservationViewController?
    
    public init(navigationController: UINavigationController,  reservation: Reservation) {
        self.navigationController = navigationController
        self.reservation = reservation
    }
    
    public func start() {
        openReservationVC()
    }
}

//MARK: - RESERVATİON
extension YelpCoordinater: ReservationViewControllerDelegate {
    
    private func openReservationVC() {
        let viewModel = ReservationViewModel(date: reservation.date,
                                             time: reservation.time,
                                             covers: reservation.covers)
        reservationViewController = ReservationViewController(viewModel: viewModel)
        reservationViewController!.delegate = self
        viewModel.delegate = reservationViewController!
        viewModel.start()
        navigationController.pushViewController(reservationViewController!, animated: true)
    }
    
    public func reservationViewControllerContinues() {
        openUserInfoVC()
    }
    
}

//MARK: - USERINFO
extension YelpCoordinater {
    private func openUserInfoVC() {
        let viewModel = ReservationUserInfoViewModel(userName: reservation.firstName, lastName: reservation.lastName, email: reservation.email, phone: reservation.phone)
        let viewController = ReservationUserInfoViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}


//MARK: - SUCCESS
extension YelpCoordinater {
    
}
