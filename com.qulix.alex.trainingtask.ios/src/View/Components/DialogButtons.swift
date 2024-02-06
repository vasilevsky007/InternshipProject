//
//  DialogButtons.swift
//  trainingtask
//
//  Created by Alex on 2.02.24.
//

import UIKit

class DialogButtons: UIView {

    private let cancelButton = UIButton()
    private let saveButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    var saveAction: () -> Void = {}
    var cancelAction: () -> Void = {}
    
    @objc private func saveTapped() {
        saveAction()
    }
    @objc private func cancelTapped() {
        cancelAction()
    }
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        let stack = UIStackView()
        
        saveButton.setTitle(Strings.save, for: .normal)
        saveButton.setTitleColor(.link, for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        stack.addArrangedSubview(saveButton)
        
        cancelButton.setTitle(Strings.cancel, for: .normal)
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        stack.addArrangedSubview(cancelButton)
        
        for button in stack.arrangedSubviews {
            if let button = button as? UIButton {
                button.setContentHuggingPriority(.required, for: .horizontal)
                button.isOpaque = false
                button.backgroundColor = .separator
                button.contentEdgeInsets = UIEdgeInsets(
                    top: DrawingConstants.standardSpacing,
                    left: DrawingConstants.standardSpacing,
                    bottom: DrawingConstants.standardSpacing,
                    right: DrawingConstants.standardSpacing
                )
            }
        }
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.widthAnchor.constraint(equalTo: self.widthAnchor),
            stack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stack.heightAnchor.constraint(equalTo: self.heightAnchor),
            stack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }

}
