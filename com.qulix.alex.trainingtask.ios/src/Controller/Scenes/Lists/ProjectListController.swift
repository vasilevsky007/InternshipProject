//
//  ProjectListController.swift
//  trainingtask
//
//  Created by Alex on 16.01.24.
//

import UIKit

class ProjectListController: UIViewController {
    
    var nm: NetworkManager!
    var projectStore: ProjectStore!
    var employeeStore: EmployeeStore!
    var settings: Settings!
    
    private var table: UITableView!
    

    @objc private func reloadTable() {
        let progress = MyProgressViewController()
        progress.startLoad(with: Strings.updateMessage)
        Task.detached {
            do {
                let (projects, employees) = try await self.nm.fetchAll()
                await self.projectStore.deleteAll()
                await self.employeeStore.deleteAll()
                for project in projects {
                    try await self.projectStore.add(project: project, settings: self.settings)
                }
                for employee in employees {
                    try await self.employeeStore.add(employee: employee, settings: self.settings)
                }
                await self.table.reloadData()
                await progress.stopLoad(successfully: true, with: Strings.updateDoneMessage)
            } catch {
                await progress.stopLoad(successfully: false, with: Strings.error + error.localizedDescription)
            }
        }
    }
    
    @objc private func addProject() {
        let newProject = Project()
        let editor = ProjectEditController()
        editor.nm = nm
        editor.projectStore = projectStore
        editor.settings = settings
        editor.isNew = true
        editor.project = newProject
        editor.updateTable = table.reloadData
        editor.modalPresentationStyle = .pageSheet
        present(editor, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = ListView()
        self.table = view.table
        view.controls.reloadAction = reloadTable
        view.controls.addAction = addProject
        self.navigationItem.title = Strings.projets
        self.view = view
        table.dataSource = self
        table.delegate = self
        table.register(ProjectListCell.self, forCellReuseIdentifier: Strings.projectCellId)
        // Do any additional setup after loading the view.
    }
}

extension ProjectListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        projectStore.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.projectCellId, for: indexPath)
        if let projectListCell = cell as? ProjectListCell {
            projectListCell.nm = nm
            projectListCell.projectStore = projectStore
            projectListCell.employeeStore = employeeStore
            projectListCell.settings = settings
            projectListCell.updateTable = table.reloadData
            projectListCell.present = { view in
                self.present(view, animated: true)
            }
            projectListCell.setup(forProjectAtIndex: indexPath.row)
            projectListCell.openIssues = {
                let issueListController = IssueListController()
                issueListController.nm = self.nm
                issueListController.projectStore = self.projectStore
                issueListController.employeeStore = self.employeeStore
                issueListController.settings = self.settings
                issueListController.openedFromProject = true
                issueListController.project = self.projectStore.items[indexPath.row]
                self.navigationController?.show(issueListController, sender: self)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completionHandler) in
            let progress = MyProgressViewController()
            progress.startLoad(with: Strings.deleteMessage)
            let project = self.projectStore.items[indexPath.row]
            self.projectStore.delete(project: project)
            self.table.reloadData()
            Task.detached {
                do {
                    try await self.nm.deleteProjectRequest(project)
                    await progress.stopLoad(successfully: true, with: Strings.deleteDoneMessage)
                } catch {
                    await progress.stopLoad(successfully: false, with: Strings.error + error.localizedDescription)
                }
            }
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: Strings.deleteImage)
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
}
