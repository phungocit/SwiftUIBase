//
//  APIError.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import Foundation
import SwiftUIBase

struct APIExpiredTokenError: APIError {
    var errorDescription: String? {
        NSLocalizedString(
            "api.expiredTokenError",
            value: "Access token is expired",
            comment: ""
        )
    }
}

struct APIResponseError: APIError {
    let statusCode: Int?
    let message: String

    var errorDescription: String? {
        message
    }
}
