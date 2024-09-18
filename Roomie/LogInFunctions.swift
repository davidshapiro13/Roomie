//
//  LogInFunctions.swift
//  Roomie
//
//  Created by David Shapiro on 8/31/24.
//

import Foundation
import Firebase
import FirebaseDatabase

var databaseRef = Database.database().reference()

/// Adds data with a given path to the Firebase Realtime Database
/// 
/// - Parameter label: Title of newly stored data
/// - Parameter path: directory in which label is stored
/// - Parameter value: value at the label
/// - Parameter id: room id of data
///
/// - Returns: None
func addData(ref: DatabaseReference, label: String, path: [String] = [], value: Any, id: String) {
    var ref = ref.child("rooms").child(id)
    let newField = [label : value] as [String: Any]
    
    for directory in path {
        ref = ref.child(directory)
    }

    ref.updateChildValues(newField) { (error, ref) in
        if let error = error {
            print("An error occurred: \(error.localizedDescription)")
        }
    }
}


/// Creates a brand new room
/// - Returns: The unique room ID
func createRoom(ref: DatabaseReference) -> String {
    let newRoom = ref.child("rooms").childByAutoId()

    return newRoom.key ?? "ERROR"
}

/// Saves an association between join code and room ID
/// - Parameters:
///   - code: join code generated for room
///   - roomID: unique ID of room
func linkCodeToID(ref: DatabaseReference, code: String, roomID: String) {
    let codeToID = [code : roomID] as [String: Any]
    
    ref.child("code-to-roomID").updateChildValues(codeToID) { (error, ref) in
        if let error = error {
            print("An error occurred: \(error.localizedDescription)")
        }
    }
}

/// Generates a code to be used to join new room
/// - Parameter length: length of code
/// - Returns: generated code
func genCode(length: Int = 5) -> String {
    let chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var code = ""
    for _ in 1...length {
        code.append(chars.randomElement() ?? "A")
    }
    return code
}

func uniqueGenCode() async throws -> String {
    var unique = false
    var code: String = "ERROR"
    while !unique {
        code = genCode()
        if try await !roomExists(ref: databaseRef, code: code) {
            unique = true
        }
    }
    return code
}
/// Asyncronous function that will find room ID associated with join code
/// - Parameter code: join code of room
/// - Throws: Error if snapshot doesn't exist
/// - Returns: Unique roomID
func getRoomID(ref: DatabaseReference, code: String) async throws -> String {
    var roomID = "error"
    
    return try await withCheckedThrowingContinuation { continuation in
        ref.child("code-to-roomID").observe(.value, with: { snapshot in
            if snapshot.exists(), let value = snapshot.value as? [String: String] {
                roomID = value[code]!
                continuation.resume(returning: roomID)
            }
            else {
                continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve room ID."]))
            }
        })
    }
}

/// Adds necessary info to create new member
/// - Parameters:
///   - username: username of member
///   - roomID: roomID of room member is part of
func makeNewMember(username: String, roomID: String) {
    addData(ref: Database.database().reference(), label: username, path: ["members"], value: "FILL IN LATER", id: roomID)
    UserDefaults.standard.set(username, forKey: "username")
    UserDefaults.standard.set(roomID, forKey: "roomID")
}


/// Sets user status as logged in
func login() {
    UserDefaults.standard.set(true, forKey: "isLoggedIn")
}

/// Sets user status as logged out
func logout() {
    UserDefaults.standard.set(false, forKey: "isLoggedIn")
}

/// Checks if room code exists
/// - Parameter code: join code of room
/// - Throws: error if problem retrieving from database
/// - Returns: true if room code exists; false otherwise
func roomExists(ref: DatabaseReference, code: String) async throws -> Bool {
    let path = "code-to-roomID/" + code
    
    return try await withCheckedThrowingContinuation { continuation in
        ref.child(path).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                continuation.resume(returning: true)
            }
            else {
                continuation.resume(returning: false)
            }
            
        })
    }
}
