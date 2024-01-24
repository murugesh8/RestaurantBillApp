//
//  PaymentViewModel.swift
//  RestaurantBillPayementApp
//
//  Created by Murugesh on 23/01/24.
//

import Foundation

class PaymentViewModel : ObservableObject{
    
    @Published var billDetails:[BillDetails] = []

    func calculateInvoice(groups: [Group]) {
       
        
        for group in groups {
            
            var subtotal = 0.0
            var individualAmount: [IndividualAmount] = []
            var discount = 0.0
            var sortedIndividualAmount : [IndividualAmount] = []
            var creditCardCharges:Double = 0.0
            var returnedAmount = 0.0 // Assuming no change given
            var remainingAmount = 0.0
            
            let totalPrice = group.items.map({$0.price}).reduce(0, +)

            // Calculate subtotal
            subtotal = totalPrice
            
            // Apply discounts and taxes
            var total = totalPrice
            
            print("Group \(group.id) Bill:")
            

            switch group.split {
                
            case .individual:
                // Group 1: Each person pays for their individual items
                print("Total Bill Before Discount: $\(total)")
                
                
                print("Discount Perscentage \(group.discountPercentage) %")
                
                let uniquePersonsAndPrices = Dictionary(grouping: group.items, by: { $0.person })
                    .mapValues { items in items.map { $0.price } }
                
                
                uniquePersonsAndPrices.forEach { person, prices in
                    let price = prices.reduce(0, +)
                    let individualAmt = IndividualAmount(person: person, toatlAmount: price)
                    individualAmount.append(individualAmt)
                }
                
                
                sortedIndividualAmount  = individualAmount.sorted { $0.person < $1.person }
                

                for item in sortedIndividualAmount {
                    print("Recived amount person \(item.person): $\(item.toatlAmount)")
                    
                }
                
                
            case .onePerson:
                // Group 2: 10% discount, one person pays the entire bill
                print("Total Bill Before Discount: $\(total)")

                print("Discount Perscentage \(group.discountPercentage) %")
                discount = total * (Double(group.discountPercentage)/100)
                total -= discount
                
            case .equally:
                // Group 3: $50 tab, $25 discount, split equally
                print("Total Bill Before Discount: $\(total)")

                print("Discount Perscentage \(group.discountPercentage) %")
                discount = subtotal * (Double(group.discountPercentage)/100)
                subtotal -= discount
                subtotal /= Double(group.peopleCount)
                total = subtotal * Double(group.peopleCount)
                var individual : [IndividualAmount] = []
                for i in 1...group.peopleCount {
                    print("Received amount for person \(i): $\(subtotal)")
                    individual.append(IndividualAmount(person: i, toatlAmount: subtotal))
                }
                
                sortedIndividualAmount = individual
                
            }
            
            
            print("Discount Amount: $\(discount)")
           
            print("Total Bill After Discount: $\(total)")

            if group.paymentMode == .creditCard{
                // Display transactions
              
                creditCardCharges = total * 0.012
                
                print("Credit Card Charges Percentage: 1.2%")
                
                print("Credit Card Charges Amount: \(creditCardCharges)")

                
                let paidAmount = total + (total * 0.012) // Include 1.2% surcharge for credit card
                
                
                print("Paid: $\(paidAmount), Returned: $\(returnedAmount), Remaining: $\(remainingAmount)")

            }else{
                
                let paidAmount = total  // Include 1.2% surcharge for credit card
                // Assuming total amount is paid

                print("Paid: $\(paidAmount), Returned: $\(returnedAmount), Remaining: $\(remainingAmount)")
            }
            print("\n")
            
            let billDetails =  BillDetails(name: "\(group.id)", discountAmount: discount, discountPercentage: group.discountPercentage, totalBillBeforeDiscount: subtotal, totalBillAfterDiscount: total, splitDetails: sortedIndividualAmount , creditCardPercentage: 1.2, creditCardCharges: creditCardCharges, totalPaid: total, returnedAmount:returnedAmount , remainingBalanceAmount: remainingAmount)
            
            self.billDetails.append(billDetails)
            
        }
    }
}
