//
//  EmployeeStore.swift
//  trainingtask
//
//  Created by Alex on 12.01.24.
//

import Foundation

actor EmployeeStore {
    private var projects: ProjectStore
    private(set) var items: [Employee]
    
    init(projects: ProjectStore) {
        self.projects = projects
        self.items = []
    }
    
    func delete(employee removingEmployee: Employee) {
        items.removeAll { employee in
            removingEmployee == employee
        }
        Task {
            await projects.removeEmployeeFromAllProjects(removingEmployee)
        }
    }
    
    func add(employee: Employee, settings: Settings) throws {
        if items.count < settings.maxEntries {
            items.append(employee)
        } else {
            throw BusinessLogicErrors.MaxNumOfEtriesExceeded
        }
    }
}
