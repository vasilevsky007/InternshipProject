//
//  ProjectListController.swift
//  trainingtask
//
//  Created by Alex on 16.01.24.
//

import UIKit

/// контроллер списка проектов
class ProjectListController: UIViewController {
    // MARK: - Root View
    private var listView = ListView()
    
    // MARK: - Properties
    private var nm: NetworkManager
    private var projectStore: ProjectStore
    private var employeeStore: EmployeeStore
    private var settings: Settings
    
    // MARK: - Initializers
    /// стандартный инициализатор
    init(nm: NetworkManager, projectStore: ProjectStore, employeeStore: EmployeeStore, settings: Settings) {
        self.nm = nm
        self.projectStore = projectStore
        self.employeeStore = employeeStore
        self.settings = settings
        super.init(nibName: nil, bundle: nil)
    }
    /// не использовать
    /// - Warning: не использовать!!!!
    @available(*, deprecated, message: "Use init(nm: NetworkManager, projectStore: ProjectStore, employeeStore: EmployeeStore, settings: Settings) instead.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
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
    
    // MARK: - Methods
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
}

// MARK: - UITableView Delegation
extension ProjectListController: UITableViewDataSource, UITableViewDelegate {
    /// количество элементов в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        projectStore.items.count
    }
    
    /// ячейка в таблице по индеку
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.projectCellId, for: indexPath)
        if let projectListCell = cell as? ProjectListCell {
            projectListCell.setup(
                forProjectAtIndex: indexPath.row,
                nm: nm,
                projectStore: projectStore,
                employeeStore: employeeStore,
                settings: settings,
                updateTable: listView.table.reloadData
            ) { vc in
                self.present(vc, animated: true)
            } openIssues: {
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
    
    /// свайпменю ячейки в таблице по индексу
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
