//
//  ProjectStore.swift
//  trainingtask
//
//  Created by Alex on 12.01.24.
//

import Foundation

@MainActor
class ProjectStore {
    
    private(set) var items: [Project] = []
    
    //MARK: may be not the best decision in terms of performance
    var allIssues: [Issue] {
        var issues: [Issue] = []
        for project in items {
            issues.append(contentsOf: project.issues)
        }
        return issues
    }
    
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
            throw BusinessLogicErrors.MaxNumOfEtriesExceeded
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
