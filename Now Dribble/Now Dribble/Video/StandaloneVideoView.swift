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

    var body: some View {
        ZStack {
            VideoPlayerView(url: URL(string: url)!, showCaption: true, caption: caption)
        }
    }
}
