//
//  Reservation.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 10.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
import UIKit
public class Reservation {
    
    private(set) var businessId: String
    public var covers: Int = 1
    public var date: String
    public var time: String
    //Burada generateedilebilir.
    public var uniqueId: String
    public var holdId: String?
    public var firstName: String?
    public var lastName: String?
    public var email: String?
    public var phone: String?

    public var isUserInfoValid: Bool {
        return firstName != nil &&
            lastName != nil &&
            email != nil &&
            phone != nil
    }
    
    public init(businessId id: String, covers: Int = 1, date: String, time: String, uniqueId: String) {
        self.businessId = id
        self.covers = covers
        self.date = date
        self.time = time
        self.uniqueId = uniqueId
    }
    
    convenience init(businessId id: String, covers: Int = 1, date: String, time: String) {
        let uniqueId = UIDevice.current.identifierForVendor?.uuidString ?? "asd"
        self.init(businessId: id,
                  covers: covers,
                  date: date,
                  time: time, uniqueId: uniqueId)
    }
    
    
    public func addUserInfo(firstName: String, lastName: String, email: String, phone: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
    }
    
}
