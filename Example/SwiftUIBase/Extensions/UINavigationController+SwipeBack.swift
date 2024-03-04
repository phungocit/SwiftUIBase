//
//  UINavigationController+SwipeBack.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import UIKit

// Swipe be registered on the entire screen, like Instagram can swipe back from anywhere.
// Similar solution: https://stackoverflow.com/a/60598558
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        registeringSwipeBackEntireScreen()
    }

    private func registeringSwipeBackEntireScreen() {
        // The trick here is to wire up our full-width `swipeBackEntireScreenGestureRecognizer` to
        // execute the same handler as the system `interactivePopGestureRecognizer`.
        // That's done by assigning the same "targets" (effectively object and selector)
        // of the system one to our gesture recognizer.
        let targetsKey = "targets"
        guard let interactivePopGestureRecognizer = interactivePopGestureRecognizer,
              let targetsValue = interactivePopGestureRecognizer.value(forKey: targetsKey)
        else {
            return
        }

        let swipeBackEntireScreenGestureRecognizer = UIPanGestureRecognizer()

        swipeBackEntireScreenGestureRecognizer.setValue(targetsValue, forKey: targetsKey)
        swipeBackEntireScreenGestureRecognizer.delegate = self
        view.addGestureRecognizer(swipeBackEntireScreenGestureRecognizer)
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }

        let isTriggerSwipeBack =
            viewControllers.count > 1 /// There must be at least 2 screens left in the stack
            && panGestureRecognizer.translation(in: view).x > 0 /// Must swipe from left to right

        return isTriggerSwipeBack
    }
}
