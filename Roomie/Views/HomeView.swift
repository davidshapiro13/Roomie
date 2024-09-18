//
//  HomeView.swift
//  Roomie
//
//  Created by David Shapiro on 9/6/24.
//

import SwiftUI
import Charts


struct HomeView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false

    var body: some View {
        VStack {
            Text("Home")
            Button("Log Out") {
                logout()
            }
        }
    }
}

#Preview {
    HomeView()
}
