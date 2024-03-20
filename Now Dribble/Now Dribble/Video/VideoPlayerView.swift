//
//  VideoPlayerView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 11/8/23.
//

import SwiftUI
import AVKit
import Combine

class VideoPlayerViewModel: ObservableObject {
    var player = AVPlayer()
    private var endPlaySubscriber: AnyCancellable?
    var additionalUrls: [URL]? = nil
    @Published var currentVideoIndex = 1
    var shouldPlay: Bool = false // Default value is false

    func setupVideoPlayer(with url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        
        if shouldPlay{
            player.play()
        }
        
        endPlaySubscriber = NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: playerItem)
            .sink(receiveValue: { [weak self] _ in
                self?.videoDidEnd()
            })
    }

    private func videoDidEnd() {
        guard let urls = additionalUrls, currentVideoIndex < urls.count else {
            return
        }
        
        currentVideoIndex += 1
        if urls.count > currentVideoIndex-1 {
            let nextUrl = urls[currentVideoIndex - 1]
            setupVideoPlayer(with: nextUrl)
        }
    }
}

struct VideoPlayerView: View {
    @StateObject private var viewModel = VideoPlayerViewModel()
    let url: URL
    var additionalUrls: [URL]? = nil
    let showCaption: Bool
    let caption: String
    var shouldPlay: Bool?

    private let aspectRatio: CGFloat = 16/9

    var body: some View {
        VStack {
            GeometryReader { geometry in
                VideoPlayer(player: viewModel.player)
                    .frame(width: geometry.size.width, height: geometry.size.width / aspectRatio)
                    .cornerRadius(10)
                    .onAppear {
                        viewModel.additionalUrls = additionalUrls
                        viewModel.shouldPlay = shouldPlay ?? false // Use the shouldPlay value
                        viewModel.setupVideoPlayer(with: url)
                    }
            }
            .frame(height: UIScreen.main.bounds.width / aspectRatio)

            if showCaption {
                Text(caption)
                    .font(.caption)
                    .bold()
                    .foregroundColor(.white)
                    .padding([.horizontal, .bottom])
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
