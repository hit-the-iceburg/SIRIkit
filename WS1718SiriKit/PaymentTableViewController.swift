//
//  PaymentTableViewController.swift
//  WS1718SiriKit
//
//  Created by Susan Xue on 25/11/2017.
//  Copyright © 2017 RWTH Aachen University (Media Computing Group). All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
    public static let myNotificationKey = Notification.Name(rawValue: "PaymentTableViewController")
}

class PaymentTableViewController : UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.update(_:)), name: .myNotificationKey, object: nil)
        //debug
        print("VC registered in notification center")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PaymentHistoryModel.loadSamplePaymentHistory()
        navigationItem.leftBarButtonItem = editButtonItem
        
    }
    
    // Update function to be called when notification is received from the model
    @objc func update(_ notification: Notification) {
        //debug
        print("update function called")
        //debug
        tableView.reloadData()
    }
    
    func displayPayment(payment : Payment){
        let newIndexPath = IndexPath(row: PaymentHistoryModel.getPaymentHistory().count, section: 0)
        PaymentHistoryModel.addPayment(newPayment: payment)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    
    //Display contents
    override func tableView(_ tableView: UITableView,
                               numberOfRowsInSection section: Int) -> Int
    {
        return PaymentHistoryModel.getPaymentHistory().count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier:
                "PaymentCellIdentifier") else {
                    fatalError("Could not dequeue a cell")
        }
        
        let payment = PaymentHistoryModel.getPaymentHistory()[indexPath.row]
        cell.textLabel?.text = payment.payee + ": " + String(payment.amount)
        return cell
    }
    
    //enable deleting
    override func tableView(_ tableView: UITableView, canEditRowAt
        indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit
        editingStyle: UITableViewCellEditingStyle, forRowAt indexPath:
        IndexPath) {
        if editingStyle == .delete {
            // hand this over to the model
            PaymentHistoryModel.deletePayment(rowNum: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // Receive and unwind values from NewPaymentViewController
    @IBAction func unwindToPaymentHistory(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! NewPaymentViewController
        
        if let payment = sourceViewController.payment {
            PaymentHistoryModel.addPayment(newPayment: payment)
        }
    }


}
