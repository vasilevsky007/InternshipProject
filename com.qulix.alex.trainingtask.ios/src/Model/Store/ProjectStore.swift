//
//  ProjectStore.swift
//  trainingtask
//
//  Created by Alex on 12.01.24.
//

import Foundation

/// сущность для хранения проектов
@MainActor class ProjectStore {
    
    private(set) var items: [Project] = []
    
    // MARK: - Computed Properties
    var allIssues: [Issue] {//may be not the best decision in terms of performance
        var issues: [Issue] = []
        for project in items {
            issues.append(contentsOf: project.issues)
        }
        return issues
    }
    
    // MARK: - Methods
    func delete(project removingProject: Project) {
        items.removeAll { project in
            removingProject == project
        }
        removingProject.removeAllIssues()
    }
    
    func add(project: Project, settings: Settings) throws {
        if items.count < settings.maxEntries {
            items.append(project)
        } else {
            throw BusinessLogicErrors.maxNumOfEtriesExceeded
        }
    }
    
    func removeEmployeeFromAllProjects(_ employee: Employee) {
        for project in items {
            project.removeEmployeefromAllIssues(employee)
        }
    }
    
    func deleteAll() {
        self.items = []
    }
}
