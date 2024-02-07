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

enum InputValidationErrors: Error {
    case invalidDateInTextField
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

extension InputValidationErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidDateInTextField:
            return "Введена некорректная дата. Формат даты: \(Strings.datePattern)"
        }
    }
}
