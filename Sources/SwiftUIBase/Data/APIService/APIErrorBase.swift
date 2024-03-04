//
//  APIErrorBase.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import Foundation

public protocol APIError: LocalizedError {
    var statusCode: Int? { get }
}

public extension APIError {
    var statusCode: Int? {
        nil
    }
}

public struct APIResponseDecodeError: APIError {
    let error: Error

    public init(_ error: Error) {
        self.error = error
    }

    public var errorDescription: String? {
        NSLocalizedString(
            "api.responseDecodeError",
            value: "\(error)",
            comment: "Response decode error"
        )
    }
}

public struct APIUnknownError: APIError {
    public let statusCode: Int?

    public init(statusCode: Int?) {
        self.statusCode = statusCode
    }

    public var errorDescription: String? {
        NSLocalizedString(
            "api.unknownError",
            value: "\(String(describing: statusCode))",
            comment: "Unknown API error"
        )
    }
}
