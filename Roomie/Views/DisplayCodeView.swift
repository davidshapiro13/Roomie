//
//  DisplayCodeView.swift
//  Roomie
//
//  Created by David Shapiro on 9/4/24.
//

import SwiftUI
import FirebaseDatabase

struct DisplayCodeView: View {
    @Binding var roomID: String
    @Environment(\.dismiss) var done
    
    @State var code: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Join Code")
                Text(code).onAppear {
                    Task {
                        do {
                            code = try await uniqueGenCode()
                            linkCodeToID(ref: databaseRef, code: code, roomID: roomID)
                            addData(ref: databaseRef, label: "join_code", value: code, id: roomID)
                        }
                        catch {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
                Button("Done") {
                    done()
                    login()
                }
            }
        }
    }
}

/**
#Preview {
    DisplayCodeView()
}
*/
