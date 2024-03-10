//
//  TrainNowView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 10/30/23.
//

import SwiftUI

struct AnyViewWrapper: View {
    let contentView: AnyView

    init(_ contentView: AnyView) {
        self.contentView = contentView
    }

    var body: some View {
        contentView
    }
}

struct TrainNowView: View {
    // Hide the ugly default navigation bar
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        //appearance.backgroundColor = UIColor.systemBackground
        appearance.shadowColor = nil // Remove the shadow line
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().shadowImage = UIImage() // Empty image for shadow line
        appearance.backgroundColor = UIColor(Color("PrimaryBlueColor"))
    }
    
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
                                    Rectangle()
                                        .frame(width: 400, height: 300)
                                        .cornerRadius(10)
                                        .foregroundColor(Color("SecondaryBlueColor"))
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
                                        .padding()
                                case .success(let image):
                                    image.resizable()
                                        .frame(maxWidth: 400, maxHeight: 300)
                                        .scaledToFill()
                                        .cornerRadius(10)
                                        //.aspectRatio(contentMode: .fill)
                                        .clipped()
                                        .overlay(
                                            ZStack {
                                                Rectangle() // This rectangle will serve as the tint layer
                                                    .foregroundColor(.black)
                                                    .opacity(0.3)
                                                
                                                VStack {
                                                    Text(category.name.uppercased())
                                                        .font(.system(size: 20, weight: .bold, design: .default))
                                                        .foregroundColor(.white)
                                                        .padding(5)
                                                    Text("\(category.workout_count) exercises")
                                                        .font(.caption)
                                                        .foregroundColor(.white)
                                                }
                                            }
                                        )
                                        .padding()
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle()) // To ensure the entire row is tappable
                    }
                }
                .padding()
                .onAppear {
                    viewModel.fetchCategories()
                }
            }
            .background(Color("PrimaryBlueColor"))
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
