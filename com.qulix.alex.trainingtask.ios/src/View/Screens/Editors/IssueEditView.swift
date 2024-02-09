//
//  IssueEditView.swift
//  trainingtask
//
//  Created by Alex on 5.02.24.
//

import UIKit

/// экран редактирования задачи.
/// использует констрейнты.
class IssueEditView: UIView {
    // MARK: - Properties
    /// поле для ввода названия задачи
    let nameField = NamedTextField()
    /// поле для ввода работы(часы)
    let workField = NamedTextField()
    /// поле для ввода даты начала задачи
    let start = DateChooser()
    /// поле для ввода даты конца задачи
    let end = DateChooser()
    /// поле для выбора статуса задачи
    let statusPicker = NamedPicker()
    /// поле для выбора работника выполняющего задачу
    let employeePicker = NamedPicker()
    /// поле для выбора проекта к которому относится задача
    let projectPicker = NamedPicker()
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
        self.backgroundColor = .systemBackground
        
        let scrollView = UIScrollView()
        let stack = UIStackView()
        
        nameField.labelText = Strings.issueName
        stack.addArrangedSubview(nameField)
        
        workField.labelText = Strings.issueWork
        stack.addArrangedSubview(workField)
        
        start.labelText = Strings.issueStart
        stack.addArrangedSubview(start)
        
        end.labelText = Strings.issueEnd
        stack.addArrangedSubview(end)
        
        statusPicker.labelText = Strings.status
        stack.addArrangedSubview(statusPicker)
        
        employeePicker.labelText = Strings.issueEmployee
        stack.addArrangedSubview(employeePicker)
        
        projectPicker.labelText = Strings.project
        stack.addArrangedSubview(projectPicker)
        
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = DrawingConstants.doubleSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        addSubview(dialogBox)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: DrawingConstants.doubleSpacing),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: DrawingConstants.doubleSpacing),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: DrawingConstants.doubleSpacing),
            
            dialogBox.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: DrawingConstants.doubleSpacing),
            
            dialogBox.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: DrawingConstants.doubleSpacing),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: dialogBox.trailingAnchor, constant: DrawingConstants.doubleSpacing),
            
            safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: dialogBox.bottomAnchor, constant: DrawingConstants.doubleSpacing)
            
        ])
    }
}
