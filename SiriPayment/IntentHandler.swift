//
//  IntentHandler.swift
//  SiriPayment
//
//  Created by Susan Xue on 24/11/2017.
//  Copyright © 2017 RWTH Aachen University (Media Computing Group). All rights reserved.
//

import Intents

class IntentHandler: INExtension {}

extension IntentHandler : INSendPaymentIntentHandling {
    
    //resolving payee
    func resolvePayee(for intent: INSendPaymentIntent, with completion: @escaping (INSendPaymentPayeeResolutionResult) -> Void) {
        if let payee = intent.payee {
            let matchedContacts = PaymentHistoryModel.matchContacts(partialName: payee.displayName)
            
            switch matchedContacts.count {
            // case payee doesn't exist in our contact list
            case 0:
                completion(INSendPaymentPayeeResolutionResult.unsupported(forReason: .noAccount))
            // case we match the payee exactly
            case 1:
                completion(INSendPaymentPayeeResolutionResult.success(with: payee))
            // case we have more than one possible match, need user to choose the correct one
            case 2 ... Int.max:
                var possiblePayees = [INPerson]()
                for contact in matchedContacts {
                    let person = INPerson.init(personHandle: INPersonHandle.init(value: contact, type: INPersonHandleType.unknown), nameComponents: nil, displayName: nil, image: nil, contactIdentifier: nil, customIdentifier: nil)
                    possiblePayees.append(person)
                }
                completion(INSendPaymentPayeeResolutionResult.disambiguation(with: possiblePayees))
                
            default:
                break
            }
        }
        else {  // user didn't provide a payee, prompt them to do so
            completion(INSendPaymentPayeeResolutionResult.needsValue())
        }
    }
    
    //resolving payment amount
    func resolveCurrencyAmount(for intent: INSendPaymentIntent, with completion: @escaping (INSendPaymentCurrencyAmountResolutionResult) -> Void) {
        
        if let amount = intent.currencyAmount {
                completion(INSendPaymentCurrencyAmountResolutionResult.success(with: amount))
        }
        else {
                completion(INSendPaymentCurrencyAmountResolutionResult.needsValue())
        }
    }
    
    // Confirm. In our case we don't need one since we are only making dummy payments, but it can be used for many purposes:
    func confirm(intent: INSendPaymentIntent, completion: @escaping (INSendPaymentIntentResponse) -> Void) {
        // check network status
        // check authentication status from the user
        completion(INSendPaymentIntentResponse(code: .success, userActivity: nil))
    }
    
    
    // Actual handling of the payment
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



