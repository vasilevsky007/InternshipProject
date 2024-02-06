//
//  NamedTextView.swift
//  trainingtask
//
//  Created by Alex on 5.02.24.
//

import UIKit

class NamedTextView: UIView {
    private let label = UILabel()
    private let texView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    var labelText: String {
        get {
            label.text ?? ""
        }
        set {
            label.text = newValue
        }
    }
    var enteredText: String? {
        get {
            texView.text
        }
        set {
            texView.text = newValue
        }
    }
    
    @objc private func doneButtonTapped() {
        self.endEditing(true) // Закрывает клавиатуру
    }
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 0
        addSubview(label)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [flexibleSpace, doneButton]
        
        texView.translatesAutoresizingMaskIntoConstraints = false
        texView.font = .preferredFont(forTextStyle: .body)
        texView.inputAccessoryView = toolbar
        texView.layer.cornerRadius = DrawingConstants.cornerRadius
        texView.layer.borderWidth = DrawingConstants.borderWidth
        texView.layer.borderColor = UIColor.separator.cgColor
        texView.enablesReturnKeyAutomatically = true
//        texView.clipsToBounds = true
        addSubview(texView)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            texView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: DrawingConstants.standardSpacing),
            
            texView.leadingAnchor.constraint(equalTo: leadingAnchor),
            texView.trailingAnchor.constraint(equalTo: trailingAnchor),
            texView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
