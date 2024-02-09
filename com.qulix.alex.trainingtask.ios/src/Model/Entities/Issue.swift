//
//  Issue.swift
//  trainingtask
//
//  Created by Alex on 11.01.24.
//

import Foundation

/// сущность задачи
struct Issue: Equatable {
    ///состояние задачи
    enum Status: String, CaseIterable {
        case notStarted = "Не начата"
        case inProgress = "В процессе"
        case completed = "Завершена"
        case postponed = "Отложена"
    }
    
    // MARK: - Properties
    /// идентификатор задачи. сравнение проводится именно по нему
    let id:  UUID
    var name: String
    /// ссылка на проект, которому принадлежит данная задача (и в котором она и хранится)
    /// - important: никогда не должно быть  nil, кроме как после начальной инициализации. т. е. при сохранении в проект всегда необходимо заполнять это поле соответсвующе
    /// - warning: лучше никогда вручную не изменять, а пользоваться ``Issue/changeProject(to:settings:)`` для того чтобы не только изменить значение поля, но и переместить задачу в нужный объект
    var project: Project?
    var job: TimeInterval
    var start: Date
    var end: Date
    var status: Status
    var employee: Employee?
    
    // MARK: - Initializers
    /// стандартный инициализатор
    /// - Parameter settings: используется для получения интервала между датой  начала и конца
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
    
    /// инициализатор, который сразу добавляет задачу в проект
    /// - Parameters:
    ///   - settings: объект настроек, используется для получения интервала между датой  начала и конца
    ///   - project: проект в котрый должна добавляться задача
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
    
    /// инициализатор копирования
    /// - Parameters:
    ///   - issue: исходный, старый объект
    ///   - newEmployees: массив сущностей работников,
    ///    нужен если мы хотим привязать к другим сущностям работников (т. е создать отдельную копию все объектов).
    ///    работники в задачах на проектах выбираются с такими же полями идентификаторов как висходном объекте
    /// - Important: поле ``Issue/project`` должно быть заменено, для корректной копии всей базы в памяти
    init(_ issue: Issue, newEmployees: [Employee]) {
        id = issue.id
        name = issue.name
        project = issue.project //this is not copy. it should be changed in Project init after initialization
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
    
    // MARK: - Methods
    static func == (lhs: Issue, rhs: Issue) -> Bool {
        lhs.id == rhs.id
    }
    
    /// метод, не только изменяющий значене поля, но и перемещающий задачу в новый объект
    /// - Parameters:
    ///   - newProject: новый объект, в который должна быть помещена задача
    ///   - settings: объект настроек, для собдюдения размеров списка
    mutating func changeProject(to newProject: Project, settings: Settings) throws {
        project?.removeIssue(self)
        project = newProject
        try newProject.addIssue(self, settings: settings)
    }
    
    mutating func deleteEmployee() {
        self.employee = nil
    }
}
