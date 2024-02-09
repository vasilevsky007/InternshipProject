//
//  NetworkManager.swift
//  trainingtask
//
//  Created by Alex on 12.01.24.
//

import Foundation

/// протокол для определения методов, которыми должен обладать объект взаимодействия с сервером
protocol NetworkManager {
    func fetchAll() async throws -> (projects: [Project], employees: [Employee])
    
    func deleteProjectRequest(_ removingProject: Project) async throws
    
    func addProjectRequest(project: Project) async throws
    
    func changeProjectRequest(newValue: Project) async throws
    
    func deleteEmployeeRequest(_ removingEmployee: Employee) async throws
    
    func addEmployeeRequest(employee: Employee) async throws
    
    func changeEmployeeRequest(newValue: Employee) async throws
    
    func addIssueRequest(_ issue: Issue, to project: Project ) async throws
    
    func removeIssueRequest(_ removingIssue: Issue) async throws
    
    func changeIssueRequest(_ changedIssue: Issue) async throws
}
