//
//  SettingsView.swift
//  trainingtask
//
//  Created by Alex on 2.02.24.
//

import UIKit
/// экран настроек.
/// использует констрейнты.
class SettingsView: UIView {
    // MARK: - Properties
    /// поле для ввода URL сервера
    let urlField = NamedTextField()
    /// поле для ввода максимального количества записей в списках
    let entriesField = NamedTextField()
    /// поле для ввода стандартного количества дней между начальной и конечной датой зачачи
    let daysField = NamedTextField()
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
