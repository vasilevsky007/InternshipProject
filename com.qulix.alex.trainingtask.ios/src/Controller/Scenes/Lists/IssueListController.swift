//
//  IssueListController.swift
//  trainingtask
//
//  Created by Alex on 18.01.24.
//

import UIKit

class IssueListController: UIViewController {
    
    private var listView = ListView()

    private var nm: NetworkManager
    private var projectStore: ProjectStore
    private var employeeStore: EmployeeStore
    private var settings: Settings
    private var openedFromProject: Bool
    private var project: Project?
    
    init(nm: NetworkManager, projectStore: ProjectStore, employeeStore: EmployeeStore, settings: Settings, openedFromProject: Bool, openedFrom project: Project? = nil) {
        self.nm = nm
        self.projectStore = projectStore
        self.employeeStore = employeeStore
        self.settings = settings
        self.openedFromProject = openedFromProject
        self.project = project
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = listView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listView.controls.reloadAction = reloadTable
        listView.controls.addAction = addIssue
        self.navigationItem.title = Strings.issues
        self.view = view
        listView.table.dataSource = self
        listView.table.delegate = self
        listView.table.register(IssueListCell.self, forCellReuseIdentifier: Strings.issueCellId)
        // Do any additional setup after loading the view.
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
    
    @objc private func addIssue() {
        do {
            guard let project = project else { throw vcErrors.nilProjectWhenOpenedFromProject }
            let editor = IssueEditController(
                isNew: true,
                openedFromProject: openedFromProject,
                project: project,
                issue: openedFromProject ? try Issue(settings: settings, project: project) : Issue(settings: settings),
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

extension IssueListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if openedFromProject {
            return project?.issues.count ?? 0
        } else {
            return projectStore.allIssues.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.issueCellId, for: indexPath)
        if let issueListCell = cell as? IssueListCell {
            issueListCell.nm = nm
            issueListCell.projectStore = projectStore
            issueListCell.employeeStore = employeeStore
            issueListCell.settings = settings
            issueListCell.updateTable = listView.table.reloadData
            issueListCell.present = { view in
                self.present(view, animated: true)
            }
            if openedFromProject {
                issueListCell.project = project
            }
            issueListCell.setup(forIssueAtIndex: indexPath.row, openedFromProject: openedFromProject)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completionHandler) in
            let issue = self.projectStore.allIssues[indexPath.row]
            issue.project?.removeIssue(issue)
            let progress = MyProgressViewController()
            progress.startLoad(with: Strings.deleteMessage)
            self.listView.table.reloadData()
            Task.detached {
                do {
                    try await self.nm.removeIssueRequest(issue)
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
