//
//  ExampleApp.swift
//  SwiftUIBase_Example
//
//  Created by Foo Tran on 01/03/2024.
//

import SwiftUI

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
            .navigationViewStyle(.stack)
        }
    }
}
