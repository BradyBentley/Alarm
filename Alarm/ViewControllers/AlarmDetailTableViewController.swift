//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by Brady Bentley on 12/3/18.
//  Copyright © 2018 Brady. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var enabledButton: UIButton!
    
    
    
    // MARK: - Properties
    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    var alarmIsOn: Bool?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        alarmIsOn = alarm?.enabled
    }
   
    
    // MARK: - Actions
    @IBAction func enabledButtonTapped(_ sender: Any) {
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard datePicker.date != Date(), textField.text != "",
        let name = textField.text, let fireDate = datePicker?.date,
        let enabled = enabledButton?.isEnabled else { return }
        
        if let alarm = alarm {
            AlarmController.shared.update(alarm: alarm, fireDate: fireDate, name: name, enabled: enabled)
        } else {
            AlarmController.shared.addAlarm(fireDate: fireDate, name: name, enabled: enabled, uuid: alarm?.uuid ?? "")
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data
    private func updateViews() {
        datePicker.date = alarm?.fireDate ?? Date()
        textField.text = alarm?.name
        
        if alarmIsOn == true {
            enabledButton.setTitle("On", for: .normal)
        } else {
            enabledButton.setTitle("Off", for: .normal)
        }
    }
    
}

