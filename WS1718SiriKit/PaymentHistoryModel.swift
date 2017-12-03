//
//  PaymentModel.swift
//  WS1718SiriKit
//
//  Created by Susan Xue on 25/11/2017.
//  Copyright © 2017 RWTH Aachen University (Media Computing Group). All rights reserved.
//

import Foundation

class PaymentHistoryModel {
    //hard coding contact list for now
    static let contacts = ["Sally","Susan","Ajay","John Smith","John Green","Dave","Avocado"]
    static var paymentHistory = [Payment]()
    
    //returns an array of [INPerson] matched from a (partial) name, for disambuation in sirikit
    static func matchContacts(partialName: String) -> [String]{
        var result = [String]()
        for contact in contacts{
            if contact.range(of: partialName, options: .caseInsensitive) != nil {
                result.append(contact)
            }
        }
        return result
    }
    
    static func getPaymentHistory() -> [Payment] {
        return paymentHistory
    }
    
    static func addPayment(payee: String, amount: Double) {
        let newPayment = Payment(payee: payee, amount: amount)
        paymentHistory.append(newPayment)
  
        // persist the new payment in history file
        writeFile(data : payee+","+String(format:"%.1f", amount)+"\n")
        
        // Send a notification to the viewcontroller, which will call its update function
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PaymentTableViewController"), object: nil)
        
        // debug
         print("New payment added   "+newPayment.payee+": "+String(newPayment.amount))
    }
    
    static func addPayment(newPayment: Payment) {
        paymentHistory.append(newPayment)
        
        // persist the new payment in history file
        writeFile(data : newPayment.payee+","+String(format:"%.1f", newPayment.amount)+"\n")
        
        // Send a notification to the viewcontroller, which will call its update function
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PaymentTableViewController"), object: nil)
        
        // debug
        print("New payment added   "+newPayment.payee+": "+String(newPayment.amount))
    }

    static func deletePayment(rowNum: Int){
        paymentHistory.remove(at: rowNum)
        //TODO : might need to update the viewcontroller here
    }
    
    static func loadPaymentHistory() {
        // load sample payments
        let payment1 = Payment(payee: "Sally", amount: 50)
        let payment2 = Payment(payee: "Susan", amount: 20)
        let payment3 = Payment(payee: "Ajay", amount: 30)
        
        // add sample payments to history
        paymentHistory = [payment1,payment2,payment3]
        
        // read other payments from history file
        let history = readFile()
        
        // all payments are separated by new lines
        if(history.contains("\n")){
        let payments = history.split(separator: "\n")
        for payment in payments {
            // payee and amount is separated by comma (csv)
            if(payment.contains(",")){
                let record = payment.split(separator: ",")
                let payee = String(record[0]);
                let amount = Double(String(record[1]))!;
                paymentHistory.append(Payment(payee : payee, amount: amount))
            }
          }
        }
    }
    
    static func writeFile(data:String) {
        
        // get shared directory space
        let documentDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.rwth.siri")
        
        // create the destination url for the text file to be saved
        let fileURL = documentDirectory!.appendingPathComponent("siri_history6.txt")
        
        let text = readFile()+data
        do {
            // writing to disk
            try text.write(to: fileURL, atomically: false, encoding: .utf8)
            print("Wrote to file : " + data);
        } catch {
            print("Error writing to url:", fileURL, error)
        }
    }
    
    
    static func readFile()->String{
        
         // get shared directory space
         let documentDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.rwth.siri")
        
        // create the destination url for the text file to be read
        let fileURL = documentDirectory!.appendingPathComponent("siri_history6.txt")
            // reading from disk
            do {
                let fileContents = try String(contentsOf: fileURL)
                print("---- FILE CONTENTS ----")
                print(fileContents)
                print("-----------------------")
                return fileContents
            } catch {
                print("Error loading contents of:", fileURL, error)
            }
        return ""
    }

}
