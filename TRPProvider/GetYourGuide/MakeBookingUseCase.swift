//
//  MakeBookingUseCase.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 2020-12-09.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation

public protocol BookingOptionsUseCase {
    
    func setBookinOptionId(id: Int)
    
    func setBookingDate(_ date:String)
    
    func setBookingPrice(_ price:Double)
    
    func setBookingCategories(_ categories: [GYGBookingCategoryPropety])
    
}

public protocol BookingParametersUseCase {
    func setBookingParameters(_ bookingParameters: [GYGBookingParameterProperty])
}

public protocol PostBookingUseCase {
    func postBooking(completion: ((Result<GYGBookings, Error>) -> Void)?)
}


public class TRPMakeBookingUseCases {
    private(set) var optionId: Int?
    private(set) var bookingDateTime: String?
    private(set) var bookingPrice: Double?
    private(set) var bookingCategry: [GYGBookingCategoryPropety]?
    private(set) var bookingParameters: [GYGBookingParameterProperty]?
    
    public init() {}
}

extension TRPMakeBookingUseCases: BookingOptionsUseCase {
    
    public func setBookingPrice(_ price: Double) {
        self.bookingPrice = price
    }
    
    public func setBookinOptionId(id: Int) {
        self.optionId = id
    }
    
    public func setBookingDate(_ date: String) {
        self.bookingDateTime = date
    }
    
    public func setBookingCategories(_ categories: [GYGBookingCategoryPropety]) {
        self.bookingCategry = categories
    }
    
}

extension TRPMakeBookingUseCases: BookingParametersUseCase {

    public func setBookingParameters(_ bookingParameters: [GYGBookingParameterProperty]) {
        self.bookingParameters = bookingParameters
    }

}

extension TRPMakeBookingUseCases: PostBookingUseCase {
    
    
    public func postBooking(completion: ((Result<GYGBookings, Error>) -> Void)?) {
        
        guard let id = optionId, let date = bookingDateTime, let price = bookingPrice else {
            print("[Error] OptionId, dateTime or price is nil")
            return
        }
        
        GetYourGuideApi().booking(optionId: id,
                                  dateTime: date,
                                  price: "\(price)",
                                  categories: bookingCategry ?? [], bookingParameters: bookingParameters ?? []) { result in
            switch result {
            case .success(let booking):
                completion?(.success(booking))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    
}
