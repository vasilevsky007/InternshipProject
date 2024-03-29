//
//  EmployeeStore.swift
//  trainingtask
//
//  Created by Alex on 12.01.24.
//

import Foundation

/// сущность для хранения работников
@MainActor class EmployeeStore {
    private(set) var items: [Employee] = []
    
    // MARK: - Methods
    func delete(employee removingEmployee: Employee, projects: ProjectStore) {
        items.removeAll { employee in
            removingEmployee == employee
        }
        Task {
            projects.removeEmployeeFromAllProjects(removingEmployee)
        }
    }
    
    func add(employee: Employee, settings: Settings) throws {
        if items.count < settings.maxEntries {
            items.append(employee)
        } else {
            throw BusinessLogicErrors.maxNumOfEtriesExceeded
        }
    }
    
    func deleteAll() {
        self.items = []
    }
}
