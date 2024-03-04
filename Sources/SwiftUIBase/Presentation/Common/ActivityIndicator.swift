//
//  ActivityIndicator.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import SwiftUI
import UIKit

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let activityIndicatorStyle: UIActivityIndicatorView.Style

    func makeUIView(
        context: UIViewRepresentableContext<ActivityIndicator>
    ) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: activityIndicatorStyle)
    }

    func updateUIView(
        _ uiView: UIActivityIndicatorView,
        context: UIViewRepresentableContext<ActivityIndicator>
    ) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
