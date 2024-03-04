//
//  Observable.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import Combine

public typealias Observable<T> = AnyPublisher<T, Error>

public extension Publisher {
    func asObservable() -> Observable<Output> {
        mapError { $0 }
            .eraseToAnyPublisher()
    }

    static func just(_ output: Output) -> Observable<Output> {
        Just(output)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    static func empty() -> Observable<Output> {
        Empty().eraseToAnyPublisher()
    }
}
