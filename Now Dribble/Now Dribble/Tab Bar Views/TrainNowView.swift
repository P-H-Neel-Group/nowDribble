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
    }
    
    @StateObject private var viewModel = CategoriesViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.categories) { category in
                        NavigationLink(destination: CategoryContentsView(categoryId: category.id)) {
                            AsyncImage(url: URL(string: category.image_url)) { image in
                                image.resizable()
                                    .scaledToFill()
                                    .cornerRadius(5)
                            } placeholder: {
                                ProgressView()
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 330, maxHeight: 180)
                            .blur(radius: 2)
                            .clipped()
                            .overlay(
                                Rectangle()
                                    .stroke(Color.white, lineWidth: 8)
                                    .cornerRadius(5)
                                    .overlay(
                                        Text(category.name.uppercased())
                                            .font(.system(size: 20, weight: .bold, design: .default))
                                            .foregroundColor(.white)
                                            .padding(5)
                                            .cornerRadius(5)
                                )
                            )
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
    }
}
