//
//  RequestError+DK.swift
//  DriveKitApp
//
//  Created by Amine Gahbiche on 12/04/2022.
//  Copyright © 2022 DriveQuant. All rights reserved.
//

import Foundation
import DriveKitCoreModule

extension RequestError {
    func getErrorMessage() -> String {
        switch self {
        case .wrongUrl:
            return "client_error".keyLocalized()
        case .noNetwork:
            return "network_ko_error".keyLocalized()
        case .unauthenticated:
            return "authentication_error".keyLocalized()
        case .forbidden:
            return "forbidden_error".keyLocalized()
        case .serverError:
            return "server_error".keyLocalized()
        case .clientError:
            return "client_error".keyLocalized()
        case .unknownError:
            return "unknown_error".keyLocalized()
        }
    }
}
