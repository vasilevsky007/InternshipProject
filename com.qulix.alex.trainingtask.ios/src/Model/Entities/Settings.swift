//
//  Settings.swift
//  trainingtask
//
//  Created by Alex on 11.01.24.
//

import Foundation

class Settings: Codable {
    var server = URL(string: "http://example.com")
    var maxEntries = 100
    private(set) var defaultBetweenStartAndEnd: TimeInterval = 86400//sec = 1 day
    
    
    
    var defaultIntervalBetweenStartAndEndInDays: Int {
        set {
            defaultBetweenStartAndEnd = Double(newValue) * 86400
        }
        get {
            Int(defaultBetweenStartAndEnd) / 86400
        }
    }
}
