//
//  Settings.swift
//  Bottle
//
//  Created by Vandilson Lima on 02/07/20.
//  Copyright © 2020 klsoft. All rights reserved.
//

import Foundation

private func date(fromTime time: String) -> Date? {
    let values = time.split(separator: ":").map { Int($0) }
    let cal = Calendar.current
    let components = DateComponents(calendar: cal, hour: values[0], minute: values[1])
    return components.date
}

class Settings: Codable {
    var notification: Bool
    var wakeupTime: Date
    var sleepTime: Date
    var dailyGoal: Int
    var cupSize: Int

    init(notification: Bool = true,
                     wakeupTime: Date = date(fromTime: "8:00")!,
                     sleepTime: Date = date(fromTime: "23:00")!,
                     dailyGoal: Int = 2000,
                     cupSize: Int = 300) {
        self.notification = notification
        self.wakeupTime = wakeupTime
        self.sleepTime = sleepTime
        self.dailyGoal = dailyGoal
        self.cupSize = cupSize
    }

    static var current: Settings {
        guard let data = UserDefaults.standard.data(forKey: "settings") else {
            return Settings()
        }
        return try! JSONDecoder().decode(Settings.self, from: data)
    }

    func save() {
        do {
            let encoded = try JSONEncoder().encode(self)
            UserDefaults.standard.set(encoded, forKey: "settings")
        } catch let e {
            print(e.localizedDescription)
        }
    }
}

