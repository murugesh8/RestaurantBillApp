//
//  ContentView.swift
//  RestaurantBillPayementApp
//
//  Created by Murugesh on 23/01/24.
//

import SwiftUI

struct ContentView: View {
  
    @StateObject var paymentModel = PaymentViewModel()
    
    
    var body: some View {
        
        NavigationView {
            
            VStack{
                
                if paymentModel.billDetails.count > 0{
                    
                    ScrollView{
                        
                        ForEach(paymentModel.billDetails, id: \.id) { billDetails in
                            LazyVStack {
                                
                                Text("Group Name:\(billDetails.name)")
                                    .font(.headline)
                                
                                Text("Total Bill Before Discount: $\(String(format: "%.2f", billDetails.totalBillBeforeDiscount))")
                                
                                Text("Discount Percentage \(String(format: "%.2f", billDetails.discountPercentage)) %")

                                if let splitDetails = billDetails.splitDetails{
                                    ForEach(splitDetails,id:\.id) { individualAmount in
                                        
                                        Text("Recived amount person \(individualAmount.person): $\(String(format: "%.2f", individualAmount.toatlAmount))")
                                             
                                    }
                                }
                                
                                Text("Credit Card Charges Percentage: 1.2%")
                                
                                if let cardCharges =  billDetails.creditCardCharges{
                                    
                                    Text("Credit Card Charges Amount: \(String(format: "%.2f", cardCharges))")
                                    
                                }
                                
                                Text("Paid: $\(String(format: "%.2f", billDetails.totalPaid))")
                                Text("Returned: $\(String(format: "%.2f", billDetails.returnedAmount))")
                                Text("Remaining: $\(String(format: "%.2f", billDetails.remainingBalanceAmount))")
                                
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Invoice Details")
            .navigationBarTitleDisplayMode(.large)
            .onAppear(){
                
                // Add Group Into this array or Create a Layout for this input and pass value to this method will return the dynamic inovice details.
                let group1 = Group(id: 1, peopleCount: 3, items: [
                    MenuItem(name: "Big Brekkie", price: 16.0, person: 1),
                    MenuItem(name: "Big Brekkie", price: 16.0, person: 2),
                    MenuItem(name: "Bruchetta", price: 8.0, person: 3),
                    MenuItem(name: "Poached Eggs", price: 12.0, person: 3),
                    MenuItem(name: "Coffee", price: 5.0, person: 2),
                    MenuItem(name: "Tea", price: 3.0, person: 1),
                    MenuItem(name: "Soda", price: 4.0, person: 3),
                ], split: .individual, discountPercentage: 0, paymentMode: .debitCard)

                let group2 = Group(id: 2, peopleCount: 5, items: [
                    MenuItem(name: "Tea", price: 3.0, person: 1),
                    MenuItem(name: "Coffee", price: 3.0, person: 2),
                    MenuItem(name: "Soda", price: 4.0, person: 3),
                    MenuItem(name: "Big Brekkie", price: 16.0, person: 4),
                    MenuItem(name: "Poached Eggs", price: 12.0, person: 5),
                    MenuItem(name: "Garden Salad", price: 10.0, person: 1),
                ], split: .onePerson, discountPercentage: 10, paymentMode: .cash)

                let group3 = Group(id: 3, peopleCount: 7, items: [
                    MenuItem(name: "Tea", price: 3.0, person: 1),
                    MenuItem(name: "Coffee", price: 3.0, person: 2),
                    MenuItem(name: "Soda", price: 4.0, person: 3),
                    MenuItem(name: "Bruchetta", price: 8.0, person: 4),
                    MenuItem(name: "Big Brekkie", price: 16.0, person: 5),
                    MenuItem(name: "Poached Eggs", price: 12.0, person: 6),
                    MenuItem(name: "Garden Salad", price: 10.0, person: 7),
                ], split: .equally, discountPercentage: 25, paymentMode: .creditCard)

                paymentModel.calculateInvoice(groups: [group1,group2,group3])
                
            }

        }
    }
}

#Preview {
    ContentView()
}
