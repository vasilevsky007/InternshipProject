//
//  EmployeeEditView.swift
//  trainingtask
//
//  Created by Alex on 5.02.24.
//

import UIKit

class EmployeeEditView: UIView {
    
    let nameField = NamedTextField()
    let surnameField = NamedTextField()
    let middleNameField = NamedTextField()
    let positionField = NamedTextField()
    let dialogBox = DialogButtons()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = .systemBackground
        let stack = UIStackView()
        
        nameField.labelText = Strings.employeeName
        stack.addArrangedSubview(nameField)
        
        surnameField.labelText = Strings.employeeSurname
        stack.addArrangedSubview(surnameField)
        
        middleNameField.labelText = Strings.employeeMiddlename
        stack.addArrangedSubview(middleNameField)
        
        positionField.labelText = Strings.employeePosition
        stack.addArrangedSubview(positionField)
        
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = DrawingConstants.doubleSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        addSubview(dialogBox)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: DrawingConstants.doubleSpacing),
            stack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: DrawingConstants.doubleSpacing),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: DrawingConstants.doubleSpacing),
            
            dialogBox.topAnchor.constraint(greaterThanOrEqualTo: stack.bottomAnchor, constant: DrawingConstants.doubleSpacing),
            
            dialogBox.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: DrawingConstants.doubleSpacing),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: dialogBox.trailingAnchor, constant: DrawingConstants.doubleSpacing),
            
            safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: dialogBox.bottomAnchor, constant: DrawingConstants.doubleSpacing)
            
        ])
    }
}
