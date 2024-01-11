//
//  Employee.swift
//  trainingtask
//
//  Created by Alex on 11.01.24.
//

import Foundation

class Employee: Equatable {
    var name = ""
    var surname = ""
    var middleName = ""
    var position = ""
    
    
    static func == (lhs: Employee, rhs: Employee) -> Bool {
        lhs.name == rhs.name &&
        lhs.surname == rhs.surname &&
        lhs.middleName == rhs.middleName &&
        lhs.position == rhs.position
    }
}
