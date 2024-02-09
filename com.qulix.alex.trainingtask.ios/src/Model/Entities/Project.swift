//
//  Project.swift
//  trainingtask
//
//  Created by Alex on 11.01.24.
//

import Foundation

/// сущность проекта
class Project: Equatable {
    // MARK: - Properties
    /// идентификатор проекта. сравнение проводится именно по нему
    let id: UUID
    var name: String
    var descriprion: String
    /// массив с задачами
    /// - warning: никогда не изменять напрямую, для этого есть методы ``Project/addIssue(_:settings:)``  и   ``Project/removeIssue(_:)``
    var issues: [Issue]
    
    // MARK: - Initializers
    /// стандартный инициализатор, ничего не принимает.
    /// поля имя и описания заполняются пустыми строками
    init() {
        id = UUID()
        name = ""
        descriprion = ""
        issues = []
    }
    
    /// инициализатор копирования
    /// - Parameters:
    ///   - project: исходный, старый объект
    ///   - newEmployees: массив сущностей работников,
    ///    нужен если мы хотим привязать к другим сущностям работников (т. е создать отдельную копию все объектов).
    ///    работники в задачах на проектах выбираются с такими же полями идентификаторов как висходном объекте
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
    
    // MARK: - Methods
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.id == rhs.id
    }
    
    /// метод для добавления задачи в проект
    /// - Parameters:
    ///   - issue: собственно экземляр задачи
    ///   - settings: экемпляр настроек, используется для проверки размера списка задач
    func addIssue(_ issue: Issue, settings: Settings) throws {
        if issues.count < settings.maxEntries {
            issues.append(issue)
        } else {
            throw BusinessLogicErrors.maxNumOfEtriesExceeded
        }
    }
    
    /// метод для удаления  задач  из проекта
    /// - Parameter removingIssue: удаляема задача
    func removeIssue(_ removingIssue: Issue) {
        issues.removeAll { issue in
            issue == removingIssue
        }
    }
    
    /// удаление всех задач
    func removeAllIssues() {
        issues = []
    }
    
    /// удаление работника из всех задач, используется при удалении сущности работника, чтобы не осталось висящих ссылок на как бы уже не существующего работника
    /// - Parameter employee: сущность работника, которую надо удалить из всез задач
    func removeEmployeefromAllIssues(_ employee: Employee) {
        for i in issues.indices {
            if issues[i].employee == employee {
                issues[i].deleteEmployee()
            }
        }
    }
}
