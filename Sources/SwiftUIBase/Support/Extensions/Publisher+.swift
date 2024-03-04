//
//  Publisher+.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import Combine

public extension Publisher {
    func sink() -> AnyCancellable {
        sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }
}
