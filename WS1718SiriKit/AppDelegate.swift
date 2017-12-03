//
//  AppDelegate.swift
//  WS1718SiriKit
//
//  Created by Susan Xue on 24/11/2017.
//  Copyright © 2017 RWTH Aachen University (Media Computing Group). All rights reserved.
//

import UIKit
import Intents

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        // Request for Siri usage
        INPreferences.requestSiriAuthorization { (status) in }
        
        // adding contact names to siri's vocabulary
        INVocabulary.shared().setVocabularyStrings(NSOrderedSet(array: PaymentHistoryModel.contacts), of: .contactName)
        
        return true

    }
}

