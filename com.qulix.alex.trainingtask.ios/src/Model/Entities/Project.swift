//
//  Project.swift
//  trainingtask
//
//  Created by Alex on 11.01.24.
//

import Foundation

class Project: Equatable {
    let id: UUID
    var name: String
    var descriprion: String
    var issues: [Issue]
    
    init() {
        id = UUID()
        name = ""
        descriprion = ""
        issues = []
    }
    
    init(_ project: Project, newEmployees: [Employee]) {
        self.id = project.id
        self.name = project.name
        self.descriprion = project.descriprion
        self.issues = []
        for issue in project.issues {
            self.issues.append(Issue(issue, newEmployees: newEmployees))
        }
        for i in self.issues.indices {
            issues[i].project = self
        }
        
    }
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.id == rhs.id
    }
    
    func addIssue(_ issue: Issue, settings: Settings) throws {
        if issues.count < settings.maxEntries {
            issues.append(issue)
        } else {
            throw BusinessLogicErrors.MaxNumOfEtriesExceeded
        }
    }
    
    func removeIssue(_ removingIssue: Issue) {
        issues.removeAll { issue in
            issue == removingIssue
        }
    }
    
    func removeAllIssues() {
        issues = []
    }
    
    func removeEmployeefromAllIssues(_ employee: Employee) {
        for i in issues.indices {
            if issues[i].employee == employee {
                issues[i].deleteEmployee()
            }
        }
    }
}
