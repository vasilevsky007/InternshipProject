//
//  ProjectListCell.swift
//  trainingtask
//
//  Created by Alex on 16.01.24.
//

import UIKit

class ProjectListCell: UITableViewCell {
    
    var nm: NetworkManager!
    var projectStore: ProjectStore!
    var employeeStore: EmployeeStore!
    var settings: Settings!
    var updateTable: () -> Void = {}
    var present: (UIViewController) -> Void = {_ in}
    
    private var currentIndex: Int = -1
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBAction func showTapped(_ sender: UIButton) {
        //TODO: open issueList
    }
    
    @IBAction func editTapped(_ sender: UIButton) {
        let project = projectStore.items[currentIndex]
        let editor = ProjectEditController()
        editor.nm = nm
        editor.projectStore = projectStore
        editor.settings = settings
        editor.isNew = false
        editor.project = project
        editor.updateTable = updateTable
        editor.modalPresentationStyle = .pageSheet
        present(editor) //Cannot find 'present' in scope
    }
    
    func setup(forProjectAtIndex index: Int) {
        currentIndex = index
        let project = projectStore.items[index]
        nameLabel.text = project.name
        descriptionLabel.text = project.descriprion
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
