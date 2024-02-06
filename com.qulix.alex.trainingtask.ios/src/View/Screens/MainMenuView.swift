//
//  MainMenuView.swift
//  trainingtask
//
//  Created by Alex on 31.01.24.
//

import UIKit

class MainMenuView: UIView {
    
    var projects = UIButton()
    var issues = UIButton()
    var employees = UIButton()
    var settings = UIButton()

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
        projects.setTitle(Strings.projets, for: .normal)
        stack.addArrangedSubview(projects)
        
        issues.setTitle(Strings.issues, for: .normal)
        stack.addArrangedSubview(issues)
        
        employees.setTitle(Strings.employees, for: .normal)
        stack.addArrangedSubview(employees)
        
        settings.setTitle(Strings.settings, for: .normal)
        stack.addArrangedSubview(settings)
        
        for button in stack.arrangedSubviews {
            if let button = button as? UIButton {
                button.isOpaque = false
                button.backgroundColor = .separator
                button.setTitleColor(.link, for: .normal)
                button.contentEdgeInsets = UIEdgeInsets(
                    top: DrawingConstants.standardSpacing,
                    left: DrawingConstants.standardSpacing,
                    bottom: DrawingConstants.standardSpacing,
                    right: DrawingConstants.standardSpacing
                )
            }
        }
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = DrawingConstants.standardSpacing
        addSubview(stack)
        // Добавьте настройку ограничений (constraints) или фреймов по необходимости
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

}
