//
//  PlayWorkoutView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 3/16/24.
//

import SwiftUI
import AVKit

struct PlayWorkoutView: View {
    var sequences: [WorkoutSequence]
    var videos: [WorkoutVideo]
    @State private var currentSequenceIndex: Int = 0
    @State private var currentVideoIndex: Int = 0
    @State private var timerRemainingSeconds: Int
    @State private var timerIsActive: Bool = false
    
    private var currentVideoURL: URL {
        URL(string: videos[currentVideoIndex].url)!
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(sequences: [WorkoutSequence], videos: [WorkoutVideo]) {
        self.sequences = sequences
        self.videos = videos
        _timerRemainingSeconds = State(initialValue: sequences.first?.time ?? 0)
    }
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 3)
                    .foregroundColor(Color("TabButtonColor"))
                    .frame(width: 200, height: 200)
                    .padding()
                
                VStack {
                    Text("\(timerRemainingSeconds)s")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color("TabButtonColor"))
                        .onReceive(timer) { _ in
                            guard timerIsActive else { return }
                            if timerRemainingSeconds > 0 {
                                timerRemainingSeconds -= 1
                            } else {
                                moveToNextSequence()
                            }
                        }
                        .onAppear {
                            //startTimer()
                        }
                    Text("sec")
                        .font(.title)
                        .foregroundColor(Color("TabButtonColor"))
                }
            }
            Text(sequences[currentSequenceIndex].description)
                .font(.title)
                .padding([.bottom],10)
            
            if (videos.count > 0) {
                let initialUrl = URL(string: videos[0].url)!
                let additionalUrls = videos.dropFirst().compactMap { URL(string: $0.url) }
                VideoPlayerView(url: initialUrl, additionalUrls: additionalUrls, showCaption: false, caption:"", shouldPlay: true)
                    .padding([.horizontal], 10)
            } else {
                Rectangle()
                    .frame(height: UIScreen.main.bounds.width / 16/9) // Draw rectangle of same dimensions
                    .background(bcolor(cc: "primary", backup: "env"))
            }
            
            // Toggle Button for Pause/Resume
            Button(action: {
                self.timerIsActive.toggle()
            }) {
                Image(systemName: timerIsActive ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .symbolRenderingMode(.multicolor)
                    .aspectRatio(contentMode: .fit)
                    .padding(20)
                    .font(.system(size: 75))
                    .foregroundColor(.yellow)
            }
        }
        .onDisappear {
            timerIsActive = false
        }
        .background(bcolor(cc: "primary", backup: "env"))
    }
    
    private func startTimer() {
        timerRemainingSeconds = sequences[currentSequenceIndex].time
        timerIsActive = true
    }
    
    private func moveToNextSequence() {
        if currentSequenceIndex < sequences.count - 1 {
            currentSequenceIndex += 1
            startTimer()
        } else {
            timerIsActive = false
        }
    }
}
