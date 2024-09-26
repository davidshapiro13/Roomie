//
//  GoalView.swift
//  Roomie
//
//  Created by David Shapiro on 9/20/24.
//

import SwiftUI

struct GoalView: View {
    @AppStorage("username") var username = ""
    @AppStorage("roomID") var roomID = ""
    @State var goalText = ""
    @State var goals: [GoalItem] = []
    var body: some View {
        VStack {
            TextField("Goal", text: $goalText).border(Color.gray).padding(50)
                .accessibilityLabel("GoalField")
            Button("Submit") {
                saveGoal(username: username, roomID: roomID, goal: goalText)
                refresh()
            }
            List(goals, id: \.self) { goal in
                ListItemView(goal: goal).swipeActions {
                    Button(role: .destructive) {
                        if let itemIndex = goals.firstIndex(of: goal) {
                            goals.remove(at: itemIndex)
                        }
                        deleteGoal(ref: databaseRef, roomID: roomID, goal: goal.name)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .onAppear {
                refresh()
            }
        }
    }
    
    func refresh() {
        goalText = ""
        Task {
            do {
                goals = try await getGoals(ref: databaseRef, roomID: roomID)
            }
            catch let error as NSError {
                print("Failed with error: \(error), \(error.localizedDescription)")
            }
        }
    }
}

struct ListItemView: View {
    @AppStorage("username") var username = ""
    @AppStorage("roomID") var roomID = ""
    @State var isChecked = false
    var goal: GoalItem
    var body: some View {
        HStack {
            Toggle(isOn: $isChecked) {
                Text(goal.name)
                   }
            .toggleStyle(CheckboxStyle())
            .onChange(of: isChecked){ oldVal, newVal in
                updateGoalCompletion(username: username, roomID: roomID, goalText: goal.name, completed: newVal)
            }
            .padding()
        }
        .onAppear {
            isChecked = goal.completed
        }
    }
}

// chatGPT
struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 20, height: 20)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
}

#Preview {
    GoalView()
}
