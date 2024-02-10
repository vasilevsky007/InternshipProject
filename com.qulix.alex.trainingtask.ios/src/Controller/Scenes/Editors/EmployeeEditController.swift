//
//  EmployeeEditController.swift
//  trainingtask
//
//  Created by Alex on 17.01.24.
//

import UIKit

/// контроллер редакотра работников
class EmployeeEditController: UIViewController {
    // MARK: - Root View
    private let employeeEditView = EmployeeEditView()
    
    // MARK: - Properties
    private var isNew: Bool = true
    private var employee: Employee
    private var updateTable: () -> Void
    
    private var nm: NetworkManager
    private var employeeStore: EmployeeStore
    private var settings: Settings
    
    // MARK: - Initializers
    /// стандартный инициализатор
    init(isNew: Bool, employee: Employee, updateTable: @escaping () -> Void, nm: NetworkManager, employeeStore: EmployeeStore, settings: Settings) {
        self.isNew = isNew
        self.employee = employee
        self.updateTable = updateTable
        self.nm = nm
        self.employeeStore = employeeStore
        self.settings = settings
        super.init(nibName: nil, bundle: nil)
    }
    
    /// не использовать
    /// - Warning: не использовать!!!!
    @available(*, deprecated, message: "Use init(isNew: Bool, employee: Employee, updateTable: @escaping () -> Void, nm: NetworkManager, employeeStore: EmployeeStore, settings: Settings) instead.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
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
    
    // MARK: - Methods
    private func saveEmployee() {
        employee.name = employeeEditView.nameField.enteredText ?? ""
        employee.surname = employeeEditView.surnameField.enteredText ?? ""
        employee.middleName = employeeEditView.middleNameField.enteredText ?? ""
        employee.position = employeeEditView.positionField.enteredText ?? ""
        let progress = MyProgressViewController()
        progress.startLoad(with: Strings.saveMessage)
        
        let callback: (_ error: Error?) -> Void = { error in
            if let error =  error {
                progress.stopLoad(successfully: false, with: Strings.error + error.localizedDescription)
            } else {
                progress.stopLoad(successfully: true, with: Strings.saveDoneMessage)
                self.updateTable()
                self.dismiss(animated: true)
            }
        }
        
        DispatchQueue.main.async {
            do {
                if self.isNew {
                    try self.employeeStore.add(employee: self.employee, settings: self.settings)
                    self.nm.addEmployeeRequest(employee: self.employee, completion: callback)
                } else {
                    self.nm.changeEmployeeRequest(newValue: self.employee, completion: callback)
                }
            } catch {
                progress.stopLoad(successfully: false, with: Strings.error + error.localizedDescription)
            }
        }
        
    }
    
    private func close() {
        self.dismiss(animated: true)
        self.updateTable()
    }
}
