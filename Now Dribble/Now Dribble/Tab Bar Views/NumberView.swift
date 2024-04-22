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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(Array(zip(captions.indices, captions)), id: \.0) { index, caption in
                    VStack(alignment: .center) {  // Center alignment for each sub VStack
                        Text("#\(index + 1)")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.top, 10)
                        Text(caption)
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                            .multilineTextAlignment(.center)  // Ensures text within is centered if it wraps
                        Button("Watch Video") {
                            selectedVideoURL = urls[index]
                            selectedCaption = captions[index]
                            showVideoSheet = true
                        }
                        .foregroundColor(Color("TabButtonColor"))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        Divider()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                }
            }
            .sheet(isPresented: $showVideoSheet, onDismiss: {
                selectedVideoURL = nil  // reset URL when the sheet is dismissed
            }) {
                if let url = selectedVideoURL
                { if let caption = selectedCaption {
                    StandaloneVideoView(url: url, caption: caption)
                    }
                }
            }
        }
        .background(Color("PrimaryBlueColor"))
    }
}
