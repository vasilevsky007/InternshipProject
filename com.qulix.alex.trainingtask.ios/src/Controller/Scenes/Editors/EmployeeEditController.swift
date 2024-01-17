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
        if isNew {
            try? employeeStore.add(employee: employee, settings: settings)//TODO: error handling
            Task.detached {
                try? await self.nm.addEmployeeRequest(employee: self.employee)
            }
        } else {
            Task.detached {
                try? await self.nm.changeEmployeeRequest(newValue: self.employee)
            }
        }
        self.dismiss(animated: true)
        self.updateTable()
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
