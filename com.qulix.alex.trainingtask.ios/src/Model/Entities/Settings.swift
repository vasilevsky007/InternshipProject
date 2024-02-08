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
    
    static func loadFromPlist() -> Settings? {
        guard let plistURL = Bundle.main.url(forResource: "Settings", withExtension: "plist"),
              let plistData = try? Data(contentsOf: plistURL) else {
            print("Файл Settings.plist не найден или невозможно прочитать данные.")
            return nil
        }
        
        var settings = Settings()
        
        do {
            guard let plistDictionary = try PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any] else {
                print("Ошибка: Невозможно преобразовать данные plist в словарь.")
                return nil
            }
            
            if let serverString = plistDictionary["server"] as? String,
               let serverURL = URL(string: serverString) {
                settings.server = serverURL
            } else {
                print("Ошибка: Невозможно извлечь URL сервера.")
            }
            
            if let maxEntriesValue = plistDictionary["maxEntries"] as? Int {
                settings.maxEntries = maxEntriesValue
            } else {
                print("Ошибка: Невозможно извлечь максимальное количество записей.")
            }
            
            if let daysValue = plistDictionary["defaultIntervalBetweenStartAndEndInDays"] as? Int {
                settings.defaultIntervalBetweenStartAndEndInDays = daysValue
            } else {
                print("Ошибка: Невозможно извлечь время по умолчанию между началом и концом.")
            }
            
            return settings
        } catch {
            print("Ошибка при загрузке настроек из plist: \(error)")
            return nil
        }
    }
}
