//
//  IssueEdit.swift
//  trainingtask
//
//  Created by Alex on 18.01.24.
//

import UIKit

class IssueEditController: UIViewController {
    
    var isNew: Bool = true
    var openedFromProject: Bool!
    var project: Project!
    var issue: Issue!
    var updateTable: () -> Void = {}
    
    var nm: NetworkManager!
    var projectStore: ProjectStore!
    var employeeStore: EmployeeStore!
    var settings: Settings!
    
    private var statusPickerController = StatusPickerController()
    private var employeePickerController = EmployeePickerController()
    private var projectPickerController = ProjectPickerController()
    
    private func saveIssue() {
        let issueEditView = self.view as! IssueEditView
        issue.name = issueEditView.nameField.enteredText ?? ""
        issue.job = Double(Int(issueEditView.workField.enteredText!) ?? 0)*3600
        issue.status = statusPickerController.selectedStatus
        issue.employee = employeePickerController.selectedEmployee
        let progress = MyProgressViewController()
        progress.startLoad(with: "Saving issue to server")
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
            progress.stopLoad(successfully: false, with: "Error: \(error.localizedDescription)")
            return
        }
        Task.detached {
            do {
                if await self.isNew {
                    try await self.nm.addIssueRequest(self.issue, to: self.issue.project!)
                } else {
                    try await self.nm.changeIssueRequest(self.issue)
                }
                await progress.stopLoad(successfully: true, with: "Issue saved to server")
                DispatchQueue.main.async {
                    self.updateTable()
                    self.dismiss(animated: true)
                }
            } catch {
                await progress.stopLoad(successfully: false, with: "Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func close() {
        self.dismiss(animated: true)
        self.updateTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = IssueEditView()
        self.view = view
        
        view.dialogBox.cancelAction = close
        view.dialogBox.saveAction = saveIssue
        
        view.statusPicker.setupPicker(delegate: statusPickerController, dataSource: statusPickerController)
        view.employeePicker.setupPicker(delegate: employeePickerController, dataSource: employeePickerController)
        view.projectPicker.setupPicker(delegate: projectPickerController, dataSource: projectPickerController)
        
        
        view.nameField.enteredText = issue.name
        view.workField.enteredText = (Int(issue.job) / 3600).description
        
        view.start.enteredDate = issue.start
        view.end.enteredDate = issue.end
    
        employeePickerController.employees.append(contentsOf: employeeStore.items)
        employeePickerController.selectedEmployee = issue.employee
        if let initialEmployeeRow = employeePickerController.employees.firstIndex(of: issue.employee) {
            view.employeePicker.selectRow(initialEmployeeRow, animated: false)
        }
        projectPickerController.projects.append(contentsOf: projectStore.items)
        projectPickerController.selectedProject = issue.project
        if let initialProjectRow = projectPickerController.projects.firstIndex(of: issue.project) {
            view.projectPicker.selectRow(initialProjectRow, animated: false)
        }
        
        statusPickerController.selectedStatus = issue.status
        if let initialStatusRow = statusPickerController.statuses.firstIndex(of: issue.status) {
            view.statusPicker.selectRow(initialStatusRow, animated: false)
        }
        
        if openedFromProject {
            view.projectPicker.isUserInteractionEnabled = false
        }
    }
    
    //MARK: classes for pickers delegation
    class StatusPickerController: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        let statuses: [Issue.Status] = [.notStarted, .inProgress, .completed, .postponed]
        var selectedStatus: Issue.Status = .notStarted
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return statuses.count
        }
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return statuses[row].rawValue
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedStatus = statuses[row]
            // Здесь можно выполнить какие-то действия при выборе определенного статуса
        }
    }
    
    class EmployeePickerController: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        var employees: [Employee?] = [nil]
        var selectedEmployee: Employee? = nil
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return employees.count
        }
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return employees[row]?.fio ?? "Не выбран"
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedEmployee = employees[row]
        }
    }
    
    class ProjectPickerController: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        var projects: [Project?] = [nil]
        var selectedProject: Project? = nil
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return projects.count
        }
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return projects[row]?.name ?? "Не выбран"
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedProject = projects[row]
        }
    }
}
