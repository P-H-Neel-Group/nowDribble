//
//  VideoPlayerView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 11/8/23.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let url: URL
    let caption: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VideoPlayer(player: AVPlayer(url: url))
                .frame(height: 200)
                .cornerRadius(10)
                .overlay(
                    Text(caption)
                        .font(.caption)
                        .bold()
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.gray.opacity(0.7))
                        .cornerRadius(5)
                        .padding(5), // Add padding inside the ZStack to respect corner radius
                    alignment: .bottom
                )
        }
    }
}
