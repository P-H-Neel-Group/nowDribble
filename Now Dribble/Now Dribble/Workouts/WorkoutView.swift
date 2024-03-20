//
//  WorkoutView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 1/15/24.
// Displays the workout details -- selected from category contents.

import SwiftUI

struct WorkoutView: View {
    let workoutId: Int
    @StateObject private var fetcher = WorkoutFetcher()
    
    var body: some View {
        Group {
            if let workout = fetcher.workoutDetail {
                ScrollView {
                    VStack {
                        Text(workout.name.capitalized)
                            .font(.title)
                            .foregroundColor(Color.white)
                            .bold()
                            .multilineTextAlignment(.leading)
                        
//                        Divider()
//                        
//                        Text(workout.description)
//                            .font(.body)
//                            .padding()
//                            .multilineTextAlignment(.center)
//                            .foregroundColor(Color.white)
                        
                        ForEach(workout.videos) { video in
                            VideoPlayerView(url: URL(string: video.url)!, showCaption: false, caption: video.title)
                                .padding([.leading, .trailing])
                        }
                        Spacer()
                        
                        if (workout.sequences.count > 0) {
                            NavigationLink(destination: PlayWorkoutView(sequences: workout.sequences, videos: workout.videos)) {
                                Image(systemName: "play.circle.fill")
                                    .symbolRenderingMode(.multicolor)
                                    .font(.system(size: 50))
                                    .foregroundColor(.yellow)
                            }
                        }

                        
                        Text("Sequence")
                            .font(.title)
                            .padding()
                        
                        ForEach(workout.sequences.indices, id: \.self) { index in
                            HStack {
                                // Circled number for the step
                                Text("\(index + 1)")
                                    .bold()
                                    .padding(8)
                                    .background(Circle().fill(Color.white))
                                    .foregroundColor(Color("PrimaryBlueColor"))
                                    .font(.caption)
                                    .padding(.leading) // Add padding to ensure it does not stick to the edge
                                
                                // Sequence description
                                Text(workout.sequences[index].description)
                                    .foregroundColor(Color.white)
                                    .alignmentGuide(.leading) { d in d[.leading] }
                                
                                Spacer()
                                
                                // Clock icon and time
                                Image(systemName: "clock.fill")
                                    .foregroundColor(Color.white)
                                Text("\(workout.sequences[index].time)s")
                                    .foregroundColor(Color.white)
                                    .font(.caption)
                                    .padding(.trailing) // Add padding to ensure it does not stick to the edge
                            }
                            .padding([.top, .bottom], 5)
                        }
                    }
                }
            } else {
                ProgressView("Loading workout...")
                    .background(Color("PrimaryBlueColor"))
            }
        }
        .background(Color("PrimaryBlueColor"))
        .onAppear {
            fetcher.fetchWorkout(byId: workoutId)
        }
        .alert("Error", isPresented: Binding<Bool>.constant(fetcher.errorMessage != nil), presenting: fetcher.errorMessage) { errorMessage in
            Button("OK", role: .cancel) { }
        } message: { errorMessage in
            Text(errorMessage)
        }
    }
}
