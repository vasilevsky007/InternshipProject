//
//  NamedTextField.swift
//  trainingtask
//
//  Created by Alex on 2.02.24.
//

import UIKit

/// элемент интерфейса, включающий в себя стилизованные `UILabel` и `UITextField`.
/// использует констрейнты.
class NamedTextField: UIView {
    // MARK: - Properties
    private let label = UILabel()
    private let textField = UITextField()
    
    // MARK: - Computed Properties
    /// текст, который  отображен в `UILabel` над `UITextField`
    var labelText: String {
        get {
            label.text ?? ""
        }
        set {
            label.text = newValue
        }
    }
    /// текст, введенный в `UITextField`
    var enteredText: String? {
        get {
            textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
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
    @objc private func doneButtonTapped() {
        self.endEditing(true) // Закрывает клавиатуру
    }
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        let stack = UIStackView()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 0
        stack.addArrangedSubview(label)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [flexibleSpace, doneButton]
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .preferredFont(forTextStyle: .body)
        textField.borderStyle = .roundedRect
        textField.inputAccessoryView = toolbar
        stack.addArrangedSubview(textField)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = DrawingConstants.standardSpacing
        addSubview(stack)
        
       
        
        NSLayoutConstraint.activate([
            stack.widthAnchor.constraint(equalTo: self.widthAnchor),
            stack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stack.heightAnchor.constraint(equalTo: self.heightAnchor),
            stack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
