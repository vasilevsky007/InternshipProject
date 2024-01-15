//
//  NetworkStub.swift
//  trainingtask
//
//  Created by Alex on 12.01.24.
//

import Foundation

actor NetworkStub: NetworkManager {
    private var projects: [Project] = []
    private var employees: [Employee] = []
    
    func fetchAll() async throws -> (projects: [Project], employees: [Employee]) {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return (projects, employees)
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
        for project in projects {
            if let index = project.issues.firstIndex(of: changedIssue) {
                project.issues[index].end = changedIssue.end
                project.issues[index].start = changedIssue.start
                project.issues[index].job = changedIssue.job
                project.issues[index].name = changedIssue.name
                project.issues[index].status = changedIssue.status
                if changedIssue.project != nil {
                    if let projectIndex = projects.firstIndex(of: changedIssue.project!) {
                        project.issues[index].project = projects[projectIndex]
                    } else {
                        project.issues[index].project = nil
                    }
                } else {
                    project.issues[index].project = nil
                }
                if changedIssue.employee != nil {
                    if let employeeIndex = employees.firstIndex(of: changedIssue.employee!) {
                        project.issues[index].employee = employees[employeeIndex]
                    } else {
                        project.issues[index].employee = nil
                    }
                } else {
                    project.issues[index].employee = nil
                }
                break
            }
        }
    }
}
