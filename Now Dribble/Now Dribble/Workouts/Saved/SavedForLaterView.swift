//
//  SavedForLaterView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 12/3/23.
//

import SwiftUI

struct SavedWorkouts: Identifiable, Codable {
    let workout_id: Int
    let category_id: Int
    let name: String
    let description: String?
    let image_url: String
    let user_has_access: Bool
    var id: Int { workout_id }
}


struct SavedForLaterView: View {
    @StateObject var viewModel = SavedWorkoutsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.savedWorkouts.isEmpty {
                    Text("No saved workouts")
                        .background(Color("PrimaryBlueColor"))

                } else {
                    List {
                        ForEach(viewModel.savedWorkouts) { workout in
                            NavigationLink(destination: WorkoutView(workoutId: workout.workout_id, fromSaved: true)) {
                                HStack {
                                    Text(workout.name)
                                    Spacer()
                                }
                                .padding()
                            }
                        }
                        .onDelete { indexSet in
                            viewModel.removeWorkouts(atOffsets: indexSet)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.fetchSavedWorkouts()
            }
        }
        .background(Color("PrimaryBlueColor"))
    }
}
