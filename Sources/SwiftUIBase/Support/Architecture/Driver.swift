//
//  Driver.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import Combine
import Foundation

public typealias Driver<T> = AnyPublisher<T, Never>

public extension Publisher {
    func asDriver() -> Driver<Output> {
        self.catch { _ in Empty() }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    static func just(_ output: Output) -> Driver<Output> {
        Just(output).eraseToAnyPublisher()
    }

    static func empty() -> Driver<Output> {
        Empty().eraseToAnyPublisher()
    }
}
