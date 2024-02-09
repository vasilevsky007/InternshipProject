//
//  SettingsController.swift
//  trainingtask
//
//  Created by Alex on 15.01.24.
//

import UIKit

/// контролер страницы настроек
class SettingsController: UIViewController {
    // MARK: - Root View
    private var settingsView = SettingsView()
    
    // MARK: - Properties
    private var settings: Settings
    
    // MARK: - Initializers
    /// стандартный инициализатор
    /// - Attention: используйте только его для корректной работы
    /// - Parameter settings: редактируемый объект настроек
    init(settings: Settings) {
        self.settings = settings
        super.init(nibName: nil, bundle: nil)
    }
    
    /// не использовать
    /// - Warning: не использовать!!!!
    @available(*, deprecated, message: "Use init(settings: Settings) instead.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func loadView() {
        super.loadView()
        self.view = settingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsView.dialogBox.saveAction = saveAction
        settingsView.dialogBox.cancelAction = cancelAction
        settingsView.urlField.enteredText = settings.server.absoluteString
        settingsView.entriesField.enteredText = settings.maxEntries.description
        settingsView.daysField.enteredText = settings.defaultIntervalBetweenStartAndEndInDays.description
    }
    
    // MARK: - Methods
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
                UserDefaults.standard.set(encodedSettings, forKey: Strings.userdefaultsSettingsKey)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func cancelAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
