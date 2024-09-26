//
//  ChoreView.swift
//  Roomie
//
//  Created by David Shapiro on 9/26/24.
//

import SwiftUI

struct ChoreView: View {
    @State private var settingsOn = false
    var body: some View {
        VStack {
            Button("Settings") {
                settingsOn = true
            }
        }
        .sheet(isPresented: $settingsOn) {
            ChoreSettingsView()
        }
        
    }
}

#Preview {
    ChoreView()
}
