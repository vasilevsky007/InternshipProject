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
    private(set) var tasks: [Task] = []
    
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.name == rhs.name &&
        lhs.descriprion == rhs.descriprion &&
        lhs.tasks == rhs.tasks
    }
    
    func addTask(_ task: Task, settings: Settings) throws {
        if tasks.count < settings.maxEntries {
            tasks.append(task)
        } else {
            throw BusinessLogicErrors.MaxNumOfEtriesExceeded
        }
    }
    
    func removeTask(_ removingTask: Task) {
        tasks.removeAll { task in
            task.id == removingTask.id
        }
    }
}
