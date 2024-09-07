//
//  RoomieApp.swift
//  Roomie
//
//  Created by David Shapiro on 8/28/24.
//

import SwiftUI
import Firebase
@main
struct RoomieApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
