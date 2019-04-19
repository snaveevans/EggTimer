//
//  Preferences.swift
//  EggTimer
//
//  Created by Tyler Evans on 1/14/19.
//  Copyright © 2019 Tyler Evans. All rights reserved.
//

import Foundation

struct Preferences {
    
    // 1
    var selectedTime: TimeInterval {
        get {
            // 2
            let savedTime = UserDefaults.standard.double(forKey: "selectedTime")
            if savedTime > 0 {
                return savedTime
            }
            // 3
            return 360
        }
        set {
            // 4
            UserDefaults.standard.set(newValue, forKey: "selectedTime")
        }
    }
    
}

