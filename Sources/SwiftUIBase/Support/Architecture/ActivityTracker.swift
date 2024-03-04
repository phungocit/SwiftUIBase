//
//  ActivityTracker.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import Combine
import UIKit

public typealias ActivityTracker = CurrentValueSubject<Bool, Never>

public extension Publisher where Failure: Error {
    func trackActivity(_ activityTracker: ActivityTracker) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveSubscription: { _ in
            activityTracker.send(true)
        }, receiveCompletion: { _ in
            activityTracker.send(false)
        })
        .eraseToAnyPublisher()
    }
}
