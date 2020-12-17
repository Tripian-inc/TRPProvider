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

public protocol BillingUseCase {
    func getConfiguration(completion: ((Result<[GYGPaymentMethod], Error>) -> Void)?)
    
    func setBillingInfo(_ billing: GYGBilling)
    func setTravellerInfo(_ traveller: GYGTraveler)
}

public protocol PaymentUseCase {
     
    func setCreditCard(holderName: String?, number: String?, securityCode: String?, expiryMonth: String?, expiryYear: String)
    
    func postCart(completion: ((Result<GYGBookings, Error>) -> Void)?)
    
}


public class TRPMakeBookingUseCases {
    private(set) var optionId: Int?
    private(set) var bookingDateTime: String?
    private(set) var bookingPrice: Double?
    private(set) var bookingCategry: [GYGBookingCategoryPropety]?
    private(set) var bookingParameters: [GYGBookingParameterProperty]?
    
    private(set) var publicKey: String?
    private(set) var bookingInfo: GYGBookings?
    private(set) var billingInfo: GYGBilling?
    private(set) var travellerInfo: GYGTraveler?
    private(set) var paymentInfo: GYGPayment?
    
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

extension TRPMakeBookingUseCases: BillingUseCase {
    
    public func getConfiguration(completion: ((Result<[GYGPaymentMethod], Error>) -> Void)?) {
        GetYourGuideApi().paymentConfiguration { [weak self] result in
            switch result {
            case .success(let methods):
                if let key = methods.first?.publicKey {
                    self?.publicKey = key
                }
                completion?(.success(methods))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    public func setBillingInfo(_ billing: GYGBilling) {
        self.billingInfo = billing
    }
    
    public func setTravellerInfo(_ traveller: GYGTraveler) {
        self.travellerInfo = traveller
    }
    
}

extension TRPMakeBookingUseCases: PaymentUseCase {
    
    public func setCreditCard(holderName: String?,
                              number: String?,
                              securityCode: String?,
                              expiryMonth: String?,
                              expiryYear: String) {
        
        guard let publicKey = self.publicKey else {
            print("[Error] Please fetch PublicKey with getConfiguration()")
            return
        }
        
        let card = CardEncryptor.Card(number: number, securityCode: securityCode, expiryMonth: expiryMonth, expiryYear: expiryYear)
        
        let payment = GYGPayment(holderName: holderName ?? "", adyenCard: card, publicKey: publicKey)
        self.paymentInfo = payment
    }
    
    public func postCart(completion: ((Result<GYGBookings, Error>) -> Void)?) {
        
        guard let payment = paymentInfo else {
            print("[Error] Payment Info is nil")
            return
        }
        
        guard let billing = billingInfo else {
            print("[Error] Billing Info is nil")
            return
        }
        
        guard let booking = bookingInfo else {
            print("[Error] Billing Info is nil")
            return
        }
        
        GetYourGuideApi().cart(shoppingCartId: booking.shoppingCartID,
                               shoppingCartHash: booking.bookingHash,
                               billing: billing,
                               traveler: travellerInfo,
                               payment: payment)
    }
    
}
