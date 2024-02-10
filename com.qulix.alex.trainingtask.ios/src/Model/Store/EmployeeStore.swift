//
//  EmployeeStore.swift
//  trainingtask
//
//  Created by Alex on 12.01.24.
//

import Foundation

/// сущность для хранения работников
class EmployeeStore {
    // MARK: - Properties
    private(set) var items: [Employee] = []
    private var serialQueue = DispatchQueue.init(label: "EmployeeStoreQ")
    
    // MARK: - Methods
    func delete(employee removingEmployee: Employee, projects: ProjectStore) {
        serialQueue.sync {
            items.removeAll { employee in
                removingEmployee == employee
            }
            projects.removeEmployeeFromAllProjects(removingEmployee)
        }
    }
    
    func add(employee: Employee, settings: Settings) throws {
        try serialQueue.sync {
            if items.count < settings.maxEntries {
                items.append(employee)
            } else {
                throw BusinessLogicErrors.maxNumOfEtriesExceeded
            }
        }
    }
    
    func deleteAll() {
        serialQueue.sync {
            self.items = []
        }
    }
}
