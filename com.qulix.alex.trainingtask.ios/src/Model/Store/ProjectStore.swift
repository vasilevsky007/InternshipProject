//
//  ProjectStore.swift
//  trainingtask
//
//  Created by Alex on 12.01.24.
//

import Foundation

/// сущность для хранения проектов
class ProjectStore {
    // MARK: - Properties
    private(set) var items: [Project] = []
    private var serialQueue = DispatchQueue.init(label: "EmployeeStoreQ")
    
    // MARK: - Computed Properties
    var allIssues: [Issue] {//may be not the best decision in terms of performance; also this is not fully thread-safe
        var issues: [Issue] = []
        for project in items {
            issues.append(contentsOf: project.issues)
        }
        return issues
    }
    
    // MARK: - Methods
    func delete(project removingProject: Project) {
        serialQueue.sync {
            items.removeAll { project in
                removingProject == project
            }
            removingProject.removeAllIssues()
        }
    }
    
    func add(project: Project, settings: Settings) throws {
        try serialQueue.sync {
            if items.count < settings.maxEntries {
                items.append(project)
            } else {
                throw BusinessLogicErrors.maxNumOfEtriesExceeded
            }
        }
    }
    
    func removeEmployeeFromAllProjects(_ employee: Employee) {
        serialQueue.sync {
            for project in items {
                project.removeEmployeefromAllIssues(employee)
            }
        }
    }
    
    func deleteAll() {
        serialQueue.sync {
            self.items = []
        }
    }
}
