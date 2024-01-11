//
//  Task.swift
//  trainingtask
//
//  Created by Alex on 11.01.24.
//

import Foundation

struct Task: Equatable {
    enum Status {
        case notStarted
        case inProgress
        case completed
        case postponed
    }
    
    let id = UUID()
    var name: String
    var project: Project?
    var job: TimeInterval
    var start: Date
    var end: Date
    var status: Status
    var employee: Employee?
    
    init(settings: Settings) {
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
    
    mutating func changeProject(to newProject: Project, settings: Settings) throws {
        try newProject.addTask(self, settings: settings)
        project?.removeTask(self)
        self.project = newProject
    }
    
    mutating func changeEmployee (to newEmployee: Employee) {
        self.employee = newEmployee
    }
}
