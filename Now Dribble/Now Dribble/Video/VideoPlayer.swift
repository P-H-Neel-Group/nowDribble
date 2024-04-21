//
//  VideoPlayer.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 11/8/23.
//

import AVKit
import AVFoundation

class ViewController: UIViewController {
    func playVideo(from url: String) {
        guard let videoURL = URL(string: url) else {
            print("Invalid URL")
            return
        }

        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player

        present(playerViewController, animated: true) {
            player.play()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            // Ypause the video or handle other view controller lifecycle events
    }
}
