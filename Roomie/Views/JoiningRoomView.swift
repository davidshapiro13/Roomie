//
//  fix.swift
//  Roomie
//
//  Created by David Shapiro on 9/4/24.
//

import SwiftUI

struct JoiningRoomView: View {
    @State private var roomID: String = ""
    @State private var code: String = ""
    @State private var username: String = ""
    @State private var errorText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text(errorText)
                Text("Room Code")
                TextField("Code", text: $code).border(Color.gray).padding(50)
                Text("Your Name")
                HStack {
                    TextField("Name", text: $username).border(Color.gray).padding(50)
                }
                Button("Submit") {
                    Task {
                        do {
                            if try await roomExists(ref: databaseRef, code: code) {
                                roomID = try await getRoomID(ref: databaseRef, code: code)
                                makeNewMember(username: username, roomID: roomID)
                                login()
                            }
                            else {
                                errorText = "Room Does Not Exist"
                            }
                        }
                        catch {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}

/**
 #Preview {
 JoiningRoomView()
 }
 */
