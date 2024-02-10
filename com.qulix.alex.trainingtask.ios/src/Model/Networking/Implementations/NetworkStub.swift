//
//  NetworkStub.swift
//  trainingtask
//
//  Created by Alex on 12.01.24.
//

import Foundation

/// объект, эмулирующий работу с сервером. хранит отдельные маасивы объектов сущностей, не связанные с основной программой
class NetworkStub: NetworkManager {
    private var projects: [Project] = []
    private var employees: [Employee] = []
    private let serialQueue = DispatchQueue.init(label: "NetworkStubQ")
    
    // MARK: - Methods
    func fetchAll(completion: @escaping (_ result: (projects: [Project], employees: [Employee])?, _ error: Error?) -> Void ) {
        serialQueue.asyncAfter(deadline: .now().advanced(by: .seconds(1))) {
            var newProjects: [Project] = []
            var newEmployees: [Employee] = []
            for employee in self.employees {
                newEmployees.append(Employee(employee))
            }
            for project in self.projects {
                newProjects.append(Project(project, newEmployees: newEmployees))
            }
            DispatchQueue.main.async {
                completion((newProjects, newEmployees), nil)
            }
        }
    }
    
    func deleteProjectRequest(_ removingProject: Project, completion: @escaping (_ error: Error?) -> Void) {
        serialQueue.asyncAfter(deadline: .now().advanced(by: .seconds(1))){
            self.projects.removeAll { project in
                removingProject == project
            }
            removingProject.removeAllIssues()
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
    func addProjectRequest(project: Project, completion: @escaping (Error?) -> Void) {
        serialQueue.asyncAfter(deadline: .now().advanced(by: .seconds(1))){
            self.projects.append(Project(project, newEmployees: self.employees))
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
    func changeProjectRequest(newValue: Project, completion: @escaping (Error?) -> Void) {
        serialQueue.asyncAfter(deadline: .now().advanced(by: .seconds(1))){
            if let index = self.projects.firstIndex(of: newValue) {
                self.projects[index].name = newValue.name
                self.projects[index].descriprion = newValue.descriprion
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
    func deleteEmployeeRequest(_ removingEmployee: Employee, completion: @escaping (Error?) -> Void) {
        serialQueue.asyncAfter(deadline: .now().advanced(by: .seconds(1))){
            self.employees.removeAll { employee in
                removingEmployee == employee
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
    func addEmployeeRequest(employee: Employee, completion: @escaping (Error?) -> Void) {
        serialQueue.asyncAfter(deadline: .now().advanced(by: .seconds(1))){
            self.employees.append(Employee(employee))
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
    func changeEmployeeRequest(newValue: Employee, completion: @escaping (Error?) -> Void) {
        serialQueue.asyncAfter(deadline: .now().advanced(by: .seconds(1))){
            if let index = self.employees.firstIndex(of: newValue) {
                self.employees[index].name = newValue.name
                self.employees[index].middleName = newValue.middleName
                self.employees[index].position = newValue.position
                self.employees[index].surname = newValue.surname
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
    func addIssueRequest(_ issue: Issue, to project: Project, completion: @escaping (Error?) -> Void) {
        serialQueue.asyncAfter(deadline: .now().advanced(by: .seconds(1))){
            if let index = self.projects.firstIndex(of: project) {
                self.projects[index].issues.append(Issue(issue, newEmployees: self.employees))
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
    func removeIssueRequest(_ removingIssue: Issue, completion: @escaping (Error?) -> Void) {
        serialQueue.asyncAfter(deadline: .now().advanced(by: .seconds(1))){
            for project in self.projects {
                project.removeIssue(removingIssue)
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
    func changeIssueRequest(_ changedIssue: Issue, completion: @escaping (Error?) -> Void) {
        serialQueue.asyncAfter(deadline: .now().advanced(by: .seconds(1))){
            //delete old
            for project in self.projects {
                if let index = project.issues.firstIndex(of: changedIssue) {
                    project.issues.remove(at: index)
                    break
                }
            }
            //add new
            if let project = changedIssue.project {
                if let projectIndex = self.projects.firstIndex(of: project) {
                    var newIssue = Issue(changedIssue, newEmployees: self.employees)
                    newIssue.project = self.projects[projectIndex]
                    self.projects[projectIndex].issues.append(newIssue)
                }
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
}
