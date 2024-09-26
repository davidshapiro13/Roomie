//
//  ChoreSettings.swift
//  Roomie
//
//  Created by David Shapiro on 9/22/24.
//

import SwiftUI

struct ChoreSettingsView: View {
    @Environment(\.dismiss) var done
    @AppStorage("roomID") var roomID = ""
    
    @State private var kitchenFrequencies: [String: Int] = [:]
    @State private var bathroomFrequencies: [String: Int] = [:]
    @State private var commonRoomFrequencies: [String: Int] = [:]
    
    var body: some View {
        VStack{
            List() {
                Section("Kitchen") {
                    ListItem(list_name: kitchen_chores, frequencies: $kitchenFrequencies)
                }
                Section("Bathroom") {
                    ListItem(list_name: bathroom_chores,
                        frequencies: $bathroomFrequencies)
                }
                Section("Common Room") {
                    ListItem(list_name: common_room_chores,
                        frequencies: $commonRoomFrequencies)
                }
                
            }
            Button("Done") {
                let freqDict = ["Kitchen": kitchenFrequencies, "Bathroom": bathroomFrequencies, "CommonRoom": commonRoomFrequencies]
                saveFrequencies(ref: databaseRef, roomID: roomID, frequencies: freqDict)
                done()
            }
            
        }
        .onAppear() {
            Task {
                do {
                    kitchenFrequencies = try await getFreq(ref: databaseRef, roomID: roomID, category: "Kitchen")
                    bathroomFrequencies = try await getFreq(ref: databaseRef, roomID: roomID, category: "Bathroom")
                    commonRoomFrequencies = try await getFreq(ref: databaseRef, roomID: roomID, category: "CommonRoom")
                }
                catch let error as NSError {
                    print("Failed with error: \(error), \(error.localizedDescription)")
                }
            }
            
        }
    }
}

struct FreqPicker: View {
    @Binding var selectedFreq: Int;
    var body: some View {
        Picker(selection: $selectedFreq, label: Text("")) {
            Text("Never").tag(1)
            Text("Once a week").tag(2)
            Text("Twice a week").tag(3)
            Text("Once a month").tag(4)
        }
    }
}
struct ListItem: View {
    var list_name: [String];
    @Binding var frequencies: [String: Int]
    var body: some View {
        ForEach(list_name, id: \.self) { chore in
            HStack {
                Text(chore)
                Spacer()
                FreqPicker(selectedFreq: Binding(
                    get: { frequencies[chore] ?? 1 },
                    set: { frequencies[chore] = $0 }
                ))
            }
        }
    }
}

#Preview {
    ChoreSettingsView()
}
