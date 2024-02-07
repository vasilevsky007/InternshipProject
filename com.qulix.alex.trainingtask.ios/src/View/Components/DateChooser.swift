//
//  DateChooser.swift
//  trainingtask
//
//  Created by Alex on 5.02.24.
//

import UIKit

class DateChooser: UIView, UITextFieldDelegate {
    private let label = UILabel()
    private let textField = UITextField()
    private let datePicker = UIDatePicker()
    
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
    var enteredDate: Date {
        get {
            dateFormatter.date(from: textField.text ?? "") ?? datePicker.date
        }
        set {
            datePicker.date = newValue
            textField.text = dateFormatter.string(from: newValue)
        }
    }
    
    @objc private func doneButtonTapped() {
        self.endEditing(true) // Закрывает клавиатуру
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    @objc private func pickerChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        textField.text = dateFormatter.string(from: selectedDate)
    }
    func textChanged(_ newValue: String) {
        if let enteredDate = dateFormatter.date(from: newValue) {
            datePicker.date = enteredDate
        }
    }
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        let vstack = UIStackView()
        let hstack = UIStackView()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 0
        vstack.addArrangedSubview(label)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [flexibleSpace, doneButton]
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .preferredFont(forTextStyle: .body)
        textField.borderStyle = .roundedRect
        textField.inputAccessoryView = toolbar
        textField.placeholder = Strings.datePattern
        textField.delegate = self
        hstack.addArrangedSubview(textField)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(pickerChanged(_:)), for: .valueChanged)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .compact
        } else {
            // MARK: idk how to change it in other way, datePicker.datePickerStyle is get-only
        }
        hstack.addArrangedSubview(datePicker)
        
        hstack.translatesAutoresizingMaskIntoConstraints = false
        hstack.axis = .horizontal
        hstack.alignment = .center
        hstack.distribution = .fillEqually
        hstack.spacing = DrawingConstants.standardSpacing
        vstack.addArrangedSubview(hstack)
        
        vstack.translatesAutoresizingMaskIntoConstraints = false
        vstack.axis = .vertical
        vstack.alignment = .fill
        vstack.distribution = .equalSpacing
        vstack.spacing = DrawingConstants.standardSpacing
        addSubview(vstack)
        
        
        
        NSLayoutConstraint.activate([
            vstack.widthAnchor.constraint(equalTo: self.widthAnchor),
            vstack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            vstack.heightAnchor.constraint(equalTo: self.heightAnchor),
            vstack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    private func formatDateString(_ dateString: String) -> String {
        let cleanedString = dateString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        switch cleanedString.count {
        case 0...4:
            return cleanedString
        case 5...6:
            return "\(cleanedString.prefix(4))-\(cleanedString[cleanedString.index(cleanedString.startIndex, offsetBy: 4)..<cleanedString.endIndex])"
        case 7...Int.max:
            return "\(cleanedString.prefix(4))-\(cleanedString[cleanedString.index(cleanedString.startIndex, offsetBy: 4)..<cleanedString.index(cleanedString.startIndex, offsetBy: 6)])-\(cleanedString[cleanedString.index(cleanedString.startIndex, offsetBy: 6)..<cleanedString.endIndex])"
        default:
            return "\(cleanedString.prefix(4))-\(cleanedString[cleanedString.index(cleanedString.startIndex, offsetBy: 4)..<cleanedString.index(cleanedString.startIndex, offsetBy: 6)])-\(cleanedString[cleanedString.index(cleanedString.startIndex, offsetBy: 6)..<cleanedString.index(cleanedString.startIndex, offsetBy: 8)])"//MARK: chek if this ok
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Обрабатываем добавление цифр и форматируем текст
        if let currentText = textField.text,
           let range = Range(range, in: currentText) {
            
            let updatedText = currentText.replacingCharacters(in: range, with: string)
            let formatted = formatDateString(updatedText)
            textField.text = formatted
            textChanged(formatted)
            return false // Мы управляем обновлением текста
        }
        return true
    }
}
