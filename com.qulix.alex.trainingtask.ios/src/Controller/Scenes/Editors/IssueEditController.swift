//
//  IssueEdit.swift
//  trainingtask
//
//  Created by Alex on 18.01.24.
//

import UIKit

class IssueEditController: UIViewController, UITextFieldDelegate {
    
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
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var workField: UITextField!
    @IBOutlet weak var startField: UITextField!
    @IBOutlet weak var endField: UITextField!
    
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    
    @IBOutlet weak var statusPicker: UIPickerView!
    @IBOutlet weak var employeePicker: UIPickerView!
    @IBOutlet weak var projectPicker: UIPickerView!
    
    @IBAction func saveTapped(_ sender: UIButton) {
        sender.isEnabled = false
        issue.name = nameField.text ?? ""
        issue.job = Double(Int(workField.text!) ?? 0)*3600
        issue.start = dateFormatter.date(from: startField.text ?? "") ?? startDate.date
        issue.end = dateFormatter.date(from: startField.text ?? "") ?? endDate.date
        issue.status = statusPickerController.selectedStatus
        issue.project = openedFromProject ? project : projectPickerController.selectedProject
        issue.employee = employeePickerController.selectedEmployee
        MyProgressViewController.shared.startLoad(with: "Saving issue to server")
        if isNew {
            Task.detached {
                do {
                    try await self.issue.project?.addIssue(self.issue, settings: self.settings)
                    try await self.nm.addIssueRequest(self.issue, to: self.issue.project!)
                    await MyProgressViewController.shared.stopLoad(successfully: true, with: "Issue saved to server")
                } catch {
                    await MyProgressViewController.shared.stopLoad(successfully: false, with: "Error: \(error.localizedDescription)")
                }
                DispatchQueue.main.async {
                    self.updateTable()
                    self.dismiss(animated: true)
                }
            }
        } else {
            if let index = issue.project?.issues.firstIndex(of: issue) {
                issue.project?.issues[index] = issue
            }
            Task.detached {
                do {
                    try await self.nm.changeIssueRequest(self.issue)
                    await MyProgressViewController.shared.stopLoad(successfully: true, with: "Issue saved to server")
                } catch {
                    await MyProgressViewController.shared.stopLoad(successfully: false, with: "Error: \(error.localizedDescription)")
                }
                DispatchQueue.main.async {
                    self.updateTable()
                    self.dismiss(animated: true)
                }
            }
        }
        self.updateTable()
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
        self.updateTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [flexibleSpace, doneButton]
        startField.inputAccessoryView = toolbar
        endField.inputAccessoryView = toolbar
        nameField.inputAccessoryView = toolbar
        workField.inputAccessoryView = toolbar
        
        statusPicker.delegate = statusPickerController
        statusPicker.dataSource = statusPickerController
        employeePicker.delegate = employeePickerController
        employeePicker.dataSource = employeePickerController
        projectPicker.delegate = projectPickerController
        projectPicker.dataSource = projectPickerController
        
        nameField.text = issue.name
        workField.text = (Int(issue.job) / 3600).description
        
        startField.delegate = self
        startField.text = dateFormatter.string(from: issue.start)
        startField.addTarget(self, action: #selector(startFieldChanged(_:)), for: .editingDidEnd)
        
        endField.delegate = self
        endField.text = dateFormatter.string(from: issue.end)
        endField.addTarget(self, action: #selector(endFieldChanged(_:)), for: .editingDidEnd)
        
        startDate.date = issue.start
        startDate.addTarget(self, action: #selector(startDateChanged(_:)), for: .valueChanged)
        endDate.date = issue.end
        endDate.addTarget(self, action: #selector(endDateChanged(_:)), for: .valueChanged)
        
        employeePickerController.employees.append(contentsOf: employeeStore.items)
        employeePickerController.selectedEmployee = issue.employee
        if let initialEmployeeRow = employeePickerController.employees.firstIndex(of: issue.employee) {
            employeePicker.selectRow(initialEmployeeRow, inComponent: 0, animated: false)
        }
        projectPickerController.projects.append(contentsOf: projectStore.items)
        projectPickerController.selectedProject = issue.project
        if let initialProjectRow = projectPickerController.projects.firstIndex(of: issue.project) {
            projectPicker.selectRow(initialProjectRow, inComponent: 0, animated: false)
        }
        
        statusPickerController.selectedStatus = issue.status
        if let initialStatusRow = statusPickerController.statuses.firstIndex(of: issue.status) {
            statusPicker.selectRow(initialStatusRow, inComponent: 0, animated: false)
        }
        
        if openedFromProject {
            projectPicker.isUserInteractionEnabled = false
        }
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true) // Закрывает клавиатуру
    }
    
    @objc func startDateChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        startField.text = dateFormatter.string(from: selectedDate)
    }
    @objc func startFieldChanged(_ sender: UITextField) {
        if let enteredDate = dateFormatter.date(from: sender.text!) {
            startDate.date = enteredDate
        }
    }
    @objc func endDateChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        endField.text = dateFormatter.string(from: selectedDate)
    }
    @objc func endFieldChanged(_ sender: UITextField) {
        if let enteredDate = dateFormatter.date(from: sender.text!) {
            endDate.date = enteredDate
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Обрабатываем добавление цифр и форматируем текст
        if let currentText = textField.text,
           let range = Range(range, in: currentText) {
            
            let updatedText = currentText.replacingCharacters(in: range, with: string)
            if let formattedText = formatDateString(updatedText) {
                textField.text = formattedText
            }
            
            return false // Мы управляем обновлением текста
        }
        
        return true
    }
    
    private func formatDateString(_ dateString: String) -> String? {
        let cleanedString = dateString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        switch cleanedString.count {
        case 0...4:
            return cleanedString
        case 5...6:
            return "\(cleanedString.prefix(4))-\(cleanedString[cleanedString.index(cleanedString.startIndex, offsetBy: 4)..<cleanedString.endIndex])"
        case 7...Int.max:
            return "\(cleanedString.prefix(4))-\(cleanedString[cleanedString.index(cleanedString.startIndex, offsetBy: 4)..<cleanedString.index(cleanedString.startIndex, offsetBy: 6)])-\(cleanedString[cleanedString.index(cleanedString.startIndex, offsetBy: 6)..<cleanedString.endIndex])"
        default:
            return cleanedString
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
