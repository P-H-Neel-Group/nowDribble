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
                        NavigationLink(destination: CategoryContentsView(categoryId: category.id, categoryName: category.name)) {
                            AsyncImage(url: URL(string: category.image_url)) { phase in
                                switch phase {
                                case .empty, .failure:
                                    FailView()
                                case .success (let image):
                                    SuccessView(category: category, image: image)
                                @unknown default:
                                    FailView()
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle()) // To ensure the entire row is tappable
                        //.disabled(!category.user_has_access) // Disable the link if user_has_access is false
                    }
                }
                //.padding()
                .onAppear {
                    viewModel.fetchCategories()
                }
            }
            // .background(bcolor(cc: "primary", backup: "env")).edgesIgnoringSafeArea(.vertical)   
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
        image
            .resizable()
            .scaledToFill()
            .clipped()
            .frame(width: 375, height: 250)
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
            //.grayscale(category.user_has_access ? 0 : 1)
            //.padding()
    }
}

struct FailView: View {
    @State private var isAnimating = false // State variable for animation

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color("Skeleton"))
            .frame(width: 375, height: 250)
            .overlay(
                VStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color("SkeletonSecondary"))
                        .frame(width: 150, height: 20)
                        .redacted(reason: .placeholder)
                        .opacity(isAnimating ? 0.6 : 1.0)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color("SkeletonSecondary"))
                        .frame(width: 100, height: 15)
                        .redacted(reason: .placeholder)
                        .opacity(isAnimating ? 0.6 : 1.0)
                }
            )
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
            .opacity(isAnimating ? 0.6 : 1.0)
    }
}
