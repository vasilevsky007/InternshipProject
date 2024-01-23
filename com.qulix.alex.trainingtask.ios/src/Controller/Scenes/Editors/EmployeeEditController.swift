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
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var middleNameField: UITextField!
    @IBOutlet weak var positionField: UITextField!
    
    @IBAction func saveTapped(_ sender: UIButton) {
        employee.name = nameField.text ?? ""
        employee.surname = surnameField.text ?? ""
        employee.middleName = middleNameField.text ?? ""
        employee.position = positionField.text ?? ""
        MyProgressViewController.shared.startLoad(with: "Saving employee to server")
        if isNew {
            Task.detached {
                do {
                    try await self.employeeStore.add(employee: self.employee, settings: self.settings)
                    try await self.nm.addEmployeeRequest(employee: self.employee)
                    await MyProgressViewController.shared.stopLoad(successfully: true, with: "Employee saved to server")
                } catch {
                    await MyProgressViewController.shared.stopLoad(successfully: false, with: "Error: \(error.localizedDescription)")
                }
                DispatchQueue.main.async {
                    self.updateTable()
                    self.dismiss(animated: true)
                }
            }
        } else {
            Task.detached {
                do {
                    try await self.nm.changeEmployeeRequest(newValue: self.employee)
                    await MyProgressViewController.shared.stopLoad(successfully: true, with: "Employee saved to server")
                } catch {
                    await MyProgressViewController.shared.stopLoad(successfully: false, with: "Error: \(error.localizedDescription)")
                }
                DispatchQueue.main.async {
                    self.updateTable()
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
        self.updateTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.text = employee.name
        surnameField.text = employee.surname
        middleNameField.text = employee.middleName
        positionField.text = employee.position
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [flexibleSpace, doneButton]
        nameField.inputAccessoryView = toolbar
        surnameField.inputAccessoryView = toolbar
        middleNameField.inputAccessoryView = toolbar
        positionField.inputAccessoryView = toolbar
        // Do any additional setup after loading the view.
    }

    @objc func doneButtonTapped() {
        view.endEditing(true) // Закрывает клавиатуру
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
