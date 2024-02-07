//
//  ProjectEditController.swift
//  trainingtask
//
//  Created by Alex on 16.01.24.
//

import UIKit

class ProjectEditController: UIViewController {
    
    var isNew: Bool = true
    var project: Project!
    var updateTable: () -> Void = {}
    
    var nm: NetworkManager!
    var projectStore: ProjectStore!
    var settings: Settings!
    
    private func saveProject() {
        let projectEditView = self.view as! ProjectEditView
        project.name = projectEditView.nameField.enteredText ?? ""
        project.descriprion = projectEditView.descriptionField.enteredText ?? ""
        let progress = MyProgressViewController()
        progress.startLoad(with: "Saving project to server")
        if isNew {
            Task.detached {
                do {
                    try await self.projectStore.add(project: self.project, settings: self.settings)
                    try await self.nm.addProjectRequest(project: self.project)
                    await progress.stopLoad(successfully: true, with: "Project saved to server")
                    DispatchQueue.main.async {
                        self.updateTable()
                        self.dismiss(animated: true)
                    }
                } catch {
                    await progress.stopLoad(successfully: false, with: "Error: \(error.localizedDescription)")
                }
            }
        } else {
            Task.detached {
                do {
                    try await self.nm.changeProjectRequest(newValue: self.project)
                    await progress.stopLoad(successfully: true, with: "Project saved to server")
                    DispatchQueue.main.async {
                        self.updateTable()
                        self.dismiss(animated: true)
                    }
                } catch {
                    await progress.stopLoad(successfully: false, with: "Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func close() {
        self.updateTable()
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = ProjectEditView()
        view.nameField.enteredText = project.name
        view.descriptionField.enteredText = project.descriprion
        view.dialogBox.cancelAction = close
        view.dialogBox.saveAction = saveProject
        self.view = view
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
