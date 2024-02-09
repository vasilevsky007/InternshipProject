//
//  Employee.swift
//  trainingtask
//
//  Created by Alex on 11.01.24.
//

import Foundation

/// сущность работника
class Employee: Equatable {
    // MARK: - Properties
    /// идентификатор задачи. сравнение проводится именно по нему
    let id: UUID
    var name: String
    var surname: String
    var middleName: String
    var position: String
    
    // MARK: - Computed Properties
    var fio: String {
        "\(surname) \(name.first ?? Character(" ")). \(middleName.first ?? Character(" "))."
    }
    
    // MARK: - Initializers
    /// станддартный инициализатор
    init() {
        id = UUID()
        name = ""
        surname = ""
        middleName = ""
        position = ""
    }
    
    /// инициализатор копирования
    /// - Parameter employee: исходный, старый объект
    init(_ employee: Employee) {
        id = employee.id
        name = employee.name
        surname = employee.surname
        middleName = employee.middleName
        position = employee.position
    }
    
    // MARK: - Methods
    static func == (lhs: Employee, rhs: Employee) -> Bool {
        lhs.id == rhs.id
    }
}
