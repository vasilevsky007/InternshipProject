//
//  Employee.swift
//  trainingtask
//
//  Created by Alex on 11.01.24.
//

import Foundation

class Employee: Equatable {
    let id: UUID
    var name: String
    var surname: String
    var middleName: String
    var position: String
    
    init() {
        id = UUID()
        name = ""
        surname = ""
        middleName = ""
        position = ""
    }
    
    init(_ employee: Employee) {
        id = employee.id
        name = employee.name
        surname = employee.surname
        middleName = employee.middleName
        position = employee.position
    }
    
    static func == (lhs: Employee, rhs: Employee) -> Bool {
        lhs.id == rhs.id
    }
}
