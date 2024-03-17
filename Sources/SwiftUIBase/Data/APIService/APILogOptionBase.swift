//
//  APILogOptionBase.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 17/3/24.
//

import Foundation

public struct APILogOptionBase: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let request = Self(rawValue: 1 << 0)
    public static let responseStatus = Self(rawValue: 1 << 2)
    public static let responseJSON = Self(rawValue: 1 << 3)
    public static let responseDecode = Self(rawValue: 1 << 4)
    public static let error = Self(rawValue: 1 << 5)
    public static let cache = Self(rawValue: 1 << 6)

    public static let `default`: [Self] = [
        .request,
        .responseStatus,
        .responseDecode,
        .error,
    ]

    public static let none = [Self]()

    public static let all: [Self] = [
        .request,
        .responseStatus,
        .responseJSON,
        .responseDecode,
        .error,
        .cache,
    ]
}
