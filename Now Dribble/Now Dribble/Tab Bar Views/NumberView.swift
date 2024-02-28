//
//  NumberView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 10/30/23.
//

import SwiftUI

struct NumberView: View {
    let captions = ["Focus on a firm dibble on the outside of each foot.", "Focus on keeping your hand on top of ball, making your dribble strong and quick. Focus on not going past the center mass of your body.", "Focus on making your dribble quick and slightly rocking your body towards the direction of the ball, right to left.", "Same as 3, focus on making your dribble quick and slightly rocking your body towards the direction of the ball, right to left (body wrap).", "Focus on crossing the ball quick and snappy between the center of your wide base without your arms too far outside your waist. The purpose is to speed up your ball control."]
    
    let urls = ["https://nowdribble-static.s3.amazonaws.com/1intro.mp4", "https://nowdribble-static.s3.amazonaws.com/2intro.mp4", "https://nowdribble-static.s3.amazonaws.com/3intro.mp4",  "https://nowdribble-static.s3.amazonaws.com/4intro.mp4"]
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0...3, id: \.self) { i in
                    VStack {
                        Spacer()
                        Text("#\(i)")
                            .font(.title)
                            .foregroundColor(Color.accentColor)
                            .padding(.top, 15)
                        
                        VideoPlayerView(url: URL(string: urls[i])!, caption: captions[i])
                            .frame(height: 200)
                            .padding([.leading, .trailing, .bottom], 15)
                    } // End VStack
                } // End ForEach
            } // End VStack
        } // End ScrollView
    }
}

/*
#Preview {
    NumberView()
}*/
