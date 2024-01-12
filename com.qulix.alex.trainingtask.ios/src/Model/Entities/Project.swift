//
//  Project.swift
//  trainingtask
//
//  Created by Alex on 11.01.24.
//

import Foundation

class Project: Equatable {
    let id = UUID()
    var name = ""
    var descriprion = ""
    private(set) var issues: [Issue] = []
    
    
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
