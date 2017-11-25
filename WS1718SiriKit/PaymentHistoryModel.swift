//
//  PaymentModel.swift
//  WS1718SiriKit
//
//  Created by Susan Xue on 25/11/2017.
//  Copyright © 2017 RWTH Aachen University (Media Computing Group). All rights reserved.
//

import Foundation
class PaymentHistoryModel {
   
    var paymentHistory = [Payment]()
    
    func getPaymentHistory() -> [Payment] {
        return paymentHistory
    }
    
    func addPayment(payee: String, amount: Double) {
        newPayment = Payment(payee, amount)
        paymentHistory.append(newPayment)
    }

//    func deletePayment(){
//
//    }

    func loadPaymentHistory() -> [Payment]? {
        return nil
    }
    
    func loadSamplePaymentHistory() {
        let payment1 = Payment(payee: "Sally Bebawi", amount: 50)
        let payment2 = Payment(payee: "Susan Xue", amount: 20)
        let payment3 = Payment(payee: "Ajay", amount: 30)
        
        paymentHistory = [payment1,payment2,payment3]
    }
    

}
