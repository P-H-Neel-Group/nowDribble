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
    let showCaption: Bool
    let caption: String
    private let aspectRatio: CGFloat = 16/9

    var body: some View {
        VStack {
            GeometryReader { geometry in
                 VideoPlayer(player: AVPlayer(url: url))
                     .frame(width: geometry.size.width, height: geometry.size.width / aspectRatio)
                     .cornerRadius(10)
             }
             .frame(height: UIScreen.main.bounds.width / aspectRatio) // Set height based on the aspect ratio

            if (showCaption) {
                Text(caption)
                    .font(.caption)
                    .bold()
                    .foregroundColor(.white)
                    .padding([.horizontal, .bottom])
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true) // Allows the text to grow vertically.
            }
        }
    }
}
