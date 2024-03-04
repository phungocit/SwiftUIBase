//
//  LoadingView.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import SwiftUI

public struct LoadingView: View {
    @State private var isShowing = true
    private let style: UIActivityIndicatorView.Style

    public init(
        style: UIActivityIndicatorView.Style = .medium
    ) {
        self.style = style
    }

    public var body: some View {
        ActivityIndicator(isAnimating: $isShowing, activityIndicatorStyle: style)
            .opacity(isShowing ? 1 : 0)
            .onAppear {
                isShowing = true
            }
            .onDisappear {
                isShowing = false
            }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello")
            .overlay {
                LoadingView()
            }
    }
}
