//
//  Bottle.swift
//  Bottle
//
//  Created by Vandilson Lima on 05/07/20.
//  Copyright © 2020 klsoft. All rights reserved.
//

import Foundation

class Bottle {
    static let shared = Bottle()

    static let amountTakenKey = "bottle-level"

    var amountTaken: Int {
        get { UserDefaults.standard.integer(forKey: Bottle.amountTakenKey) }
        set { UserDefaults.standard.set(newValue, forKey: Bottle.amountTakenKey)}
    }

    var percentageFilled: Float {
        let settings = Settings.current
        let bottleSize = settings.dailyGoal
        let amountOfWater = bottleSize - amountTaken
        return Float(amountOfWater) / Float(bottleSize)
    }

    func removeCup(size: Int = Settings.current.cupSize) {
        amountTaken += size
    }

    func reset() {
        amountTaken = 0
    }
}

class DailyControl {

    static func check() {
        let key = "date"
        let defaults = UserDefaults.standard
        let now = Date()

        guard let bottleDate = defaults.object(forKey: key) as? Date else {
            Bottle.shared.reset()
            defaults.set(now, forKey: key)
            return
        }

        let calendar = Calendar.current
        let bc = calendar.dateComponents([.year, .month, .day], from: bottleDate)
        let nc = calendar.dateComponents([.year, .month, .day], from: now)

        if bc.year != nc.year || bc.month != nc.month || bc.day != nc.day {
            Bottle.shared.reset()
            defaults.set(now, forKey: key)
        }
    }
}
