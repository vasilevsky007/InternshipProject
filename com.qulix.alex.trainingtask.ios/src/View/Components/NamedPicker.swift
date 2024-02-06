//
//  NamedPicker.swift
//  trainingtask
//
//  Created by Alex on 5.02.24.
//

import UIKit

class NamedPicker: UIView {
    private let label = UILabel()
    private let picker = UIPickerView()
    
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
    
    override var isUserInteractionEnabled: Bool {
        get {
            picker.isUserInteractionEnabled
        }
        set {
            picker.isUserInteractionEnabled = newValue
        }
    }
    
    func setupPicker(delegate: UIPickerViewDelegate, dataSource: UIPickerViewDataSource) {
        picker.delegate = delegate
        picker.dataSource = dataSource
    }
    
    func selectRow(_ row: Int, animated: Bool = false) {
        picker.selectRow(row, inComponent: 0, animated: animated)
    }
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        let stack = UIStackView()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 0
        stack.addArrangedSubview(label)
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(picker)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = DrawingConstants.standardSpacing
        addSubview(stack)
        
        
        
        NSLayoutConstraint.activate([
            picker.heightAnchor.constraint(equalToConstant: DrawingConstants.pickerHeight),
            stack.widthAnchor.constraint(equalTo: self.widthAnchor),
            stack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stack.heightAnchor.constraint(equalTo: self.heightAnchor),
            stack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }}
