//
//  GoalFunctions.swift
//  Roomie
//
//  Created by David Shapiro on 9/20/24.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftUI

func saveGoal(username: String, roomID: String, goal: String, completed: Bool=false) {
    addData(ref: databaseRef, label: goal, path: ["goals"], value: completed, id: roomID)
}

func getGoals(ref: DatabaseReference, roomID: String) async throws -> [GoalItem] {
    var goalItems: [GoalItem] = []
    
    return try await withCheckedThrowingContinuation { continuation in
        ref.child("rooms").child(roomID).child("goals").getData { error, snapshot in
            if let error = error {
                continuation.resume(throwing: error)
                return
            }
            
            if let snapshot = snapshot, snapshot.exists(), let personToGoal = snapshot.value as? [String: Bool] {
                for keyVal in personToGoal {
                    let completedBool = keyVal.value
                    let item = GoalItem(name: keyVal.key, completed: completedBool)
                    goalItems.append(item)
                }
                continuation.resume(returning: goalItems)
            }
            else {
                continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve room ID."]))
            }
        }
    }
}

func deleteGoal(ref: DatabaseReference, roomID: String, goal: String) {
    ref.child("rooms").child(roomID).child("goals").child(goal).removeValue { error, _ in
        if let error = error {
            print("Error deleting item: \(error.localizedDescription)")
        }
    }
}

func updateGoalCompletion(username: String, roomID: String, goalText: String, completed: Bool) {
    saveGoal(username: username, roomID: roomID, goal: goalText, completed: completed)
}

struct GoalItem: Identifiable, Hashable {
    let id = UUID()
    
    var name: String
    var completed: Bool
    
    init(name: String, completed: Bool) {
        self.name = name
        self.completed = completed
    }
}
