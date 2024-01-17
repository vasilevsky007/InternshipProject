//
//  EmployeeListController.swift
//  trainingtask
//
//  Created by Alex on 17.01.24.
//

import UIKit

class EmployeeListController: UIViewController {
    
    var nm: NetworkManager!
    var projectStore: ProjectStore!
    var employeeStore: EmployeeStore!
    var settings: Settings!
    
    @IBOutlet weak var table: UITableView!
    
    @IBAction func reloadTapped(_ sender: UIButton) {
        Task.detached {
            let (projects, employees) = try await self.nm.fetchAll()
            await self.projectStore.deleteAll()
            await self.employeeStore.deleteAll()
            for project in projects {
                try? await self.projectStore.add(project: project, settings: self.settings)
            }
            for employee in employees {
                try? await self.employeeStore.add(employee: employee, settings: self.settings)
            }
            await self.table.reloadData()
        }
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        let newEmployee = Employee()
        let editor = EmployeeEditController()
        editor.nm = nm
        editor.employeeStore = employeeStore
        editor.settings = settings
        editor.isNew = true
        editor.employee = newEmployee
        editor.updateTable = table.reloadData
        editor.modalPresentationStyle = .pageSheet
        present(editor, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        table.register(UINib(nibName: "EmployeeListCell", bundle: nil), forCellReuseIdentifier: "EmployeeListCell")
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

extension EmployeeListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        employeeStore.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeListCell", for: indexPath)
        if let projectListCell = cell as? EmployeeListCell {
            projectListCell.nm = nm
            projectListCell.projectStore = projectStore
            projectListCell.employeeStore = employeeStore
            projectListCell.settings = settings
            projectListCell.updateTable = table.reloadData
            projectListCell.present = { view in
                self.present(view, animated: true)
            }
            projectListCell.setup(forEmployeeAtIndex: indexPath.row)
        }
        return cell
    }
}
