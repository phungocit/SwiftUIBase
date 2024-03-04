//
//  ErrorTracker.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import Combine

public typealias ErrorTracker = PassthroughSubject<Error, Never>

public extension Publisher where Failure: Error {
    func trackError(_ errorTracker: ErrorTracker) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveCompletion: { completion in
            if case let .failure(error) = completion {
                errorTracker.send(error)
            }
        })
        .eraseToAnyPublisher()
    }
}
