//
//  EmployeeEditController.swift
//  trainingtask
//
//  Created by Alex on 17.01.24.
//

import UIKit

class EmployeeEditController: UIViewController {
    
    private let employeeEditView = EmployeeEditView()
    
    private var isNew: Bool = true
    private var employee: Employee
    private var updateTable: () -> Void
    
    private var nm: NetworkManager
    private var employeeStore: EmployeeStore
    private var settings: Settings
    
    init(isNew: Bool, employee: Employee, updateTable: @escaping () -> Void, nm: NetworkManager, employeeStore: EmployeeStore, settings: Settings) {
        self.isNew = isNew
        self.employee = employee
        self.updateTable = updateTable
        self.nm = nm
        self.employeeStore = employeeStore
        self.settings = settings
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func saveEmployee() {
        employee.name = employeeEditView.nameField.enteredText ?? ""
        employee.surname = employeeEditView.surnameField.enteredText ?? ""
        employee.middleName = employeeEditView.middleNameField.enteredText ?? ""
        employee.position = employeeEditView.positionField.enteredText ?? ""
        let progress = MyProgressViewController()
        progress.startLoad(with: Strings.saveMessage)
        if isNew {
            Task.detached {
                do {
                    try await self.employeeStore.add(employee: self.employee, settings: self.settings)
                    try await self.nm.addEmployeeRequest(employee: self.employee)
                    await progress.stopLoad(successfully: true, with: Strings.saveDoneMessage)
                    DispatchQueue.main.async {
                        self.updateTable()
                        self.dismiss(animated: true)
                    }
                } catch {
                    await progress.stopLoad(successfully: false, with: Strings.error + error.localizedDescription)
                }
            }
        } else {
            Task.detached {
                do {
                    try await self.nm.changeEmployeeRequest(newValue: self.employee)
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
    }
    
    private func close() {
        self.dismiss(animated: true)
        self.updateTable()
    }
    
    override func loadView() {
        super.loadView()
        self.view = employeeEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        employeeEditView.nameField.enteredText = employee.name
        employeeEditView.surnameField.enteredText = employee.surname
        employeeEditView.middleNameField.enteredText = employee.middleName
        employeeEditView.positionField.enteredText = employee.position
        employeeEditView.dialogBox.cancelAction = close
        employeeEditView.dialogBox.saveAction = saveEmployee
    }
}
