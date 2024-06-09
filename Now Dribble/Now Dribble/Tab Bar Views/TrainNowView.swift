//
//  TrainNowView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 10/30/23.
// This file displays the categories which contain workouts.

import SwiftUI

struct TrainNowView: View {
    @StateObject private var viewModel = CategoriesViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.categories) { category in
                        NavigationLink(destination: CategoryContentsView(categoryId: category.id)) {
                            AsyncImage(url: URL(string: category.image_url)) { phase in
                                switch phase {
                                case .empty, .failure:
                                    FailView(category: category)
                                case .success (let image):
                                    SuccessView(category: category, image: image)
                                @unknown default:
                                    FailView(category: category)
                                }
                            }
                        }
                        .padding()
                        .buttonStyle(PlainButtonStyle()) // To ensure the entire row is tappable
                        //.disabled(!category.user_has_access) // Disable the link if user_has_access is false
                    }
                    Spacer().frame(height: 80)
                }
                //.padding()
                .onAppear {
                    viewModel.fetchCategories()
                }
            }
            .background(bcolor(cc: "primary", backup: "env")).edgesIgnoringSafeArea(.vertical)
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                }
            }
            .alert("Error", isPresented: Binding<Bool>.constant(viewModel.errorMessage != nil), presenting: viewModel.errorMessage) { errorMessage in
                Button("OK", role: .cancel) { }
            } message: { errorMessage in
                Text(errorMessage)
            }
        }
        .navigationBarHidden(true)
    }
}

struct SuccessView: View {
    var category: Category
    var image: Image
    
    var body: some View {
        image.resizable()
            .frame(maxWidth: 400, maxHeight: 300)
            .scaledToFill()
            //.aspectRatio(contentMode: .fill)
            .overlay(
                ZStack(alignment: .bottomLeading) { // Align content to the bottom leading corner
                    Rectangle() // This rectangle will serve as the tint layer
                        .foregroundColor(.black)
                        .opacity(0.3)
                    
                    VStack(alignment: .leading) { // Align text to the leading edge
                        Spacer() // Pushes content to the bottom
                        Text(category.name.uppercased())
                            .font(.system(size: 35, weight: .bold, design: .default))
                            .foregroundColor(.white)
                            .padding(.leading, 10) // Add padding to match your design requirements
                        Text("\(category.workout_count) exercises")
                            .font(.system(size: 15, weight: .bold, design: .default))
                            .foregroundColor(.white)
                            .padding([.leading, .bottom], 10) // Align with the title padding
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading) // Ensure VStack fills the ZStack but aligns content to bottomLeading
                }
            )
            .cornerRadius(10)
            .clipped()
            //.grayscale(category.user_has_access ? 0 : 1)
            //.padding()
    }
}

struct FailView: View {
    var category: Category

    var body: some View {
        Rectangle()
            .frame(width: 400, height: 300)
            .cornerRadius(10)
            .background(bcolor(cc: "secondary", backup: "env"))
            .shadow(radius: 2)
            .overlay(
                VStack {
                    Text(category.name.uppercased())
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .padding(5)
                    Text("\(category.workout_count) exercises")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            )
            //.padding()
    }
}
