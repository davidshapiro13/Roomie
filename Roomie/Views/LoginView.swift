//
//  LoginView.swift
//  Roomie
//
//  Created by David Shapiro on 9/6/24.
//

import SwiftUI

struct LoginView: View {
    @State private var creatingRoom = false
    @State private var joiningRoom = false
    @State private var showCode = false
    @State private var roomID = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Roomie")
                    .font(.title)
                    .fontWeight(.medium)
                Spacer()
                Button("Create Room") {
                    creatingRoom = true
                }.buttonStyle(BorderedButtonStyle())
                Button("Join Room") {
                    joiningRoom = true
                }.buttonStyle(BorderedButtonStyle())
                Spacer()
                Spacer()
            }
            .sheet(isPresented: $creatingRoom) {
                CreatingRoomView(showCode: $showCode, roomID: $roomID)
            }
            .sheet(isPresented: $showCode) {
                DisplayCodeView(roomID: $roomID)
            }
            .sheet(isPresented: $joiningRoom) {
                JoiningRoomView()
            }
        }
    }
}

#Preview {
    LoginView()
}
