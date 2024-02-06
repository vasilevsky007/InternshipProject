//
//  SettingsView.swift
//  trainingtask
//
//  Created by Alex on 2.02.24.
//

import UIKit

class SettingsView: UIView {
    
    let urlField = NamedTextField()
    let entriesField = NamedTextField()
    let daysField = NamedTextField()
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
        
        urlField.labelText = Strings.urlSettingsLabel
        stack.addArrangedSubview(urlField)
        
        entriesField.labelText = Strings.entriesSettingsLabel
        stack.addArrangedSubview(entriesField)
        
        daysField.labelText = Strings.daysSettingsLabel
        stack.addArrangedSubview(daysField)
        
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
