//
//  MainMenuController.swift
//  trainingtask
//
//  Created by Alex on 11.01.24.
//

import UIKit

class MainMenuController: UIViewController {
    
    let nm: NetworkManager = NetworkStub()
    let projectStore = ProjectStore()
    let employeeStore = EmployeeStore()
    let settings: Settings = {
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
            case "OpenProjectList":
                if let projectListController = segue.destination as? ProjectListController {
                    projectListController.nm = self.nm
                    projectListController.projectStore = self.projectStore
                    projectListController.employeeStore = self.employeeStore
                    projectListController.settings = self.settings
                }
            case "OpenEmployeeList":
                if let employeeListController = segue.destination as? EmployeeListController {
                    employeeListController.nm = self.nm
                    employeeListController.projectStore = self.projectStore
                    employeeListController.employeeStore = self.employeeStore
                    employeeListController.settings = self.settings
                }
            case "OpenAllIssues":
                if let issueListController = segue.destination as? IssueListController {
                    issueListController.nm = self.nm
                    issueListController.projectStore = self.projectStore
                    issueListController.employeeStore = self.employeeStore
                    issueListController.settings = self.settings
                    issueListController.openedFromProject = false
                }
            default :
                break
            }
        }
    }
}

