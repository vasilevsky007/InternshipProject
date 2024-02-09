//
//  IssueListCell.swift
//  trainingtask
//
//  Created by Alex on 18.01.24.
//

import UIKit

/// клетка  таблицы,  для отображения задачи.
/// использует констрейнты.
///  - Important: используйте ``setup(forIssueAtIndex:openedFromProject:nm:projectStore:employeeStore:settings:updateTable:present:)``
///  сразу посне получения с помощью `.dequeueReusableCell(withIdentifier: Strings.projectCellId, for: indexPath)`
class IssueListCell: UITableViewCell {
    // MARK: - Properties
    private var nm: NetworkManager!
    private var projectStore: ProjectStore!
    private var employeeStore: EmployeeStore!
    private var settings: Settings!
    private var project: Project!
    private var updateTable: () -> Void = {}
    private var present: (UIViewController) -> Void = {_ in}
    
    private var currentIndex: Int = -1
    private var openedFromProject: Bool!
  
    private let statusImage = UIImageView()
    private let nameLabel = UILabel()
    private let projectLabel = UILabel()
    private let editButton = UIButton()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - Methods
    func setup(
        forIssueAtIndex index: Int,
        openedFromProject: Bool,
        nm: NetworkManager,
        projectStore: ProjectStore,
        employeeStore: EmployeeStore,
        settings: Settings,
        project: Project?,
        updateTable: @escaping () -> Void,
        present: @escaping (UIViewController) -> Void
    ) {
        self.nm = nm
        self.projectStore = projectStore
        self.employeeStore = employeeStore
        self.settings = settings
        self.updateTable = updateTable
        self.present = present
        self.project = project
        currentIndex = index
        self.openedFromProject = openedFromProject
        var issue = projectStore.allIssues[index]
        if openedFromProject {
            issue = self.project.issues[index]
        }
        switch issue.status {
        case .notStarted:
            statusImage.image = UIImage(systemName: Strings.notStartedImage)
            statusImage.tintColor = .red
        case .inProgress:
            statusImage.image = UIImage(systemName: Strings.inProgressImage)
            statusImage.tintColor = .yellow
        case .completed:
            statusImage.image = UIImage(systemName: Strings.completedImage)
            statusImage.tintColor = .green
        case .postponed:
            statusImage.image = UIImage(systemName: Strings.postponedImage)
            statusImage.tintColor = .gray
        }
        nameLabel.text = issue.name
        if openedFromProject {
            projectLabel.isHidden = true
        } else {
            projectLabel.text = issue.project?.name
        }
    }
    
    @objc private func editTapped(_ sender: Any) {
        let editor = IssueEditController(
            isNew: false,
            openedFromProject: openedFromProject,
            project: project,
            issue: openedFromProject ? project.issues[currentIndex] : projectStore.allIssues[currentIndex],
            updateTable: updateTable,
            nm: nm,
            projectStore: projectStore,
            employeeStore: employeeStore,
            settings: settings)
        editor.modalPresentationStyle = .pageSheet
        present(editor)
    }
    
    private func setupUI() {
        self.autoresizingMask = .flexibleHeight
        self.translatesAutoresizingMaskIntoConstraints = true
        
        statusImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statusImage)
        
        let stack = UIStackView()
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .preferredFont(forTextStyle: .body)
        nameLabel.numberOfLines = 0
//        nameLabel.textAlignment = .left
        stack.addArrangedSubview(nameLabel)
         
        projectLabel.translatesAutoresizingMaskIntoConstraints = false
        projectLabel.font = .preferredFont(forTextStyle: .body)
        projectLabel.numberOfLines = 0
//        nameLabel.textAlignment = .left
        stack.addArrangedSubview(projectLabel)
        
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = DrawingConstants.standardSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.setImage(UIImage(systemName: Strings.editImage), for: .normal)
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        editButton.setContentHuggingPriority(.required, for: .horizontal)
        contentView.addSubview(editButton)
        
        NSLayoutConstraint.activate([
            statusImage.widthAnchor.constraint(equalToConstant: DrawingConstants.statusImageSize),
            statusImage.heightAnchor.constraint(equalToConstant: DrawingConstants.statusImageSize),
            
            statusImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DrawingConstants.standardSpacing),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: statusImage.bottomAnchor, constant: DrawingConstants.standardSpacing),
            statusImage.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: DrawingConstants.standardSpacing),
            
            stack.leadingAnchor.constraint(equalTo: statusImage.trailingAnchor, constant: DrawingConstants.standardSpacing),
            
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: stack.bottomAnchor, constant: DrawingConstants.standardSpacing),
            stack.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: DrawingConstants.standardSpacing),
            
            editButton.leadingAnchor.constraint(equalTo: stack.trailingAnchor, constant: DrawingConstants.standardSpacing),
            
            editButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentView.trailingAnchor.constraint(equalTo: editButton.trailingAnchor,  constant: DrawingConstants.standardSpacing),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: editButton.bottomAnchor,  constant: DrawingConstants.standardSpacing),
            editButton.topAnchor.constraint(greaterThanOrEqualTo: editButton.topAnchor,  constant: DrawingConstants.standardSpacing),
            
        ])
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
