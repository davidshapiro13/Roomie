//
//  WheelView.swift
//  Roomie
//
//  Created by David Shapiro on 9/12/24.
//

import SwiftUI
import Charts
import Combine

struct WheelView: View {
    @AppStorage("username") var username = ""
    @AppStorage("roomID") var roomID = ""
    @State private var rotationAngle: Double = 0.0
    @State var movie = ""
    @State var movies = [""]
    @State var movieItems: [MovieItem] = []
    @State var winner: String = ""
    
    var body: some View {
        VStack {
            
            Button("Refresh") {
               refresh()
                
            }
            Spacer()
            
            TextField("Your Movie Choice", text: $movie)

            Button("Submit") {
                loadNewMovie(username: username, roomID: roomID, title: movie)
                refresh()
            }
            Spacer()
            
            Button("Spin") {
                let randomRotation =  Double(Int.random(in: 1440...3600))
                
                rotationAngle = rotationAngle + randomRotation
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    winner = getWinner(rotation: rotationAngle, movieItems: movieItems)
                }
            }.accessibilityIdentifier("Spin")
            
            ZStack(alignment: .topTrailing) {
                Chart {
                    ForEach(movieItems, id: \.self) { movieItem in
                        SectorMark(angle: .value(movieItem.title, movieItem.start..<movieItem.end))
                            .foregroundStyle(movieItem.color)
                            .annotation(position: .overlay) {
                                Text(movieItem.title)
                                    .rotationEffect(.degrees(-1 * rotationAngle))
                                    .animation(.easeInOut(duration: 0.5), value: rotationAngle)
                            }
                    }
                    
                }
                .onAppear {
                    refresh()
                }
                .rotationEffect(.degrees(rotationAngle))
                .animation(.easeInOut(duration: 1.5), value: rotationAngle)
                
                HStack {
                    Spacer()
                    Triangle()
                        .foregroundColor(.yellow)
                        .frame(width: 50, height: 190)
                    Spacer()
                }
            }
            Text(winner).accessibilityIdentifier("Result")
        }
        
    }
    
    func randomDegree() -> Double {
        return Double.random(in: 0.0...720.0) + rotationAngle
    }
    
    func refresh() {
        Task {
            do {
                movies = try await getMovies(ref: databaseRef, roomID: roomID)
                movieItems = getMovieItems(movies: movies)
            }
            catch let error as NSError {
                print("Failed with error: \(error), \(error.localizedDescription)")
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        }
    }
}

#Preview {
    WheelView()
}
