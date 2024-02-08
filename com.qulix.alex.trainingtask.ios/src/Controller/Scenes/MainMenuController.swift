//
//  MainMenuController.swift
//  trainingtask
//
//  Created by Alex on 11.01.24.
//

import UIKit

class MainMenuController: UIViewController {
    private var menuView = MainMenuView()
    
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
        let projectListController = ProjectListController(
            nm: self.nm,
            projectStore: self.projectStore,
            employeeStore: self.employeeStore,
            settings: self.settings)
        navigationController?.show(projectListController, sender: self)
        
    }
    @objc private func openIssues() {
        let issueListController = IssueListController(
            nm: self.nm,
            projectStore: self.projectStore,
            employeeStore: self.employeeStore,
            settings: self.settings,
            openedFromProject: false)
        navigationController?.show(issueListController, sender: self)
    }
    @objc private func openEmployees() {
        let employeeListController = EmployeeListController(
            nm: self.nm,
            projectStore: self.projectStore,
            employeeStore: self.employeeStore,
            settings: self.settings)
        navigationController?.show(employeeListController, sender: self)
    }
    @objc private func openSettings() {
        let settingsController = SettingsController(settings: settings)
        navigationController?.show(settingsController, sender: self)
    }
    
    override func loadView() {
        super.loadView()
        self.view = menuView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        menuView.projects.addTarget(self, action: #selector(openProjects), for: .touchUpInside)
        menuView.issues.addTarget(self, action: #selector(openIssues), for: .touchUpInside)
        menuView.employees.addTarget(self, action: #selector(openEmployees), for: .touchUpInside)
        menuView.settings.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        self.navigationItem.title = Strings.mainMenu
    }
    
}

