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
            HomeView().tabItem {
                    Label("Home", systemImage: "house") }
            .accessibilityLabel("homeTab")
            ChoreView().tabItem {
                Label("Chores", systemImage: "shower")
            }
            .accessibilityLabel("goalTab")
            GoalView().tabItem {
                Label("Goals", systemImage: "checklist")
            }
            .accessibilityLabel("goalTab")
            WheelView().tabItem {
                    Label("Wheel", systemImage: "clock.arrow.2.circlepath") }
            .accessibilityLabel("wheelTab")
        }
    }
}

#Preview {
    MainView()
}
