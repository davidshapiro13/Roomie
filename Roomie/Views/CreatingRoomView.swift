//
//  CreatingRoomView.swift
//  Roomie
//
//  Created by David Shapiro on 9/4/24.
//

import SwiftUI

struct CreatingRoomView: View {
    @Binding var showCode: Bool
    @Binding var roomID: String

    @Environment(\.dismiss) var submit
    @State private var roomname = ""
    @State private var username = ""
    var body: some View {
        NavigationView {
            VStack {
                Text("Room Name")
                HStack {
                    TextField("Name", text: $roomname).border(Color.gray).padding(50)
                }
                Text("Your Name")
                HStack {
                    TextField("Name", text: $username).border(Color.gray).padding(50)
                }
                Button("Submit") {
                    showCode = true
                    roomID = createRoom()
                    addData(label: "room-name", value: roomname, id: roomID)
                    makeNewMember(username: username, roomID: roomID)
                    submit()
                }
            }
        }
    }
}

/**
 #Preview {
     CreatingRoomView()
 }
 */
 
 
