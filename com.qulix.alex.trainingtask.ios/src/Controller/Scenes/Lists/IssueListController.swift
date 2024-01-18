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
    
    @IBOutlet weak var table: UITableView!
    
    @IBAction func reloadTapped(_ sender: UIButton) {
        Task.detached {
            let (projects, employees) = try await self.nm.fetchAll()
            await self.projectStore.deleteAll()
            await self.employeeStore.deleteAll()
            for project in projects {
                try? await self.projectStore.add(project: project, settings: self.settings)
            }
            for employee in employees {
                try? await self.employeeStore.add(employee: employee, settings: self.settings)
            }
            await self.table.reloadData()
        }
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        projectStore.allIssues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssueListCell", for: indexPath)
        if let projectListCell = cell as? IssueListCell {
            projectListCell.nm = nm
            projectListCell.projectStore = projectStore
            projectListCell.employeeStore = employeeStore
            projectListCell.settings = settings
            projectListCell.updateTable = table.reloadData
            projectListCell.present = { view in
                self.present(view, animated: true)
            }
            projectListCell.setup(forIssueAtIndex: indexPath.row, openedFromProject: openedFromProject)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completionHandler) in
            let issue = self.projectStore.allIssues[indexPath.row]
            issue.project?.removeIssue(issue)
            self.table.reloadData()
            Task.detached {
                try? await self.nm.removeIssueRequest(issue)//TODO: Error handling
            }
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
}
