//
//  AlarmController.swift
//  Alarm
//
//  Created by Brady Bentley on 12/3/18.
//  Copyright © 2018 Brady. All rights reserved.
//

import Foundation
import UserNotifications

protocol AlarmScheduler: class {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Alarm Went Off"
        content.body = "What are you supposed to be doing?"
        
        let fireDate = alarm.fireDate
        let dateComponents = Calendar.current.dateComponents([.hour, .day, .minute, .second], from: fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("There was an error in \(#function) \(error) : \(error.localizedDescription)")
            }
            
        }
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}

class AlarmController {
    
    // MARK: - Properties
    
    // Shared Instances
    static let shared = AlarmController()
    
    // Source of Truth
    var alarms: [Alarm] = []
    
    init() {
        alarms = loadFromPersistentStore()
    }
    
//    init() {
//        self.alarms = mockAlarms
//    }
    var mockAlarms: [Alarm] {
        let alarm1 = Alarm(fireDate: Date(timeIntervalSinceNow: 12000), name: "Wake Up", enabled: true)
        let alarm2 = Alarm(fireDate: Date(timeIntervalSinceNow: 4000), name: "Have a great day", enabled: true)
        let alarm3 = Alarm(fireDate: Date(timeIntervalSinceNow: 80000), name: "Take a Shower", enabled: true)
        return [alarm1, alarm2, alarm3]
    }
    
    // MARK: - CRUD Functions
    func addAlarm(fireDate: Date, name: String, enabled: Bool, uuid: String = UUID().uuidString) {
        let newAlarm = Alarm(fireDate: fireDate, name: name, enabled: enabled, uuid: uuid)
        alarms.append(newAlarm)
        saveToPersistentStore()
    }
    
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
        saveToPersistentStore()
    }
    
    func delete(alarm: Alarm) {
        guard let indexPath = alarms.index(of: alarm) else { return }
        alarms.remove(at: indexPath)
        saveToPersistentStore()
        cancelUserNotifications(for: alarm)
    }
    
    func toggledEnabled(for alarm: Alarm) {
        if alarm.enabled == true {
            scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
        alarm.enabled.toggle()
        saveToPersistentStore()
    }
    private func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let fileName = "alarms.json"
        let fullURL = documentsDirectory.appendingPathComponent(fileName)
        print(fullURL)
        
        return fullURL
    }
    
    private func saveToPersistentStore() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self.alarms)
            
            try data.write(to: fileURL())
        } catch {
            print("There was an error in \(#function) \(error) : \(error.localizedDescription)")
        }
    }
    
    func loadFromPersistentStore() -> [Alarm] {
        do {
            let data = try Data(contentsOf: fileURL())
            
            let decoder = JSONDecoder()
            let alarms = try decoder.decode([Alarm].self, from: data)
            return alarms
        } catch {
            print("There was an error in \(#function) \(error) : \(error.localizedDescription)")
        }
        return []
    }
}

extension AlarmController: AlarmScheduler {
    
}
