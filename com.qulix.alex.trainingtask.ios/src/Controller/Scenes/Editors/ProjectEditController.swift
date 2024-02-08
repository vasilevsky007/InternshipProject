//
//  ProjectEditController.swift
//  trainingtask
//
//  Created by Alex on 16.01.24.
//

import UIKit

class ProjectEditController: UIViewController {
    
    private let projectEditView = ProjectEditView()
    
    private var isNew: Bool
    private var project: Project
    private var updateTable: () -> Void
    
    private var nm: NetworkManager
    private var projectStore: ProjectStore
    private var settings: Settings
    
    init(isNew: Bool, project: Project, updateTable: @escaping () -> Void, nm: NetworkManager, projectStore: ProjectStore, settings: Settings) {
        self.isNew = isNew
        self.project = project
        self.updateTable = updateTable
        self.nm = nm
        self.projectStore = projectStore
        self.settings = settings
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func saveProject() {
        project.name = projectEditView.nameField.enteredText ?? ""
        project.descriprion = projectEditView.descriptionField.enteredText ?? ""
        let progress = MyProgressViewController()
        progress.startLoad(with: Strings.saveMessage)
        if isNew {
            Task.detached {
                do {
                    try await self.projectStore.add(project: self.project, settings: self.settings)
                    try await self.nm.addProjectRequest(project: self.project)
                    await progress.stopLoad(successfully: true, with: Strings.saveDoneMessage)
                    DispatchQueue.main.async {
                        self.updateTable()
                        self.dismiss(animated: true)
                    }
                } catch {
                    await progress.stopLoad(successfully: false, with: Strings.error + error.localizedDescription)
                }
            }
        } else {
            Task.detached {
                do {
                    try await self.nm.changeProjectRequest(newValue: self.project)
                    await progress.stopLoad(successfully: true, with: Strings.saveDoneMessage)
                    DispatchQueue.main.async {
                        self.updateTable()
                        self.dismiss(animated: true)
                    }
                } catch {
                    await progress.stopLoad(successfully: false, with: Strings.error + error.localizedDescription)
                }
            }
        }
    }
    
    private func close() {
        self.updateTable()
        self.dismiss(animated: true)
    }
    
    override func loadView() {
        super.loadView()
        self.view = projectEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        projectEditView.nameField.enteredText = project.name
        projectEditView.descriptionField.enteredText = project.descriprion
        projectEditView.dialogBox.cancelAction = close
        projectEditView.dialogBox.saveAction = saveProject
    }
}
