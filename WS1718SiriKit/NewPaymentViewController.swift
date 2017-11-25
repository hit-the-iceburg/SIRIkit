//
//  NewPaymentViewController.swift
//  WS1718SiriKit
//
//  Created by Susan Xue on 25/11/2017.
//  Copyright © 2017 RWTH Aachen University (Media Computing Group). All rights reserved.
//

import Foundation
import UIKit

class NewPaymentViewController : UITableViewController {
   
    @IBOutlet weak var selectContactButton: UIButton!
    @IBOutlet weak var contactNameField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButtonState()
    }
    
    //enable save button only if both contact or amount field are filled
    func updateSaveButtonState() {
        let contact = contactNameField.text ?? ""
        let amount = amountField.text ?? ""
        saveButton.isEnabled = !contact.isEmpty && !amount.isEmpty
    }
    
    // updates the save button availability with each keystroke
    @IBAction func contactFieldChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    @IBAction func amountFieldChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    // Pass values of the new payment back to the main ViewController
    var payment: Payment?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let contact = contactNameField.text!
        let amount = amountField.text!
        
        payment = Payment(payee: contact, amount: Double(amount)!)
    }
    
    //Dismiss keyboard when "return" is tapped
    @IBAction func contactReturnPressed(_ sender: UITextField) {
        contactNameField.resignFirstResponder()
    }

    
    
    

    
}
