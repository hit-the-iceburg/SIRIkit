//
//  IntentHandler.swift
//  SiriPayment
//
//  Created by Susan Xue on 24/11/2017.
//  Copyright © 2017 RWTH Aachen University (Media Computing Group). All rights reserved.
//

import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension {}

/** Questions to ask:
     1) "Add the Siri feature to your app ID" fail
     2) My personal iphone is not authorized? Can't use it to test the app
     3) Why doesn't the payment added in IntentHandler by Siri show up in the UI?
 **/

extension IntentHandler : INSendPaymentIntentHandling {
    
    //resolving payee
    func resolvePayee(for intent: INSendPaymentIntent, with completion: @escaping (INSendPaymentPayeeResolutionResult) -> Void) {
        if let payee = intent.payee {
            let matchedContacts = PaymentHistoryModel.matchContacts(partialName: payee.displayName)
            
            switch matchedContacts.count {
            case 0:
                completion(INSendPaymentPayeeResolutionResult.unsupported(forReason: .noAccount))
            
            case 1:
                completion(INSendPaymentPayeeResolutionResult.success(with: payee))
                
            case 2 ... Int.max:
                var possiblePayees = [INPerson]()
                for contact in matchedContacts {
                    let person = INPerson.init(personHandle: INPersonHandle.init(value: contact, type: INPersonHandleType.unknown), nameComponents: nil, displayName: contact, image: nil, contactIdentifier: nil, customIdentifier: nil)
                    possiblePayees.append(person)
                }
                completion(INSendPaymentPayeeResolutionResult.disambiguation(with: possiblePayees))
                
            default:
                break
            }
            
            //            if(PaymentHistoryModel.contacts.contains(payee.displayName)){
            //                completion(INSendPaymentPayeeResolutionResult.success(with: payee))
            //            }
            //            else {
            //                completion(INSendPaymentPayeeResolutionResult.unsupported(forReason: .noAccount))
            //            }
            
        }
        else {
            completion(INSendPaymentPayeeResolutionResult.needsValue())
        }
    }
    
    //resolving amount
    func resolveCurrencyAmount(for intent: INSendPaymentIntent, with completion: @escaping (INSendPaymentCurrencyAmountResolutionResult) -> Void) {
        
        //need to test how it acts without a value. This one might not have
        if let amount = intent.currencyAmount {
                completion(INSendPaymentCurrencyAmountResolutionResult.success(with: amount))
        }
        else {
                completion(INSendPaymentCurrencyAmountResolutionResult.needsValue())
        }
    }
    
    //might want to add confirm

    
    func handle(intent: INSendPaymentIntent, completion: @escaping (INSendPaymentIntentResponse) -> Void) {
        guard let amount = intent.currencyAmount?.amount?.doubleValue,
              let payee = intent.payee?.displayName
        else {
                completion(INSendPaymentIntentResponse(code: .failure, userActivity: nil))
                return
        }
        
        PaymentHistoryModel.addPayment(payee: payee, amount: amount)
        completion(INSendPaymentIntentResponse(code: .success, userActivity:nil))
    }
    
}



