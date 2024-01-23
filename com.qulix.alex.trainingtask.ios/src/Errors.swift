//
//  Errors.swift
//  trainingtask
//
//  Created by Alex on 11.01.24.
//

import Foundation

enum BusinessLogicErrors: Error {
    case maxNumOfEtriesExceeded
}

extension BusinessLogicErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .maxNumOfEtriesExceeded:
            return "Exceeded the maximum number of items in a list from settings."
        }
    }
}
