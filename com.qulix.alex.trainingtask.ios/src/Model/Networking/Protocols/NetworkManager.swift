//
//  NetworkManager.swift
//  trainingtask
//
//  Created by Alex on 12.01.24.
//

import Foundation

/// протокол для определения методов, которыми должен обладать объект взаимодействия с сервером
protocol NetworkManager {
    func fetchAll(completion: @escaping (_ result: (projects: [Project], employees: [Employee])?, _ error: Error?) -> Void )
    
    func deleteProjectRequest(_ removingProject: Project, completion: @escaping (_ error: Error?) -> Void)
    
    func addProjectRequest(project: Project, completion: @escaping (Error?) -> Void)
    
    func changeProjectRequest(newValue: Project, completion: @escaping (Error?) -> Void)
    
    func deleteEmployeeRequest(_ removingEmployee: Employee, completion: @escaping (Error?) -> Void)
    
    func addEmployeeRequest(employee: Employee, completion: @escaping (Error?) -> Void)
    
    func changeEmployeeRequest(newValue: Employee, completion: @escaping (Error?) -> Void)
    
    func addIssueRequest(_ issue: Issue, to project: Project, completion: @escaping (Error?) -> Void)
    
    func removeIssueRequest(_ removingIssue: Issue, completion: @escaping (Error?) -> Void)
    
    func changeIssueRequest(_ changedIssue: Issue, completion: @escaping (Error?) -> Void)
}
