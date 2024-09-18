//
//  wheelfunctions.swift
//  Roomie
//
//  Created by David Shapiro on 9/12/24.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftUI

func loadNewMovie(username: String, roomID: String, title: String) {
    print(username)
    print(roomID)
    print(title)
    addData(ref: databaseRef, label: username, path: ["movies"], value: title, id: roomID)
}

func getMovies(ref: DatabaseReference, roomID: String) async throws -> [String] {
    print("ROOM ID " + roomID)
    return try await withCheckedThrowingContinuation { continuation in
        ref.child("rooms").child(roomID).child("movies").getData { error, snapshot in
            if let error = error {
                continuation.resume(throwing: error)
                return
            }
            
            if let snapshot = snapshot, snapshot.exists(), let personToMovie = snapshot.value as? [String: String] {
                continuation.resume(returning: Array(personToMovie.values))
            }
            else {
                continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve room ID."]))
            }
        }
    }
}

func getMovieItems(movies: [String]) -> [MovieItem]{
    var movieItems: [MovieItem] = []
    let total = movies.count
    for movie in movies {
        let index = movies.firstIndex(of: movie) ?? -1
        let movieItem = MovieItem(movie: movie, index: index, total: total)
        movieItems.append(movieItem)
    }
    return movieItems
}

struct MovieItem: Identifiable, Hashable {
    let id = UUID()
    
    var title: String
    var color: Color
    var start: Double
    var end: Double
    
    init(movie: String, index: Int, total: Int) {
        title = movie
        color = Color.random
        let position = Double(index + 1)
        start = (position - 1.0) / Double(total)
        end = position / Double(total)
    }
    
}

extension Color {
    static var random: Color {
        Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}

func getWinner(rotation: Double, movieItems: [MovieItem]) -> String {
    let slice = 360.0 / Double(movieItems.count)
    let actualRotation = rotation.truncatingRemainder(dividingBy: 360.0)
    
    for i in 1...movieItems.count {
        var lower = 0.0
        if i != 1 {
            lower = slice * (Double(i) - 1.0)
        }
        
        let lowerBound = actualRotation >= lower
        let upperBound = actualRotation < slice * Double(i)
        
        if  upperBound && lowerBound {
            return movieItems[i-1].title
        }
    }
    
    return "ERROR"
    
}
