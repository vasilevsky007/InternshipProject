//
//  ProjectStore.swift
//  trainingtask
//
//  Created by Alex on 12.01.24.
//

import Foundation

actor ProjectStore {
    private(set) var items: [Project] = []
    
    func delete(project removingProject: Project) {
        items.removeAll { project in
            removingProject == project
        }
        removingProject.removeAllIssues()
    }
    
    func add(project: Project) {
        items.append(project)
    }
    
    func removeEmployeeFromAllProjects(_ employee: Employee) {
        for project in items {
            project.removeEmployeefromAllIssues(employee)
        }
    }
}
