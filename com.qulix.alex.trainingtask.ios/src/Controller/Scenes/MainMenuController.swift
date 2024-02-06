//
//  MainMenuController.swift
//  trainingtask
//
//  Created by Alex on 11.01.24.
//

import UIKit

class MainMenuController: UIViewController {
    
    private let nm: NetworkManager = NetworkStub()
    private let projectStore = ProjectStore()
    private let employeeStore = EmployeeStore()
    private let settings: Settings = {
        if let settingsEncoded = UserDefaults.standard.data(forKey: Strings.userdefaultsSettingsKey) {
            if let savedSettings = try? JSONDecoder().decode(Settings.self, from: settingsEncoded) {
                return savedSettings
            }
        }
        return Settings() //TODO: load from file
    }()
    
    @objc private func openProjects() {
        let projectListController = ProjectListController()
        projectListController.nm = self.nm
        projectListController.projectStore = self.projectStore
        projectListController.employeeStore = self.employeeStore
        projectListController.settings = self.settings
        navigationController?.show(projectListController, sender: self)
        
    }
    @objc private func openIssues() {
        let issueListController = IssueListController()
        issueListController.nm = self.nm
        issueListController.projectStore = self.projectStore
        issueListController.employeeStore = self.employeeStore
        issueListController.settings = self.settings
        issueListController.openedFromProject = false
        navigationController?.show(issueListController, sender: self)
    }
    @objc private func openEmployees() {
        let employeeListController = EmployeeListController()
        employeeListController.nm = self.nm
        employeeListController.projectStore = self.projectStore
        employeeListController.employeeStore = self.employeeStore
        employeeListController.settings = self.settings
        navigationController?.show(employeeListController, sender: self)
    }
    @objc private func openSettings() {
        let settingsController = SettingsController()
        settingsController.settings = settings
        navigationController?.show(settingsController, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let view = MainMenuView()
        view.projects.addTarget(self, action: #selector(openProjects), for: .touchUpInside)
        view.issues.addTarget(self, action: #selector(openIssues), for: .touchUpInside)
        view.employees.addTarget(self, action: #selector(openEmployees), for: .touchUpInside)
        view.settings.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        self.view = view
        self.navigationItem.title = Strings.mainMenu
    }
    
}

