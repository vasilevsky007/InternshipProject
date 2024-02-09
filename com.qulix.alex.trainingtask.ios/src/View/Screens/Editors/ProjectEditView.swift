//
//  ProjectEditView.swift
//  trainingtask
//
//  Created by Alex on 5.02.24.
//

import UIKit

/// экран редактирования проекта.
/// использует констрейнты.
class ProjectEditView: UIView {
    // MARK: - Properties
    /// поле для ввода названия проекта
    let nameField = NamedTextField()
    /// поле для ввода описания проекта
    let descriptionField = NamedTextView()
    /// кнопки сохранения/отмены
    let dialogBox = DialogButtons()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - Methods
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemBackground
        
        
        nameField.labelText = Strings.projectName
        addSubview(nameField)
        
        descriptionField.labelText = Strings.projectDescription
        addSubview(descriptionField)
        
        addSubview(dialogBox)
        
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: DrawingConstants.doubleSpacing),
            nameField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: DrawingConstants.doubleSpacing),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: nameField.trailingAnchor, constant: DrawingConstants.doubleSpacing),
            
            descriptionField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: DrawingConstants.doubleSpacing),
            
            descriptionField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: DrawingConstants.doubleSpacing),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: descriptionField.trailingAnchor, constant: DrawingConstants.doubleSpacing),
            
            
            dialogBox.topAnchor.constraint(equalTo: descriptionField.bottomAnchor, constant: DrawingConstants.doubleSpacing),
            
            dialogBox.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: DrawingConstants.doubleSpacing),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: dialogBox.trailingAnchor, constant: DrawingConstants.doubleSpacing),
            safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: dialogBox.bottomAnchor, constant: DrawingConstants.doubleSpacing)
            
        ])
    }
}
