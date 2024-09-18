//
//  MainView.swift
//  Roomie
//
//  Created by David Shapiro on 9/12/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HomeView().badge(0).tabItem {
                    Label("Hom2e", systemImage: "house") }
            WheelView().badge(0).tabItem {
                    Label("Wheel", systemImage: "clock.arrow.2.circlepath") }
        }
    }
}

#Preview {
    MainView()
}
