//
//  IssueListController.swift
//  trainingtask
//
//  Created by Alex on 18.01.24.
//

import UIKit

/// контроллер списка задач
class IssueListController: UIViewController {
    // MARK: - Root View
    private var listView = ListView()

    // MARK: - Properties
    private var nm: NetworkManager
    private var projectStore: ProjectStore
    private var employeeStore: EmployeeStore
    private var settings: Settings
    private var openedFromProject: Bool
    private var project: Project?
    
    // MARK: - Initializers
    /// стандартный инициализатор
    init(nm: NetworkManager, projectStore: ProjectStore, employeeStore: EmployeeStore, settings: Settings, openedFromProject: Bool, openedFrom project: Project? = nil) {
        self.nm = nm
        self.projectStore = projectStore
        self.employeeStore = employeeStore
        self.settings = settings
        self.openedFromProject = openedFromProject
        self.project = project
        super.init(nibName: nil, bundle: nil)
    }
    
    /// не использовать
    /// - Warning: не использовать!!!!
    @available(*, deprecated, message: "Use init(nm: NetworkManager, projectStore: ProjectStore, employeeStore: EmployeeStore, settings: Settings, openedFromProject: Bool, openedFrom project: Project? = nil) instead.")
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
        listView.controls.reloadAction = reloadTable
        listView.controls.addAction = addIssue
        if let project = project {
            self.navigationItem.title = Strings.issues + " (\(project.name))"
        } else {
            self.navigationItem.title = Strings.issues
        }
        self.view = view
        listView.table.dataSource = self
        listView.table.delegate = self
        listView.table.register(IssueListCell.self, forCellReuseIdentifier: Strings.issueCellId)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    @objc private func reloadTable() {
        let progress = MyProgressViewController()
        progress.startLoad(with: Strings.updateMessage)
        DispatchQueue.main.async {
            self.nm.fetchAll() { result, error in
                if let error = error {
                    progress.stopLoad(successfully: false, with: Strings.error + error.localizedDescription)
                } else {
                    do {
                        if let (projects, employees) = result {
                            self.projectStore.deleteAll()
                            self.employeeStore.deleteAll()
                            for project in projects {
                                try self.projectStore.add(project: project, settings: self.settings)
                            }
                            for employee in employees {
                                try self.employeeStore.add(employee: employee, settings: self.settings)
                            }
                            self.listView.table.reloadData()
                            progress.stopLoad(successfully: true, with: Strings.updateDoneMessage)
                        }
                    } catch {
                        progress.stopLoad(successfully: false, with: Strings.error + error.localizedDescription)
                    }
                }
            }
        }
    }
    
    @objc private func addIssue() {
        do {
            if (openedFromProject) {
                guard let _ = project else { throw vcErrors.nilProjectWhenOpenedFromProject }
            }
            let editor = IssueEditController(
                isNew: true,
                openedFromProject: openedFromProject,
                project: project,
                issue: openedFromProject ? try Issue(settings: settings, project: project!) : Issue(settings: settings),
                updateTable: listView.table.reloadData,
                nm: nm,
                projectStore: projectStore,
                employeeStore: employeeStore,
                settings: settings)
            editor.modalPresentationStyle = .pageSheet
            present(editor, animated: true)
        } catch {
            let progress = MyProgressViewController()
            progress.stopLoad(successfully: false, with: Strings.error + error.localizedDescription)
        }
    }
}

// MARK: - UITableView Delegation
extension IssueListController: UITableViewDataSource, UITableViewDelegate {
    /// количество элементов в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if openedFromProject {
            return project?.issues.count ?? 0
        } else {
            return projectStore.allIssues.count
        }
    }
    
    /// ячейка в таблице по индеку
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.issueCellId, for: indexPath)
        if let issueListCell = cell as? IssueListCell {
            issueListCell.setup(
                forIssueAtIndex: indexPath.row,
                openedFromProject: openedFromProject,
                nm: nm,
                projectStore: projectStore,
                employeeStore: employeeStore,
                settings: settings, 
                project: project,
                updateTable: listView.table.reloadData) { vc in
                    self.present(vc, animated: true)
                }
        }
        return cell
    }
    
    /// свайпменю ячейки в таблице по индексу
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completionHandler) in
            let issue = self.projectStore.allIssues[indexPath.row]
            issue.project?.removeIssue(issue)
            let progress = MyProgressViewController()
            progress.startLoad(with: Strings.deleteMessage)
            self.listView.table.reloadData()
            DispatchQueue.main.async {
                self.nm.removeIssueRequest(issue) { error in
                    if let error =  error {
                        progress.stopLoad(successfully: false, with: Strings.error + error.localizedDescription)
                    } else {
                        progress.stopLoad(successfully: true, with: Strings.deleteDoneMessage)
                    }
                }
            }
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: Strings.deleteImage)
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
}
