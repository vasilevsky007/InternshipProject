//
//  NamedPicker.swift
//  trainingtask
//
//  Created by Alex on 5.02.24.
//

import UIKit

/// элемент интерфейса, включающий в себя стилизованные `UILabel` и `UIPickerView`.
/// использует констрейнты.
/// - Important: обязательно вызвать ``setupPicker(delegate:dataSource:)`` в методе `viewDidLoad` контроллера для корректной работы
class NamedPicker: UIView {
    // MARK: - Properties
    private let label = UILabel()
    private let picker = UIPickerView()
    
    // MARK: - Computed Properties
    /// текст, который  отображен в `UILabel` над `UIPickerView`
    var labelText: String {
        get {
            label.text ?? ""
        }
        set {
            label.text = newValue
        }
    }
    
    /// интерактивность `UIPickerView`
    override var isUserInteractionEnabled: Bool {
        get {
            picker.isUserInteractionEnabled
        }
        set {
            picker.isUserInteractionEnabled = newValue
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
    /// задание `UIPickerViewDelegate` и `UIPickerViewDataSource` для `UIPickerView`
    func setupPicker(delegate: UIPickerViewDelegate, dataSource: UIPickerViewDataSource) {
        picker.delegate = delegate
        picker.dataSource = dataSource
    }
    
    /// выбор определенного элемента
    /// - Parameters:
    ///   - row: индекс выбираемого элемента
    ///   - animated: нужно ли анимировать этот выбор
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
