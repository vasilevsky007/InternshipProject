//
//  Settings.swift
//  trainingtask
//
//  Created by Alex on 11.01.24.
//

import Foundation

struct Settings {
    var Server = URL(string: "http://example.com")
    var maxEntries = 100
    private(set) var defaultBetweenStartAndEnd: TimeInterval = 86400//sec = 1 day
    
    mutating func setDefaultIntervalBetweenStartAndEnd(days: Int) {
        defaultBetweenStartAndEnd = Double(days) * 86400
    }
}
