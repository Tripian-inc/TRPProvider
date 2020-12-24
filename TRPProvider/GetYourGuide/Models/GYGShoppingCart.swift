//
//  GYGShoppingCart.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 2020-12-11.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
public struct GYGShoppingCart: Codable {
    public let shoppingCartID: Int
    //public let shoppingCartHash: String
    public let billing: GYGBilling
    public let traveler: GYGTraveler
    public let payment: GYGPayment
    
    enum CodingKeys: String, CodingKey {
        case shoppingCartID = "shopping_cart_id"
      //  case shoppingCartHash = "shopping_cart_hash"
        case billing, traveler, payment
    }
    
    
    
}

public struct GYGBilling: Codable {
    
    public let salutationCode, firstName, lastName, email: String
    public let isCompany: Bool
    public let companyName: String
    public let invoice: Bool
    public let addressLine1, addressLine2, city, postalCode: String
    public let state, countryCode, phoneNumber: String
    
    enum CodingKeys: String, CodingKey {
        case salutationCode = "salutation_code"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case isCompany = "is_company"
        case companyName = "company_name"
        case invoice
        case addressLine1 = "address_line_1"
        case addressLine2 = "address_line_2"
        case city
        case postalCode = "postal_code"
        case state
        case countryCode = "country_code"
        case phoneNumber = "phone_number"
    }
    
    
    public init(salutationCode: String,
                firstName: String,
                lastName: String,
                email: String,
                isCompany: Bool,
                companyName: String,
                invoice: Bool,
                addressLine1: String,
                addressLine2: String,
                city: String,
                postalCode: String,
                state: String,
                countryCode: String,
                phoneNumber: String) {
        self.salutationCode = salutationCode
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.isCompany = isCompany
        self.companyName = companyName
        self.invoice = invoice
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.city = city
        self.postalCode = postalCode
        self.state = state
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
    }
    
    public init(firstName: String,
                lastName: String,
                email: String,
                addressLine1: String,
                addressLine2: String,
                city: String,
                postalCode: String,
                state: String,
                countryCode: String,
                phoneNumber: String) {
        self.salutationCode = "m"
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.isCompany = false
        self.companyName = ""
        self.invoice = false
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.city = city
        self.postalCode = postalCode
        self.state = state
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
    }
    
    
    public static func makeMock() -> Self {
        return GYGBilling(firstName: "TestFirst",
                          lastName: "TestLast",
                          email: "necati@tripian.com",
                          addressLine1: "Adalet mah Ankara",
                          addressLine2: "",
                          city: "Istanbul",
                          postalCode: "34720",
                          state: "",
                          countryCode: "TR",
                          phoneNumber: "905339271371")
    }
}

// MARK: - Payment
public struct GYGPayment: Codable {
    public let encryptedCreditCard: GYGEncryptedCreditCard
    
    enum CodingKeys: String, CodingKey {
        case encryptedCreditCard = "encrypted_credit_card"
    }
    
    
    init(format: String = "adyen", data token: String) {
        self.encryptedCreditCard = GYGEncryptedCreditCard(format: format, data: token)
    }
    
}

// MARK: - EncryptedCreditCard
public struct GYGEncryptedCreditCard: Codable {
    public let format, data: String
    
    public init(format: String, data: String){
        self.format = format
        self.data = data
    }
}

// MARK: - Traveler
public struct GYGTraveler: Codable {
    
    
    public let salutationCode, firstName, lastName, email: String
    public let phoneNumber: String
    
    enum CodingKeys: String, CodingKey {
        case salutationCode = "salutation_code"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNumber = "phone_number"
    }
    
    public init(salutationCode: String, firstName: String, lastName: String, email: String, phoneNumber: String) {
        self.salutationCode = salutationCode
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
    }
    
    public init(billing: GYGBilling) {
        self.salutationCode = billing.salutationCode
        self.firstName = billing.firstName
        self.lastName = billing.lastName
        self.email = billing.email
        self.phoneNumber = billing.phoneNumber
    }
    
}
