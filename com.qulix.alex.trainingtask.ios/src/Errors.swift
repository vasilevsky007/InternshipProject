//
//  Errors.swift
//  trainingtask
//
//  Created by Alex on 11.01.24.
//

import Foundation

enum BusinessLogicErrors: Error {
    case maxNumOfEtriesExceeded
    case noProjectInIssue
}

extension BusinessLogicErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .maxNumOfEtriesExceeded:
            return "Превышено максимально количество сущностей в списке, заданное в настройках."
        case .noProjectInIssue:
            return "Невозможно сохранить задачу без проекта. Пожалуйста, выберите проект."
        }
        
    }
}
