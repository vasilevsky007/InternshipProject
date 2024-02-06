//
//  SettingsController.swift
//  trainingtask
//
//  Created by Alex on 15.01.24.
//

import UIKit

class SettingsController: UIViewController {
    
    var settings: Settings!
    
    private func saveAction() {
        if let settingsView = self.view as? SettingsView {
            if let textUrl = settingsView.urlField.enteredText {
                if let serverUrl = URL(string: textUrl) {
                    settings.server = serverUrl
                }
            }
            if let textMaxEntries = settingsView.entriesField.enteredText {
                if let maxEntries = Int(textMaxEntries) {
                    settings.maxEntries = maxEntries
                }
            }
            if let textNumberOfDays = settingsView.daysField.enteredText {
                if let numberOfDays = Int(textNumberOfDays) {
                    settings.defaultIntervalBetweenStartAndEndInDays = numberOfDays
                }
            }
            
            if let encodedSettings = try? JSONEncoder().encode(settings) {
                UserDefaults.standard.set(encodedSettings, forKey: "settings")
            }
        }
    }
    
    private func cancelAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = SettingsView()
        view.dialogBox.saveAction = saveAction
        view.dialogBox.cancelAction = cancelAction
        view.urlField.enteredText = settings.server?.absoluteString
        view.entriesField.enteredText = settings.maxEntries.description
        view.daysField.enteredText = settings.defaultIntervalBetweenStartAndEndInDays.description
        self.view = view
    }
}
