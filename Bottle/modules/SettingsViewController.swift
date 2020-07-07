//
//  SettingsViewController.swift
//  Bottle
//
//  Created by Vandilson Lima on 26/06/20.
//  Copyright © 2020 klsoft. All rights reserved.
//

import UIKit
import Eureka

class SettingsViewController: FormViewController {

    var formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()

    var onChange: (() ->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        let settings = Settings.current

        form
            +++ Section("Notifications")
            <<< SwitchRow("reminder", { row in
                row.title = "Remind me to drink water"
                row.value = settings.notification
            })
            <<< TimeInlineRow("wakeup", { row in
                row.title = "Wake up"
                row.value = settings.wakeupTime
            })
            <<< TimeInlineRow("sleep", { row in
                row.title = "Sleep"
                row.value = settings.sleepTime
            })

            +++ Section("Drink")
            <<< SliderRow("goal", { row in
                row.title = "Daily goal (ml)"
                row.cell.slider.maximumValue = 4000
                row.cell.slider.minimumValue = 1500
                row.steps = 25
                row.value = Float(settings.dailyGoal)
            })
            <<< SliderRow("cup", { row in
                row.title = "Cup size (ml)  "
                row.cell.slider.maximumValue = 600
                row.cell.slider.minimumValue = 250
                row.steps = 7
                row.value = Float(settings.cupSize)
            })
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let notificationRow: SwitchRow = form.rowBy(tag: "reminder")!
        let wakeUpRow: TimeInlineRow = form.rowBy(tag: "wakeup")!
        let sleepRow: TimeInlineRow = form.rowBy(tag: "sleep")!
        let goalRow: SliderRow = form.rowBy(tag: "goal")!
        let cupRow: SliderRow = form.rowBy(tag: "cup")!

        let settings = Settings(
            notification: notificationRow.value!,
            wakeupTime: wakeUpRow.value!,
            sleepTime: sleepRow.value!,
            dailyGoal: Int(goalRow.value!),
            cupSize: Int(cupRow.value!)
        )
        settings.save()
        NotificationScheduler.shared.schedule()
        onChange?()
    }
}
