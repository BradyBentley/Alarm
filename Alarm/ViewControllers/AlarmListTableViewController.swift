//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Brady Bentley on 12/3/18.
//  Copyright © 2018 Brady. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController, SwitchTableViewCellDelegate {

    // MARK: - Properties
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK: - Actions
    @IBAction func switchValueChanged(_ sender: UISwitch) {
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.shared.alarms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as? SwitchTableViewCell else { fatalError() }
        let alarm = AlarmController.shared.alarms[indexPath.row]
        cell.alarm = alarm
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarmToDelete = AlarmController.shared.alarms[indexPath.row]
            AlarmController.shared.delete(alarm: alarmToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let alarm = AlarmController.shared.alarms[indexPath.row]
        AlarmController.shared.toggledEnabled(for: alarm)
        cell.alarm = alarm
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     //IIDOO
        if segue.identifier == "ToAlarmDetail"{
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let destinationVC = segue.destination as? AlarmDetailTableViewController
            let alarm = AlarmController.shared.alarms[indexPath.row]
            destinationVC?.alarm = alarm
            
        }
    }


}
