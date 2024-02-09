//
//  NetworkStub.swift
//  trainingtask
//
//  Created by Alex on 12.01.24.
//

import Foundation

/// объект, эмулирующий работу с сервером. хранит отдельные маасивы объектов сущностей, не связанные с основной программой
actor NetworkStub: NetworkManager {
    private var projects: [Project] = []
    private var employees: [Employee] = []
    
    // MARK: - Methods
    func fetchAll() async throws -> (projects: [Project], employees: [Employee]) {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        var newProjects: [Project] = []
        var newEmployees: [Employee] = []
        for employee in employees {
            newEmployees.append(Employee(employee))
        }
        for project in projects {
            newProjects.append(Project(project, newEmployees: newEmployees))
        }
        return (newProjects, newEmployees)
    }
    
    func deleteProjectRequest(_ removingProject: Project) async throws {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        projects.removeAll { project in
            removingProject == project
        }
        removingProject.removeAllIssues()
    }
    
    func addProjectRequest(project: Project) async throws {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        projects.append(Project(project, newEmployees: employees))
    }
    
    func changeProjectRequest(newValue: Project) async throws {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        if let index = projects.firstIndex(of: newValue) {
            projects[index].name = newValue.name
            projects[index].descriprion = newValue.descriprion
        }
    }
    
    func deleteEmployeeRequest(_ removingEmployee: Employee) async throws {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        employees.removeAll { employee in
            removingEmployee == employee
        }
    }
    
    func addEmployeeRequest(employee: Employee) async throws {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        employees.append(Employee(employee))
    }
    
    func changeEmployeeRequest(newValue: Employee) async throws {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        if let index = employees.firstIndex(of: newValue) {
            employees[index].name = newValue.name
            employees[index].middleName = newValue.middleName
            employees[index].position = newValue.position
            employees[index].surname = newValue.surname
        }
    }
    
    func addIssueRequest(_ issue: Issue, to project: Project ) async throws {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        if let index = projects.firstIndex(of: project) {
            projects[index].issues.append(Issue(issue, newEmployees: employees))
        }
    }
    
    func removeIssueRequest(_ removingIssue: Issue) async throws {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        for project in projects {
            project.removeIssue(removingIssue)
        }
    }
    
    func changeIssueRequest(_ changedIssue: Issue) async throws {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        //delete old
        for project in projects {
            if let index = project.issues.firstIndex(of: changedIssue) {
                project.issues.remove(at: index)
                break
            }
        }
        //add new
        if let project = changedIssue.project {
            if let projectIndex = projects.firstIndex(of: project) {
                var newIssue = Issue(changedIssue, newEmployees: employees)
                newIssue.project = projects[projectIndex]
                projects[projectIndex].issues.append(newIssue)
            }
        }
    }
}
