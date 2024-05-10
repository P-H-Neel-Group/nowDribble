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
    
    @State private var showVideoSheet = false
    @State private var selectedVideoURL: String?
    @State private var selectedCaption: String?
    @Environment(\.colorScheme) var colorScheme // Access the current color scheme

    var oppositeColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(Array(zip(captions.indices, captions)), id: \.0) { index, caption in
                    Button(action: {
                        selectedVideoURL = urls[index]
                        selectedCaption = captions[index]
                        showVideoSheet = true
                    }) {
                        VStack(alignment: .center) {
                            Text("#\(index + 1)")
                                .font(.title)
                                .foregroundColor(oppositeColor)
                                .padding(.top, 10)
                            Text(caption)
                                .foregroundColor(oppositeColor)
                                .padding(.bottom, 10)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .background(bcolor(cc: "primary", backup: "env"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(oppositeColor, lineWidth: 2)
                                //.shadow(radius: 2)
                        )
                        // The maxWidth: .infinity expands this as much as possible
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)  // full width
                }
                .sheet(isPresented: $showVideoSheet, onDismiss: {
                    // Reset the URL and caption when the sheet is dismissed
                    selectedVideoURL = nil
                    selectedCaption = nil
                }) {
                    if let url = selectedVideoURL, let caption = selectedCaption {
                        StandaloneVideoView(url: url, caption: caption)
                    }
                }
            }
            .background(bcolor(cc: "primary", backup: "env")).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
    }
}

