//
//  ContentView.swift
//  Roomie
//
//  Created by David Shapiro on 8/28/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    var body: some View {
        if isLoggedIn {
            MainView()
        }
        else {
            LoginView()
        }
        
    }
}


#Preview {
    ContentView()
}
