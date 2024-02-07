//
//  EmployeeEditController.swift
//  trainingtask
//
//  Created by Alex on 17.01.24.
//

import UIKit

class EmployeeEditController: UIViewController {
    
    var isNew: Bool = true
    var employee: Employee!
    var updateTable: () -> Void = {}
    
    var nm: NetworkManager!
    var employeeStore: EmployeeStore!
    var settings: Settings!
    
    private func saveEmployee() {
        let employeeEditView = self.view as! EmployeeEditView
        employee.name = employeeEditView.nameField.enteredText ?? ""
        employee.surname = employeeEditView.surnameField.enteredText ?? ""
        employee.middleName = employeeEditView.middleNameField.enteredText ?? ""
        employee.position = employeeEditView.positionField.enteredText ?? ""
        let progress = MyProgressViewController()
        progress.startLoad(with: "Saving employee to server")
        if isNew {
            Task.detached {
                do {
                    try await self.employeeStore.add(employee: self.employee, settings: self.settings)
                    try await self.nm.addEmployeeRequest(employee: self.employee)
                    await progress.stopLoad(successfully: true, with: "Employee saved to server")
                    DispatchQueue.main.async {
                        self.updateTable()
                        self.dismiss(animated: true)
                    }
                } catch {
                    await progress.stopLoad(successfully: false, with: "Error: \(error.localizedDescription)")
                }
            }
        } else {
            Task.detached {
                do {
                    try await self.nm.changeEmployeeRequest(newValue: self.employee)
                    await progress.stopLoad(successfully: true, with: "Employee saved to server")
                    DispatchQueue.main.async {
                        self.updateTable()
                        self.dismiss(animated: true)
                    }
                } catch {
                    await progress.stopLoad(successfully: false, with: "Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func close() {
        self.dismiss(animated: true)
        self.updateTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = EmployeeEditView()
        self.view = view
        view.nameField.enteredText = employee.name
        view.surnameField.enteredText = employee.surname
        view.middleNameField.enteredText = employee.middleName
        view.positionField.enteredText = employee.position
        view.dialogBox.cancelAction = close
        view.dialogBox.saveAction = saveEmployee
    }
}
