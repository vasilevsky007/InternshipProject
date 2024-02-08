//
//  EmployeeListController.swift
//  trainingtask
//
//  Created by Alex on 17.01.24.
//

import UIKit

class EmployeeListController: UIViewController {
    
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
                await self.listView.table.reloadData()
                await progress.stopLoad(successfully: true, with: Strings.updateDoneMessage)
            } catch {
                await progress.stopLoad(successfully: false, with: Strings.error + error.localizedDescription)
            }
        }
    }
    
    private func addEmployee() {
        let newEmployee = Employee()
        let editor = EmployeeEditController(
            isNew: true,
            employee: newEmployee,
            updateTable: listView.table.reloadData,
            nm: nm,
            employeeStore: employeeStore,
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
        self.navigationItem.title = Strings.employees
        
        listView.controls.reloadAction = reloadTable
        listView.controls.addAction = addEmployee
        
        listView.table.dataSource = self
        listView.table.delegate = self
        listView.table.register(EmployeeListCell.self, forCellReuseIdentifier: Strings.employeeCellId)
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
            employeeListCell.updateTable = listView.table.reloadData
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
            self.listView.table.reloadData()
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
