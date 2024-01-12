//
//  Employee.swift
//  trainingtask
//
//  Created by Alex on 11.01.24.
//

import Foundation

class Employee: Equatable {
    let id = UUID()
    var name = ""
    var surname = ""
    var middleName = ""
    var position = ""
    
    
    static func == (lhs: Employee, rhs: Employee) -> Bool {
        lhs.id == rhs.id
    }
}
