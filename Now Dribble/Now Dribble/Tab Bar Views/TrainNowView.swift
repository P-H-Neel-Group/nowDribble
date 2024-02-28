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
                            Text(category.name)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray)
                                .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle()) // To ensure the entire row is tappable
                    }
                }
                .padding()
                .navigationTitle("Categories")
                .onAppear {
                    viewModel.fetchCategories()
                }
            }
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
