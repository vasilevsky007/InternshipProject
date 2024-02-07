//
//  Issue.swift
//  trainingtask
//
//  Created by Alex on 11.01.24.
//

import Foundation

struct Issue: Equatable {
    enum Status: String {
        case notStarted = "Не начата"
        case inProgress = "В процессе"
        case completed = "Завершена"
        case postponed = "Отложена"
    }
    
    let id:  UUID
    var name: String
    var project: Project?
    var job: TimeInterval
    var start: Date
    var end: Date
    var status: Status
    var employee: Employee?
    
    init(settings: Settings) {
        self.id = UUID()
        self.name = ""
        self.project = nil
        self.job = 0
        self.start = {
            if #available(iOS 15, *) {
                return Date.now
            } else {
                return Date()
            }
        }()
        self.end = {
            if #available(iOS 15, *) {
                return Date.now.addingTimeInterval(settings.defaultBetweenStartAndEnd)
            } else {
                return Date().addingTimeInterval(settings.defaultBetweenStartAndEnd)
            }
        }()
        self.status = .notStarted
        self.employee = nil
    }
    
    init(settings: Settings, project: Project) throws {
        self.id = UUID()
        self.name = ""
        self.project = project
        self.job = 0
        self.start = {
            if #available(iOS 15, *) {
                return Date.now
            } else {
                return Date()
            }
        }()
        self.end = {
            if #available(iOS 15, *) {
                return Date.now.addingTimeInterval(settings.defaultBetweenStartAndEnd)
            } else {
                return Date().addingTimeInterval(settings.defaultBetweenStartAndEnd)
            }
        }()
        self.status = .notStarted
        self.employee = nil
        try project.addIssue(self, settings: settings)
    }
    
    init(_ issue: Issue, newEmployees: [Employee]) {
        id = issue.id
        name = issue.name
        project = issue.project //MARK: this is not copy. it should be changed in Project init after initialization
        job = issue.job
        start = issue.start
        end = issue.end
        status = issue.status
        if let index = newEmployees.firstIndex (
            where: { employee in
                employee == issue.employee
            }) {
            employee = newEmployees[index]
        }
    }
    
    static func == (lhs: Issue, rhs: Issue) -> Bool {
        lhs.id == rhs.id
    }
    
    mutating func changeProject(to newProject: Project, settings: Settings) throws {
        project?.removeIssue(self)
        project = newProject
        try newProject.addIssue(self, settings: settings)
    }
    
    mutating func changeEmployee(to newEmployee: Employee) {
        self.employee = newEmployee
    }
    
    mutating func deleteEmployee() {
        self.employee = nil
    }
}
