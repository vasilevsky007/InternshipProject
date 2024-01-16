//
//  ProjectEditController.swift
//  trainingtask
//
//  Created by Alex on 16.01.24.
//

import UIKit

class ProjectEditController: UIViewController {
    
    var isNew: Bool = true
    var project: Project!
    var updateTable: () -> Void = {}
    
    var nm: NetworkManager!
    var projectStore: ProjectStore!
    var settings: Settings!
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBAction func saveTapped(_ sender: Any) {
        project.name = nameField.text ?? ""
        project.descriprion = descriptionField.text ?? ""
        if isNew {
            try? projectStore.add(project: project, settings: settings)//TODO: error handling
            Task.detached {
                try? await self.nm.addProjectRequest(project: self.project)
            }
        } else {
            Task.detached {
                try? await self.nm.changeProjectRequest(newValue: self.project)
            }
        }
        self.dismiss(animated: true)
        self.updateTable()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
        self.updateTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.text = project.name
        descriptionField.text = project.descriprion
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
