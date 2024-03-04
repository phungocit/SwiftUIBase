//
//  View+.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import SwiftUI

public extension View {
    func loadingView(
        isShowing: Binding<Bool>,
        style: UIActivityIndicatorView.Style = .medium
    ) -> some View {
        overlay {
            if isShowing.wrappedValue {
                LoadingView(style: style)
            }
        }
    }
}
