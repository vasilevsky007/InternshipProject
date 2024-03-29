//
//  EmployeeListCell.swift
//  trainingtask
//
//  Created by Alex on 17.01.24.
//

import UIKit

/// клетка  таблицы,  для отображения работника.
/// использует констрейнты.
///  - Important: используйте ``setup(forEmployeeAtIndex:nm:projectStore:employeeStore:settings:updateTable:present:)``
///  сразу посне получения с помощью `.dequeueReusableCell(withIdentifier: Strings.projectCellId, for: indexPath)`
class EmployeeListCell: UITableViewCell {
    // MARK: - Properties
    private var nm: NetworkManager!
    private var projectStore: ProjectStore!
    private var employeeStore: EmployeeStore!
    private var settings: Settings!
    private var updateTable: () -> Void = {}
    private var present: (UIViewController) -> Void = {_ in}
    
    private var currentIndex: Int = -1
    
    private let nameLabel = UILabel()
    private let surnameLabel = UILabel()
    private let middleNameLabel = UILabel()
    private let positionLabel = UILabel()
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
        forEmployeeAtIndex index: Int,
        nm: NetworkManager,
        projectStore: ProjectStore,
        employeeStore: EmployeeStore,
        settings: Settings,
        updateTable: @escaping () -> Void,
        present: @escaping (UIViewController) -> Void
    ) {
        self.nm = nm
        self.projectStore = projectStore
        self.employeeStore = employeeStore
        self.settings = settings
        self.updateTable = updateTable
        self.present = present
        currentIndex = index
        let employee = employeeStore.items[index]
        nameLabel.text = employee.name
        surnameLabel.text = employee.surname
        middleNameLabel.text = employee.middleName
        positionLabel.text = employee.position
    }
    
    @objc private func editTapped(_ sender: UIButton) {
        let editor = EmployeeEditController(
            isNew: false,
            employee: employeeStore.items[currentIndex],
            updateTable: updateTable,
            nm: nm,
            employeeStore: employeeStore,
            settings: settings)
        editor.modalPresentationStyle = .pageSheet
        present(editor) //Cannot find 'present' in scope
    }
    
    private func setupUI() {
        self.autoresizingMask = .flexibleHeight
        self.translatesAutoresizingMaskIntoConstraints = true
        
        let stack = UIStackView()
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .preferredFont(forTextStyle: .body)
        nameLabel.numberOfLines = 0
//        nameLabel.textAlignment = .left
        stack.addArrangedSubview(nameLabel)
        
        surnameLabel.translatesAutoresizingMaskIntoConstraints = false
        surnameLabel.font = .preferredFont(forTextStyle: .body)
        surnameLabel.numberOfLines = 0
//        nameLabel.textAlignment = .left
        stack.addArrangedSubview(surnameLabel)
        
        middleNameLabel.translatesAutoresizingMaskIntoConstraints = false
        middleNameLabel.font = .preferredFont(forTextStyle: .body)
        middleNameLabel.numberOfLines = 0
//        nameLabel.textAlignment = .left
        stack.addArrangedSubview(middleNameLabel)
        
        positionLabel.translatesAutoresizingMaskIntoConstraints = false
        positionLabel.font = .preferredFont(forTextStyle: .body)
        positionLabel.numberOfLines = 0
//        nameLabel.textAlignment = .left
        stack.addArrangedSubview(positionLabel)
        
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
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DrawingConstants.standardSpacing),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: stack.bottomAnchor, constant: DrawingConstants.standardSpacing),
            stack.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: DrawingConstants.standardSpacing),
            
            editButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentView.trailingAnchor.constraint(equalTo: editButton.trailingAnchor,  constant: DrawingConstants.standardSpacing),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: editButton.bottomAnchor,  constant: DrawingConstants.standardSpacing),
            editButton.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor,  constant: DrawingConstants.standardSpacing),
            editButton.leadingAnchor.constraint(equalTo: stack.trailingAnchor, constant: DrawingConstants.standardSpacing)
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
