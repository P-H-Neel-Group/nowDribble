//
//  WorkoutView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 1/15/24.
// Displays the workout details -- selected from category contents.

import SwiftUI

struct WorkoutView: View {
    let workoutId: Int
    let fromSavedSheet: Bool

    init(workoutId: Int, fromSavedSheet: Bool? = false) {
        self.workoutId = workoutId
        self.fromSavedSheet = fromSavedSheet ?? false
    }
    
    @StateObject private var fetcher = WorkoutFetcher()
    @StateObject var savedWorkoutsViewModel = SavedWorkoutsViewModel()
    @State var isSaved: Bool = false
    
    var body: some View {
        Group {
            if let workout = fetcher.workoutDetail {
                ScrollView {
                    VStack {
                        HStack {
                            Spacer()
                            Text(workout.name.capitalized)
                                .font(.title)
                                .foregroundColor(Color.white)
                                .bold()
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            if (!fromSavedSheet) {
                                Button(action: {
                                    if (!isSaved) {
                                        savedWorkoutsViewModel.saveWorkout(workoutID: workout.id)
                                    }
                                    else {
                                        savedWorkoutsViewModel.unsaveWorkout(workoutID: workout.id)
                                    }
                                    isSaved.toggle()
                                }) {
                                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                                        .font(.system(size: 25))
                                        .foregroundColor(Color.white)
                                        .padding([.trailing], 2)
                                }
                            }
                        }
                        .onAppear {
                            isSaved = workout.user_saved
                        }
                        ForEach(workout.videos) { video in
                            VideoPlayerView(url: URL(string: video.url)!, showCaption: false, caption: video.title)
                                .padding([.leading, .trailing])
                        }

                        Spacer()
                        Text(workout.description)
                            .font(.body)
                            .padding()
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.white)
                        Spacer()
                        Divider()

                        if (workout.sequences.count > 0) {
                            NavigationLink(destination: PlayWorkoutView(sequences: workout.sequences, videos: workout.videos)) {
                                Image(systemName: "play.circle.fill")
                                    .symbolRenderingMode(.multicolor)
                                    .font(.system(size: 50))
                                    .foregroundColor(.yellow)
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
                                        .background(bcolor(cc: "primary", backup: "env"))
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
                }
            } else {
                ProgressView("Loading workout...")
            }
        }
        .background(bcolor(cc: "primary", backup: "env"))
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
