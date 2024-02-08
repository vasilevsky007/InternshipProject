//
//  ProjectListController.swift
//  trainingtask
//
//  Created by Alex on 16.01.24.
//

import UIKit

class ProjectListController: UIViewController {
    
    private var listView = ListView()
    
    private var nm: NetworkManager
    private var projectStore: ProjectStore
    private var employeeStore: EmployeeStore
    private var settings: Settings
    
    init(nm: NetworkManager, projectStore: ProjectStore, employeeStore: EmployeeStore, settings: Settings) {
        self.nm = nm
        self.projectStore = projectStore
        self.employeeStore = employeeStore
        self.settings = settings
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                await self.listView.table.reloadData()
                await progress.stopLoad(successfully: true, with: Strings.updateDoneMessage)
            } catch {
                await progress.stopLoad(successfully: false, with: Strings.error + error.localizedDescription)
            }
        }
    }
    
    @objc private func addProject() {
        let newProject = Project()
        let editor = ProjectEditController(
            isNew: true,
            project: newProject,
            updateTable: listView.table.reloadData,
            nm: nm,
            projectStore: projectStore,
            settings: settings)
        editor.modalPresentationStyle = .pageSheet
        present(editor, animated: true)
    }
    
    override func loadView() {
        super.loadView()
        self.view = listView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Strings.projets
        
        listView.controls.reloadAction = reloadTable
        listView.controls.addAction = addProject
        
        listView.table.dataSource = self
        listView.table.delegate = self
        listView.table.register(ProjectListCell.self, forCellReuseIdentifier: Strings.projectCellId)
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
            projectListCell.updateTable = listView.table.reloadData
            projectListCell.present = { view in
                self.present(view, animated: true)
            }
            projectListCell.setup(forProjectAtIndex: indexPath.row)
            projectListCell.openIssues = {
                let issueListController = IssueListController(
                    nm: self.nm,
                    projectStore: self.projectStore,
                    employeeStore: self.employeeStore,
                    settings: self.settings,
                    openedFromProject: true,
                    openedFrom: self.projectStore.items[indexPath.row])
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
            self.listView.table.reloadData()
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
