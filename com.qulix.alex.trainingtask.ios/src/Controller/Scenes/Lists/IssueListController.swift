//
//  IssueListController.swift
//  trainingtask
//
//  Created by Alex on 18.01.24.
//

import UIKit

class IssueListController: UIViewController {

    var nm: NetworkManager!
    var projectStore: ProjectStore!
    var employeeStore: EmployeeStore!
    var settings: Settings!
    var openedFromProject: Bool!
    var project: Project!
    
    private var table: UITableView!
    
    @objc private func reloadTable() {
        let progress = MyProgressViewController()
        progress.startLoad(with: "Updating issues from server")
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
                await progress.stopLoad(successfully: true, with: "Issues updated from server")
            } catch {
                await progress.stopLoad(successfully: false, with: "Error: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func addIssue() {
        do {
            var newIssue = Issue(settings: settings)
            let editor = IssueEditController()
            if (openedFromProject) {
                newIssue = try Issue(settings: settings, project: project)
                editor.project = project
            }
            editor.nm = nm
            editor.employeeStore = employeeStore
            editor.projectStore = projectStore
            editor.settings = settings
            editor.isNew = true
            editor.issue = newIssue
            editor.updateTable = table.reloadData
            editor.openedFromProject = openedFromProject
            editor.modalPresentationStyle = .pageSheet
            present(editor, animated: true)
        } catch {
            let progress = MyProgressViewController()
            progress.stopLoad(successfully: false, with: "Error: \(error.localizedDescription)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = ListView()
        self.table = view.table
        view.controls.reloadAction = reloadTable
        view.controls.addAction = addIssue
        self.navigationItem.title = Strings.issues
        self.view = view
        table.dataSource = self
        table.delegate = self
        table.register(IssueListCell.self, forCellReuseIdentifier: Strings.issueCellId)
        // Do any additional setup after loading the view.
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

extension IssueListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if openedFromProject {
            return project.issues.count
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
            issueListCell.updateTable = table.reloadData
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
            progress.startLoad(with: "Deleting issue from server")
            self.table.reloadData()
            Task.detached {
                do {
                    try await self.nm.removeIssueRequest(issue)
                    await progress.stopLoad(successfully: true, with: "Issues deleted from server")
                } catch {
                    await progress.stopLoad(successfully: false, with: "Error: \(error.localizedDescription)")
                }
            }
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
}
