//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Brady Bentley on 12/3/18.
//  Copyright © 2018 Brady. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol SwitchTableViewCellDelegate: class {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    var alarm: Alarm? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func updateView() {
        if let alarm = alarm {
            timeLabel.text = alarm.fireTimeAsString
            nameLabel.text = alarm.name
            alarmSwitch.isOn = alarm.enabled
        }
        
    }
    
    // MARK: - Actions
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        delegate?.switchCellSwitchValueChanged(cell: self)
    }
    

}
