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
    
    func getReviewOrder() -> (title: String?, dateTime: String?, option:GYGTourOption?, price: Double?, people: [GYGBookingCategoryPropety]?)
    
    func getReviewOrders(completion: ((Result<[GYGReviewOrder], Error>) -> Void)?)
    
    func getConfiguration(completion: ((Result<[GYGPaymentMethod], Error>) -> Void)?)
    
    func setCreditCard(card: GYGCard)
    
    func createAdyenKey() -> String?
    
    func postCart(completion: ((Result<GYGPaymentResult?, Error>) -> Void)?)
    
}

public protocol CheckCardAndBookingUseCase {
    func removeOldBookingInCardIfNeedeed(completion: ((Result<Bool?, Error>) -> Void)?)
}

public class TRPMakeBookingUseCases {
    public var optionId: Int?
    public var bookingDateTime: String?
    public var bookingPrice: Double?
    public var bookingCategry: [GYGBookingCategoryPropety]?
    private(set) var bookingParameters: [GYGBookingParameterProperty]?
    
    private(set) var publicKey: String?
    public var bookingInfo: GYGBookings?
    private(set) var billingInfo: GYGBilling?
    private(set) var travellerInfo: GYGTraveler?
    private(set) var paymentInfo: GYGPayment?
    private(set) var cardInfo: GYGCard?
    private(set) var adyenToken: String?
    
    public var optionDataHolder: TourOptionDataHolder?
    public var tour: GYGTour?
    public var gygApi: GetYourGuideApi
    
    public init(gygApi: GetYourGuideApi) {
        self.gygApi = gygApi
    }
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
        
        gygApi.booking(optionId: id,
                                  dateTime: date,
                                  price: price,
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
    
    
    //Depreceted
    public func getReviewOrders(completion: ((Result<[GYGReviewOrder], Error>) -> Void)?) {
        guard let cardHash = bookingInfo?.bookingHash else {
            print("[Error] Card hash is nil")
            return
        }
        gygApi.getCart(hash: cardHash) { result in
            switch result {
            case .success(let card):
                
                var reviewOrders = [GYGReviewOrder]()
                
                if let bookings = card?.bookings {
                    bookings.forEach { booking in
                        self.gygApi.options(optionId: booking.bookable.optionID) { result in
                            switch result {
                            case .success(let option):
                                
                                let reviewOrder = GYGReviewOrder(title: option?.title,
                                                                 optionTitle: option?.title,
                                                                 bookable: booking.bookable,
                                                                 price: booking.bookable.price,
                                                                 people: booking.bookable.categories,
                                                                 status: booking.bookingStatus,
                                                                 dateTime: booking.bookable.datetime)
                                reviewOrders.append(reviewOrder)
                                if reviewOrders.count == bookings.count {
                                    completion?(.success(reviewOrders))
                                }
                                
                            case .failure(let error):
                                completion?(.failure(error))
                            }
                        }
                    }
                    
                }else {
                    completion?(.success([]))
                }
                
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    
    public func getReviewOrder() -> (title: String?,dateTime: String?, option: GYGTourOption?, price: Double?, people: [GYGBookingCategoryPropety]?) {
        let option = optionDataHolder?.tourOptions.first(where: {$0.optionID == (optionId ?? 0)})
        return (self.tour?.title, self.bookingDateTime, option, self.bookingPrice, self.bookingCategry)
    }
    
    public func getConfiguration(completion: ((Result<[GYGPaymentMethod], Error>) -> Void)?) {
        gygApi.paymentConfiguration { [weak self] result in
            switch result {
            case .success(let methods):
                
                if let encrytedMethod = methods.first(where: {$0.name == "encrypted_credit_card"}) {
                    self?.publicKey = encrytedMethod.publicKey
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
//        let card = Card(number: adyenCard.number, securityCode: adyenCard.securityCode, expiryMonth: adyenCard.expiryMonth, expiryYear: adyenCard.expiryYear, holder: adyenCard.holderName)
//        do {
//            let encrypted = try AdyenEncryption.CardEncryptor.encryptToken(from: card, with: publicKey)
//            if encrypted.isEmpty {
//                print("[Error] Adyen token is empty")
//                return nil
//            }
//            self.adyenToken = encrypted
//            paymentInfo = GYGPayment(data: encrypted)
//            return adyenToken
//        } catch {
//            return nil
//        }
        
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
    
    public func postCart(completion: ((Result<GYGPaymentResult?, Error>) -> Void)?) {
        
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
        
        gygApi.cart(shoppingCartId: booking.shoppingCartID,
                               shoppingCartHash: booking.bookingHash,
                               billing: billing,
                               traveler: travellerInfo,
                               payment: payment) { result in
            
            switch result {
            case .success(let payment):
                completion?(.success(payment))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
}

extension TRPMakeBookingUseCases: CheckCardAndBookingUseCase {
    
    
    public func removeOldBookingInCardIfNeedeed(completion: ((Result<Bool?, Error>) -> Void)?) {
        
        guard let booking = bookingInfo else {
            print("[Error] bookingInfo is nil")
            //TODO: requirement field ekranına gitmeden direkt billing işlemine devam edilirse booking yapılmıyordu. Bu yüzden şimdilik buraya eklendi. Süreç geliştirmesinde düzeltilebilir.
            self.postBooking(completion: nil)
            completion?(.success(false))
            return
        }
        
        gygApi.getCart(hash: booking.shoppingCartHash) { result in
            switch result {
            case .success(let payments):
                
                guard let _payments = payments else {return}
                if _payments.bookings.count < 2 {
                    completion?(.success(true))
                }else {
                    var removedCount = 0
                    
                    
                    _payments.bookings.forEach({ bookingInCard in
                        if bookingInCard.bookingID != booking.bookingID {
                            self.gygApi.deleteBooking(hash: bookingInCard.bookingHash) { deleteBookingResult in
                                switch deleteBookingResult {
                                case .success(_):
                                    removedCount += 1
                                    print("[info] Old Booking removed \(removedCount)")
                                    if ( _payments.bookings.count - 1) == removedCount {
                                        completion?(.success(true))
                                    }
                                    
                                case .failure(let error):
                                    print("[Error] Delete Booking \(error)")
                                }
                            }
                        }
                    })
                }
                
                
            case .failure(let error):
                completion?(.failure(error))
                print("[Error] GetCard \(error.localizedDescription)")
            }
            
        }
        
    }
    
    
    
}
