//
//  ErrorResponse.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation

enum ErrorResponse: Error, LocalizedError {
    case UnknowError
    case CustomError(String, Int? = nil)
    
    var errorDescription: String? {
        switch self {
        case .UnknowError:
            return NSLocalizedString(
                "Unknow Error",
                comment: ""
            )
            
        case .CustomError(let errorMessage, _):
            return NSLocalizedString(
                "\(errorMessage)",
                comment: ""
            )
        }
    }
    
}

extension ErrorResponse: CustomNSError {
    var errorCode: Int {
        switch self {
        case .CustomError(_, let code):
            if let code {
                return code
            } else {
                return -9999
            }
            
        case .UnknowError:
            return -1
        }
    }
    
}
