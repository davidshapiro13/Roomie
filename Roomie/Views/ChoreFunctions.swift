//
//  ChoreFunction.swift
//  Roomie
//
//  Created by David Shapiro on 9/22/24.
//

import Foundation
import FirebaseDatabase

let KITCHEN = "Kitchen"
let BATHROOM = "Bathroom"
let COMMONROOM = "CommonRoom"
let NEVER = 1
let CHORES = "chores"

let kitchen_chores = ["Clean Counters", "Clean Stove", "Clean Fridge", "Empty Garbage", "Mop"]
let bathroom_chores = ["Shower", "Toilet", "Sink"]
let common_room_chores = ["Vaccum", "Wipe Down Furniture", "Tidy"]

func saveFrequencies(ref: DatabaseReference, roomID: String, frequencies: [String: [String: Int]]) {
    for (section, chores) in frequencies {
        for (name, freq) in chores {
            addData(ref: ref, label: name, path: [CHORES, section], value: freq, id: roomID)
        }
    }
}

func getFreq(ref: DatabaseReference, roomID: String, category: String) async throws -> [String: Int] {
    return try await withCheckedThrowingContinuation { continuation in
        ref.child("rooms").child(roomID).child("chores").child(category).getData { error, snapshot in
            if let error = error {
                continuation.resume(throwing: error)
                return
            }
            
            if let snapshot = snapshot, snapshot.exists(), let choreToFreq = snapshot.value as? [String: Int] {
                continuation.resume(returning: choreToFreq)
            }
            else {
                continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve room ID."]))
            }
        }
    }
}
