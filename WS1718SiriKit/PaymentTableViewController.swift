//
//  PaymentTableViewController.swift
//  WS1718SiriKit
//
//  Created by Susan Xue on 25/11/2017.
//  Copyright © 2017 RWTH Aachen University (Media Computing Group). All rights reserved.
//

import Foundation
import UIKit

class PaymentTableViewController : UITableViewController {
    
    var model = PaymentHistoryModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.loadSamplePaymentHistory()
        
    }
    
    override func tableView(_ tableView: UITableView,
                               numberOfRowsInSection section: Int) -> Int
    {
        return model.getPaymentHistory().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier:
                "PaymentCellIdentifier") else {
                    fatalError("Could not dequeue a cell")
        }
        
        let payment = model.getPaymentHistory()[indexPath.row]
        cell.textLabel?.text = payment.payee + ": " + String(payment.amount)
        return cell
    }
    

}
