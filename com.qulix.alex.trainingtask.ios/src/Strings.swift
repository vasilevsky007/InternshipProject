//
//  Strings.swift
//  trainingtask
//
//  Created by Alex on 31.01.24.
//

import Foundation

/// структура содержащая в себе все строковые константы
struct Strings {
    //MARK: - Localization
    static let projets = "Проекты"
    static let project = "Проект"
    static let issues = "Задачи"
    static let employees = "Сотрудники"
    static let settings = "Настройки"
    static let mainMenu = "Главное меню"
    static let save = "Сохранить"
    static let cancel = "Отменить"
    static let urlSettingsLabel = "URL сервера"
    static let entriesSettingsLabel = "Максимальное количество записей в списках"
    static let daysSettingsLabel = "Количество дней по умолчанию между начальной и конечной датами в задаче"
    static let projectName = "Название проекта"
    static let projectDescription = "Описание проекта"
    static let employeeName = "Имя работника"
    static let employeeSurname = "Фамилия работника"
    static let employeeMiddlename = "Отчество работника"
    static let employeePosition = "Должность работника"
    static let datePattern = "ГГГГ-ММ-ДД"
    static let issueName = "Название задачи"
    static let issueWork = "Работа (часы)"
    static let issueStart = "Дата начала"
    static let issueEnd = "Дата окончания"
    static let status = "Статус"
    static let notSelected = "Не выбран"
    static let issueEmployee = "Исполнитель"
    static let updateMessage = "Загрузка данных с сервера"
    static let updateDoneMessage = "Данные успешно загружены с сервера"
    static let error = "Ошибка "
    static let deleteMessage = "Удаление с сервера"
    static let deleteDoneMessage = "Данные успешно удалены с сервера"
    static let saveMessage = "Сохранение данных на сервере"
    static let saveDoneMessage = "Данные успешно сохранены на сервере"
    
    
    //MARK: - Sources names
    static let reloadImage = "arrow.clockwise"
    static let addImage = "plus.circle"
    static let showImage = "eye"
    static let editImage = "square.and.pencil"
    static let okImage = "checkmark"
    static let errorImage = "xmark"
    static let deleteImage = "trash"
    static let notStartedImage = "circle"
    static let inProgressImage = "scope"
    static let completedImage = "checkmark.circle"
    static let postponedImage = "arrow.uturn.down.circle"
    
    
    //MARK: - Identifers
    static let userdefaultsSettingsKey = "settings"
    static let projectCellId = "ProjectListCell"
    static let employeeCellId = "EmployeeListCell"
    static let issueCellId = "EmployeeListCell"
}
