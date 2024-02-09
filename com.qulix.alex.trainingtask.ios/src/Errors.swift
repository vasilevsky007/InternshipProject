//
//  Errors.swift
//  trainingtask
//
//  Created by Alex on 11.01.24.
//

import Foundation

/// ошибки связанные с непосредсвенной логикой, описанной в заднии от заказчика
enum BusinessLogicErrors: Error {
    case maxNumOfEtriesExceeded
    case noProjectInIssue
}
/// ошибки связанные с валидацией полей
enum InputValidationErrors: Error {
    case invalidDateInTextField
}
/// ошибки связанные с неправильным использованием контролеров
enum vcErrors: Error {
    case nilProjectWhenOpenedFromProject
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

extension vcErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .nilProjectWhenOpenedFromProject:
            return "Не передан проект при открытии из проекта"
        }
    }
}
