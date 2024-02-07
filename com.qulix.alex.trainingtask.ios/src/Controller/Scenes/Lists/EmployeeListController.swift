//
//  EmployeeListController.swift
//  trainingtask
//
//  Created by Alex on 17.01.24.
//

import UIKit

class EmployeeListController: UIViewController {
    
    var nm: NetworkManager!
    var projectStore: ProjectStore!
    var employeeStore: EmployeeStore!
    var settings: Settings!
    
    private var table: UITableView!
    
    private func reloadTable() {
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
    
    private func addEmployee() {
        let newEmployee = Employee()
        let editor = EmployeeEditController()
        editor.nm = nm
        editor.employeeStore = employeeStore
        editor.settings = settings
        editor.isNew = true
        editor.employee = newEmployee
        editor.updateTable = table.reloadData
        editor.modalPresentationStyle = .pageSheet
        present(editor, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = ListView()
        self.table = view.table
        view.controls.reloadAction = reloadTable
        view.controls.addAction = addEmployee
        self.navigationItem.title = Strings.employees
        self.view = view
        table.dataSource = self
        table.delegate = self
        table.register(EmployeeListCell.self, forCellReuseIdentifier: Strings.employeeCellId)
        // Do any additional setup after loading the view.
    }
}

extension EmployeeListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        employeeStore.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.employeeCellId, for: indexPath)
        if let employeeListCell = cell as? EmployeeListCell {
            employeeListCell.nm = nm
            employeeListCell.projectStore = projectStore
            employeeListCell.employeeStore = employeeStore
            employeeListCell.settings = settings
            employeeListCell.updateTable = table.reloadData
            employeeListCell.present = { view in
                self.present(view, animated: true)
            }
            employeeListCell.setup(forEmployeeAtIndex: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completionHandler) in
            let employee = self.employeeStore.items[indexPath.row]
            self.employeeStore.delete(employee: employee, projects: self.projectStore)
            let progress = MyProgressViewController()
            progress.startLoad(with: Strings.deleteMessage)
            self.table.reloadData()
            Task.detached {
                do {
                    try await self.nm.deleteEmployeeRequest(employee)
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
