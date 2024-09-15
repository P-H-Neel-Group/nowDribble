//
//  NumberView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 10/30/23.
//

import SwiftUI

struct NumberView: View {
    let captions = [
        "Focus on a firm dribble on the outside of each foot.",
        "Keep your hand on top of ball to make your dribble strong and quick. Don't go past your center of mass.",
        "Focus on making your dribble quick and slightly rocking your body towards the direction of the ball, right to left.",
        "Same as 3, focus on making your dribble quick and slightly rocking your body towards the direction of the ball, right to left (body wrap).",
        "To speed up ball control, focus on crossing the ball quick and snappy between the center of your wide base without your arms too far outside your waist."
    ]
    
    let urls = [
        "https://now-dribble.s3.us-east-2.amazonaws.com/static/1intro.mp4",
        "https://now-dribble.s3.us-east-2.amazonaws.com/static/2intro.mp4",
        "https://now-dribble.s3.us-east-2.amazonaws.com/static/3intro.mp4",
        "https://now-dribble.s3.us-east-2.amazonaws.com/static/4intro.mp4",
        "https://now-dribble.s3.us-east-2.amazonaws.com/static/5intro.mp4"
    ]
    
    @Environment(\.colorScheme) var colorScheme
    @State private var showVideoSheet = false
    @State private var selectedVideoURL: URL?
    @State private var selectedCaption: String?

    var oppositeColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(Array(zip(captions.indices, captions)), id: \.0) { index, caption in
                        Button(action: {
                            selectedVideoURL = URL(string: urls[index])
                            selectedCaption = captions[index]
                            showVideoSheet = true
                        }) {
                            VStack(alignment: .leading) {
                                Text("#\(index + 1)")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(oppositeColor)
                                
                                Text(caption)
                                    .foregroundColor(oppositeColor)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(16) // Padding inside the card
                            .frame(maxWidth: .infinity, alignment: .leading) // Ensure text fills the width
                            .background(Color("Secondary")) // Card background
                            .cornerRadius(12) // Rounded corners for the card
                        }
                        .padding(.horizontal) // Padding between cards and screen edges
                    }
                    Spacer().frame(height: 80) // Spacer to add space at the bottom
                }
            }
            .background(bcolor(cc: "primary", backup: "env")).edgesIgnoringSafeArea(.vertical)
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $showVideoSheet, onDismiss: { selectedVideoURL = nil; selectedCaption = nil}) {
                if let url = selectedVideoURL, let caption = selectedCaption {
                    VideoPlayerView(
                        url: url,
                        showCaption: true,
                        caption: caption,
                        isFullScreen: true
                    )
                }
            }
        }
    }
}
