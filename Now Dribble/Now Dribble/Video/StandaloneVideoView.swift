//
//  StandaloneVideoView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 4/21/24.
//

import SwiftUI

import SwiftUI
import AVKit

struct StandaloneVideoView: View {
    let url: String
    let caption: String
    @State private var isLoading = true  // State to track loading status

    var body: some View {
        ZStack {
            // The video player view
            VideoPlayerView(url: URL(string: url)!, showCaption: true, caption: caption)

            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)  // Increase the size of the spinny thing
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5))
            }
        }
    }
}
