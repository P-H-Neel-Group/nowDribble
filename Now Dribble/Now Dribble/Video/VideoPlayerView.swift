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
    var shouldPlay: Bool = false

    func setupVideoPlayer(with url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        
        if shouldPlay {
            player.play()
        }
    }
}

class SequentialVideoPlayerViewModel: ObservableObject {
    @Published var player = AVPlayer()
    private var endPlaySubscriber: AnyCancellable?
    var urls: [URL]
    var shouldPlay: Bool = false
    @Published var currentVideo: Int = 0 {
        didSet {
            setupVideoPlayer(with: urls[currentVideo])
        }
    }

    init(urls: [URL]) {
        self.urls = urls
        setupVideoPlayer(with: urls[currentVideo])
        addEndPlayObserver()
    }

    private func addEndPlayObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
    }

    @objc private func videoDidEnd() {
        playNextVideo()
    }

    func setupVideoPlayer(with url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        
        if shouldPlay {
            player.play()
        }
        
        addEndPlayObserver() // add observer for new player item
    }

    func playNextVideo() {
        #if DEBUG
        print("Called function")
        print(urls)
        print(urls.count)
        print(currentVideo)
        #endif
        if currentVideo < urls.count - 1 { // redundant but extra safe :)
            #if DEBUG
            print("Playing next video")
            #endif
            currentVideo += 1
            setupVideoPlayer(with: urls[currentVideo])
        }
    }
}

struct VideoPlayerFullScreenView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = AVPlayer(url: url)
        playerViewController.player?.play()
        playerViewController.modalPresentationStyle = .fullScreen
        return playerViewController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}

    static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: ()) {
        uiViewController.player?.pause()
    }
}

struct VideoPlayerView: View {
    @StateObject private var viewModel = VideoPlayerViewModel()
    let url: URL
    let showCaption: Bool
    let caption: String
    var shouldPlay: Bool?
    var isFullScreen: Bool?

    @State private var isFullScreenPresented: Bool

    init(url: URL, showCaption: Bool, caption: String, shouldPlay: Bool? = nil, isFullScreen: Bool? = nil) {
        self.url = url
        self.showCaption = showCaption
        self.caption = caption
        self.shouldPlay = shouldPlay
        self.isFullScreen = isFullScreen ?? false
        self._isFullScreenPresented = State(initialValue: isFullScreen ?? false)
    }

    private let aspectRatio: CGFloat = 16/9

    var body: some View {
        VStack {
            if isFullScreenPresented {
                VideoPlayerFullScreenView(url: url)
                    .edgesIgnoringSafeArea(.all)
                    .statusBar(hidden: true)
            } else {
                GeometryReader { geometry in
                    ZStack {
                        VideoPlayer(player: viewModel.player)
                            .frame(width: geometry.size.width, height: geometry.size.width / aspectRatio)
                            .cornerRadius(10)
                            .onAppear {
                                viewModel.shouldPlay = shouldPlay ?? false
                                viewModel.setupVideoPlayer(with: url)
                            }
                            .onDisappear {
                                viewModel.player.pause()
                                viewModel.player.replaceCurrentItem(with: nil)
                            }

                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    isFullScreenPresented.toggle()
                                }) {
                                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                                        .font(.system(size: 20))
                                        .padding(8)
                                        .background(Color.black.opacity(0.7))
                                        .clipShape(Circle())
                                        .foregroundColor(.white)
                                        .padding()
                                }
                            }
                        }
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
}

struct SequentialVideoPlayerView: View {
    @StateObject var viewModel: SequentialVideoPlayerViewModel
    private let aspectRatio: CGFloat = 16/9

    init(urls: [URL]) {
        _viewModel = StateObject(wrappedValue: SequentialVideoPlayerViewModel(urls: urls))
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VideoPlayer(player: viewModel.player)
                    .frame(width: geometry.size.width, height: geometry.size.width / aspectRatio)
                    .cornerRadius(10)
                    .onDisappear {
                        viewModel.player.pause()
                        viewModel.player.replaceCurrentItem(with: nil)
                    }
            }
            .frame(height: UIScreen.main.bounds.width / aspectRatio)
            
            if viewModel.urls.count > 1 && viewModel.currentVideo < viewModel.urls.count - 1 {
                Button(action: {
                    viewModel.playNextVideo()
                }) {
                    Text("Next Video")
                        .font(.headline)
                        .padding()
                        .background(Color("TabButtonColor"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}
