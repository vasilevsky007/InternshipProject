//
//  MainMenuController.swift
//  trainingtask
//
//  Created by Alex on 11.01.24.
//

import UIKit

class MainMenuController: UIViewController {
    
    let settings = {
        if let settingsEncoded = UserDefaults.standard.data(forKey: "settings") {
            if let savedSettings = try? JSONDecoder().decode(Settings.self, from: settingsEncoded) {
                return savedSettings
            }
        }
        return Settings()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch id {
            case "OpenSettings":
                if let settingsController = segue.destination as? SettingsController {
                    settingsController.settings = settings
                }
            default :
                break
            }
        }
    }
}

