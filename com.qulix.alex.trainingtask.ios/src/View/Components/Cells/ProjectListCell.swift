//
//  ProjectListCell.swift
//  trainingtask
//
//  Created by Alex on 16.01.24.
//

import UIKit

class ProjectListCell: UITableViewCell {
    //здесь пришлось оставить опционалы  так как нужно использовать именно инициализатор с reuseIdentifier
    
    var nm: NetworkManager!
    var projectStore: ProjectStore!
    var employeeStore: EmployeeStore!
    var settings: Settings!
    var updateTable: () -> Void = {}
    var present: (UIViewController) -> Void = {_ in}
    var openIssues: () -> Void = {}
    
    private var currentIndex: Int = -1
    
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let showButton = UIButton()
    private let editButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        self.autoresizingMask = .flexibleHeight
        self.translatesAutoresizingMaskIntoConstraints = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .preferredFont(forTextStyle: .body)
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .left
        contentView.addSubview(nameLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .preferredFont(forTextStyle: .caption1)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .justified
        contentView.addSubview(descriptionLabel)
        
        let stack = UIStackView()
        
        showButton.translatesAutoresizingMaskIntoConstraints = false
        showButton.setImage(UIImage(systemName: Strings.showImage), for: .normal)
        showButton.addTarget(self, action: #selector(showTapped), for: .touchUpInside)
        stack.addArrangedSubview(showButton)
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.setImage(UIImage(systemName: Strings.editImage), for: .normal)
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        
        stack.addArrangedSubview(editButton)
        
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = DrawingConstants.standardSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: DrawingConstants.standardSpacing),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: nameLabel.bottomAnchor, constant: DrawingConstants.standardSpacing),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: DrawingConstants.projectCellNameWidthMultipler),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DrawingConstants.standardSpacing),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: DrawingConstants.standardSpacing),
            
            descriptionLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: DrawingConstants.standardSpacing),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.bottomAnchor, constant: DrawingConstants.standardSpacing),
            descriptionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: nameLabel.trailingAnchor, constant: DrawingConstants.standardSpacing),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.trailingAnchor, constant: DrawingConstants.standardSpacing),
            
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stack.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: DrawingConstants.standardSpacing),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: stack.bottomAnchor, constant: DrawingConstants.standardSpacing),
            descriptionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentView.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: DrawingConstants.standardSpacing),
        ])
    }
    
    @objc private func showTapped() {
        openIssues()
    }
    
    @objc private func editTapped() {
        let project = projectStore.items[currentIndex]
        let editor = ProjectEditController(
            isNew: false,
            project: project,
            updateTable: updateTable,
            nm: nm,
            projectStore: projectStore,
            settings: settings)
        
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
