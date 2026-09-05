//
//  ServiceError.swift
//  Cats
//
//  Created by Wallace Silva on 03/02/23.
//

import Foundation

enum ServiceError: Error {
    case requestCreation
    case requestError(String)
    case decode
}

extension ServiceError: CustomStringConvertible {
    var description: String {
        switch self {
        case .requestCreation:
            return "There was an error while creating request"
        case .requestError(let message):
            return "There was an error with the request\n\(String(describing: message))"
        case .decode:
            return "Error during request response decode"
        }
    }
}
