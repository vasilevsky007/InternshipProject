//
//  EmployeeListController.swift
//  trainingtask
//
//  Created by Alex on 17.01.24.
//

import UIKit

/// контроллер списка работников
class EmployeeListController: UIViewController {
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
        self.navigationItem.title = Strings.employees
        
        listView.controls.reloadAction = reloadTable
        listView.controls.addAction = addEmployee
        
        listView.table.dataSource = self
        listView.table.delegate = self
        listView.table.register(EmployeeListCell.self, forCellReuseIdentifier: Strings.employeeCellId)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    private func reloadTable() {
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
}

// MARK: - UITableView Delegation
extension EmployeeListController: UITableViewDataSource, UITableViewDelegate {
    /// количество элементов в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        employeeStore.items.count
    }
    
    /// ячейка в таблице по индеку
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.employeeCellId, for: indexPath)
        if let employeeListCell = cell as? EmployeeListCell {
            employeeListCell.setup(forEmployeeAtIndex: indexPath.row, nm: nm, projectStore: projectStore, employeeStore: employeeStore, settings: settings, updateTable: listView.table.reloadData) { vc in
                self.present(vc, animated: true)
            }
        }
        return cell
    }
    
    /// свайпменю ячейки в таблице по индексу
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completionHandler) in
            let employee = self.employeeStore.items[indexPath.row]
            self.employeeStore.delete(employee: employee, projects: self.projectStore)
            let progress = MyProgressViewController()
            progress.startLoad(with: Strings.deleteMessage)
            self.listView.table.reloadData()
            DispatchQueue.main.async {
                self.nm.deleteEmployeeRequest(employee) { error in
                    if let error = error {
                        progress.stopLoad(successfully: false, with: Strings.error + error.localizedDescription)
                    }
                    else {
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
