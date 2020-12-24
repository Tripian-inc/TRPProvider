//
//  MakeBookingUseCase.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 2020-12-09.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
import AdyenCSE
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
    func postBooking(completion: ((Result<GYGBookings?, Error>) -> Void)?)
}

public protocol BillingUseCase {
    
    func setBillingInfo(_ billing: GYGBilling)
    
    func setTravellerInfo(_ traveller: GYGTraveler)
    
}

public protocol PaymentUseCase {
    
    func getConfiguration(completion: ((Result<[GYGPaymentMethod], Error>) -> Void)?)
    
    func setCreditCard(card: GYGCard)
    
    func createAdyenKey() -> String?
    
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
    private(set) var cardInfo: GYGCard?
    private(set) var adyenToken: String?
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
    
    
    public func postBooking(completion: ((Result<GYGBookings?, Error>) -> Void)?) {
        
        guard let id = optionId, let date = bookingDateTime, let price = bookingPrice else {
            print("[Error] OptionId, dateTime or price is nil")
            return
        }
        
        GetYourGuideApi().booking(optionId: id,
                                  dateTime: date,
                                  price: "\(price)",
                                  categories: bookingCategry ?? [], bookingParameters: bookingParameters ?? []) { [weak self] result in
            switch result {
            case .success(let booking):
                self?.bookingInfo = booking
                completion?(.success(booking))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
}

extension TRPMakeBookingUseCases: BillingUseCase {
    
  
    
    public func setBillingInfo(_ billing: GYGBilling) {
        self.billingInfo = billing
    }
    
    public func setTravellerInfo(_ traveller: GYGTraveler) {
        self.travellerInfo = traveller
    }
    
}

extension TRPMakeBookingUseCases: PaymentUseCase {

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
    
    
    
    public func setCreditCard(card: GYGCard) {
        self.cardInfo = card
    }
    
    public func createAdyenKey() -> String?{
        
        guard let adyenCard = cardInfo else {
            print("[Error] Card is nil. You must card with setCreditCard function")
            return nil
        }
        
        guard let publicKey = publicKey else {
            print("[Error] PublicKey is nil. You must call getConfiguration() function")
            return nil
        }
        
        //Adyen Logic
        let card = ADYCard()
        card.holderName = adyenCard.holderName
        card.cvc = adyenCard.securityCode
        card.expiryYear = adyenCard.expiryYear
        card.expiryMonth = adyenCard.expiryMonth
        card.number = adyenCard.number
        card.generationtime = Date()
        
        if let encodedCard = card.encode() {
            let adyenToken = ADYEncrypter.encrypt(encodedCard, publicKeyInHex: publicKey) ?? ""
            if adyenToken.isEmpty {
                print("[Error] Adyen token is empty")
            }
            self.adyenToken = adyenToken
            paymentInfo = GYGPayment(data: adyenToken)
            return adyenToken
        }
        
        return nil
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
            print("[Error] BookingInfo Info is nil")
            return
        }
        
        GetYourGuideApi().cart(shoppingCartId: booking.shoppingCartID,
                               shoppingCartHash: booking.bookingHash,
                               billing: billing,
                               traveler: travellerInfo,
                               payment: payment)
    }
    
}
