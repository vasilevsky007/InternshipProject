//
//  IssueEdit.swift
//  trainingtask
//
//  Created by Alex on 18.01.24.
//

import UIKit

/// контроллер редакотра задачи
class IssueEditController: UIViewController {
    // MARK: - Root View
    private let issueEditView = IssueEditView()
    
    // MARK: - Properties
    private var isNew: Bool = true
    private var openedFromProject: Bool
    private var project: Project?
    private var issue: Issue
    private var updateTable: () -> Void
    
    private var nm: NetworkManager
    private var projectStore: ProjectStore
    private var employeeStore: EmployeeStore
    private var settings: Settings
    
    private var statusPickerController = StatusPickerController()
    private var employeePickerController = EmployeePickerController()
    private var projectPickerController = ProjectPickerController()
    
    // MARK: - Initializers
    /// стандартный инициализатор
    init(isNew: Bool, openedFromProject: Bool, project: Project? = nil, issue: Issue, updateTable: @escaping () -> Void, nm: NetworkManager, projectStore: ProjectStore, employeeStore: EmployeeStore, settings: Settings) {
        self.isNew = isNew
        self.openedFromProject = openedFromProject
        self.project = project
        self.issue = issue
        self.updateTable = updateTable
        self.nm = nm
        self.projectStore = projectStore
        self.employeeStore = employeeStore
        self.settings = settings
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func loadView() {
        super.loadView()
        self.view = issueEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        issueEditView.dialogBox.cancelAction = close
        issueEditView.dialogBox.saveAction = saveIssue
        
        issueEditView.statusPicker.setupPicker(delegate: statusPickerController, dataSource: statusPickerController)
        issueEditView.employeePicker.setupPicker(delegate: employeePickerController, dataSource: employeePickerController)
        issueEditView.projectPicker.setupPicker(delegate: projectPickerController, dataSource: projectPickerController)
        
        
        issueEditView.nameField.enteredText = issue.name
        issueEditView.workField.enteredText = (Int(issue.job) / 3600).description
        
        issueEditView.start.enteredDate = issue.start
        issueEditView.end.enteredDate = issue.end
        
        employeePickerController.employees.append(contentsOf: employeeStore.items)
        employeePickerController.selectedEmployee = issue.employee
        if let initialEmployeeRow = employeePickerController.employees.firstIndex(of: issue.employee) {
            issueEditView.employeePicker.selectRow(initialEmployeeRow, animated: false)
        }
        projectPickerController.projects.append(contentsOf: projectStore.items)
        projectPickerController.selectedProject = issue.project
        if let initialProjectRow = projectPickerController.projects.firstIndex(of: issue.project) {
            issueEditView.projectPicker.selectRow(initialProjectRow, animated: false)
        }
        
        statusPickerController.selectedStatus = issue.status
        if let initialStatusRow = statusPickerController.statuses.firstIndex(of: issue.status) {
            issueEditView.statusPicker.selectRow(initialStatusRow, animated: false)
        }
        
        if openedFromProject {
            issueEditView.projectPicker.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Methods
    private func saveIssue() {
        issue.name = issueEditView.nameField.enteredText ?? ""
        issue.job = Double(Int(issueEditView.workField.enteredText ?? "") ?? 0)*3600
        issue.status = statusPickerController.selectedStatus
        issue.employee = employeePickerController.selectedEmployee
        let progress = MyProgressViewController()
        progress.startLoad(with: Strings.saveMessage)
        do {
            if let startDate = issueEditView.start.enteredDate {
                issue.start = startDate
            } else {
                throw InputValidationErrors.invalidDateInTextField
            }
            if let endDate = issueEditView.end.enteredDate {
                issue.end = endDate
            } else {
                throw InputValidationErrors.invalidDateInTextField
            }
            let project = openedFromProject ? self.project : projectPickerController.selectedProject
            guard let projectUnwrapped = project else { throw BusinessLogicErrors.noProjectInIssue }
            try issue.changeProject(to: projectUnwrapped, settings: self.settings)
        } catch {
            progress.stopLoad(successfully: false, with: Strings.error + error.localizedDescription)
            return
        }
        Task.detached {
            do {
                if await self.isNew {
                    //здесь используется force unwrap так как ранее (guard let projectUnwrapped = project else { throw BusinessLogicErrors.noProjectInIssue }) было проверено что это значение не является nil
                    try await self.nm.addIssueRequest(self.issue, to: self.issue.project!)
                } else {
                    try await self.nm.changeIssueRequest(self.issue)
                }
                await progress.stopLoad(successfully: true, with: Strings.saveDoneMessage)
                DispatchQueue.main.async {
                    self.updateTable()
                    self.dismiss(animated: true)
                }
            } catch {
                await progress.stopLoad(successfully: false, with: Strings.error + error.localizedDescription)
            }
        }
    }
    
    private func close() {
        self.dismiss(animated: true)
        self.updateTable()
    }
    
    //MARK: - Сlasses for pickers delegation
    /// класс для уравления UIPickerView для выбора статуса задачи
    class StatusPickerController: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        //MARK: Properties
        /// список всех возможных статусов
        let statuses: [Issue.Status] = Issue.Status.allCases
        /// выбранный в данный момент статус
        var selectedStatus: Issue.Status = .notStarted
        
        //MARK: Delegate methods
        ///количество сегментов
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        ///количество элементов в сегменте
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return statuses.count
        }
        ///названия элементов в сегменте
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return statuses[row].rawValue
        }
        ///дейсвие при выборе определённого  элемента в сегменте
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedStatus = statuses[row]
        }
    }
    
    /// класс для уравления UIPickerView для выбора работника выполняющего задачу
    class EmployeePickerController: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        //MARK: Properties
        /// список всех  работников
        var employees: [Employee?] = [nil]
        /// выбранный в данный момент работник
        var selectedEmployee: Employee? = nil
        
        //MARK: Delegate methods
        ///количество сегментов
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        ///количество элементов в сегменте
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return employees.count
        }
        ///названия элементов в сегменте
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return employees[row]?.fio ?? Strings.notSelected
        }
        ///дейсвие при выборе определённого  элемента в сегменте
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedEmployee = employees[row]
        }
    }
    
    
    /// класс для уравления UIPickerView для выбора проекта к которому относится задача
    class ProjectPickerController: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        //MARK: Properties
        /// список всех  проектов
        var projects: [Project?] = [nil]
        /// выбранный в данный момент проект
        var selectedProject: Project? = nil
        
        //MARK: Delegate methods
        ///количество сегментов
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        ///количество элементов в сегменте
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return projects.count
        }
        ///названия элементов в сегменте
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return projects[row]?.name ?? Strings.notSelected
        }
        ///дейсвие при выборе определённого  элемента в сегменте
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedProject = projects[row]
        }
    }
}
