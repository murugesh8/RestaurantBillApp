//
//  PaymentModel.swift
//  RestaurantBillPayementApp
//
//  Created by Murugesh on 24/01/24.
//

import Foundation



enum Split{
    case onePerson
    case individual
    case equally
}

enum PaymentMode{
    case cash
    case debitCard
    case creditCard
}


struct MenuItem {
    let name: String
    let price: Double
    let person: Int
}

struct Group:Identifiable {
    let id: Int
    let peopleCount: Int
    var items: [MenuItem]
    var split:Split
    var discountPercentage:Int
    var paymentMode:PaymentMode
}

struct BillDetails:Identifiable {
    var id = UUID()
    let name: String
    let discountAmount:Double
    let discountPercentage:Int
    let totalBillBeforeDiscount:Double
    let totalBillAfterDiscount:Double
    let splitDetails:[IndividualAmount]?
    let creditCardPercentage:Double?
    let creditCardCharges:Double?
    let totalPaid:Double
    let returnedAmount:Double
    let remainingBalanceAmount:Double
}

struct IndividualAmount:Identifiable{
    var id = UUID()
    let person:Int
    var toatlAmount: Double
}

