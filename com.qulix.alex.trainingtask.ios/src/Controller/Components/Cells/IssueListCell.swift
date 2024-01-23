//
//  IssueListCell.swift
//  trainingtask
//
//  Created by Alex on 18.01.24.
//

import UIKit

class IssueListCell: UITableViewCell {
    
    var nm: NetworkManager!
    var projectStore: ProjectStore!
    var employeeStore: EmployeeStore!
    var settings: Settings!
    var project: Project!
    var updateTable: () -> Void = {}
    var present: (UIViewController) -> Void = {_ in}
    
    private var currentIndex: Int = -1
    private var openedFromProject: Bool!
  
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var projectLabel: UILabel!
    
    @IBAction func editTapped(_ sender: Any) {
        let editor = IssueEditController()
        var issue = projectStore.allIssues[currentIndex]
        if openedFromProject {
            issue = project.issues[currentIndex]
            editor.project = project
        }
        editor.nm = nm
        editor.employeeStore = employeeStore
        editor.projectStore = projectStore
        editor.settings = settings
        editor.isNew = false
        editor.issue = issue
        editor.updateTable = updateTable
        editor.openedFromProject = openedFromProject
        editor.modalPresentationStyle = .pageSheet
        present(editor)
    }
    
    func setup(forIssueAtIndex index: Int, openedFromProject: Bool) {
        currentIndex = index
        self.openedFromProject = openedFromProject
        var issue = projectStore.allIssues[index]
        if openedFromProject {
            issue = project.issues[index]
        }
        switch issue.status {
        case .notStarted:
            statusImage.image = UIImage(systemName: "circle")
            statusImage.tintColor = .red
        case .inProgress:
            statusImage.image = UIImage(systemName: "scope")
            statusImage.tintColor = .yellow
        case .completed:
            statusImage.image = UIImage(systemName: "checkmark.circle")
            statusImage.tintColor = .green
        case .postponed:
            statusImage.image = UIImage(systemName: "arrow.uturn.down.circle")
            statusImage.tintColor = .gray
        }
        nameLabel.text = issue.name
        if openedFromProject {
            projectLabel.isHidden = true
        } else {
            projectLabel.text = issue.project?.name
        }
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
