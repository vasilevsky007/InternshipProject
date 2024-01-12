//
//  Project.swift
//  trainingtask
//
//  Created by Alex on 11.01.24.
//

import Foundation

class Project: Equatable {
    var name = ""
    var descriprion = ""
    private(set) var issues: [Issue] = []
    
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.name == rhs.name &&
        lhs.descriprion == rhs.descriprion &&
        lhs.issues == rhs.issues
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
            issue.id == removingIssue.id
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
