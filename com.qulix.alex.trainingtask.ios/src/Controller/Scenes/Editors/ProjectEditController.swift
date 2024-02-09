//
//  ProjectEditController.swift
//  trainingtask
//
//  Created by Alex on 16.01.24.
//

import UIKit

/// контроллер редакотра проектов
class ProjectEditController: UIViewController {
    // MARK: - Root View
    private let projectEditView = ProjectEditView()
    
    // MARK: - Properties
    private var isNew: Bool
    private var project: Project
    private var updateTable: () -> Void
    
    private var nm: NetworkManager
    private var projectStore: ProjectStore
    private var settings: Settings
    
    // MARK: - Initializers
    /// стандартный инициализатор
    init(isNew: Bool, project: Project, updateTable: @escaping () -> Void, nm: NetworkManager, projectStore: ProjectStore, settings: Settings) {
        self.isNew = isNew
        self.project = project
        self.updateTable = updateTable
        self.nm = nm
        self.projectStore = projectStore
        self.settings = settings
        super.init(nibName: nil, bundle: nil)
    }
    
    /// не использовать
    /// - Warning: не использовать!!!!
    @available(*, deprecated, message: "Use init(isNew: Bool, project: Project, updateTable: @escaping () -> Void, nm: NetworkManager, projectStore: ProjectStore, settings: Settings) instead.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
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
    
    // MARK: - Methods
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
}
