//
//  NumberView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 10/30/23.
//

import SwiftUI

struct NumberView: View {
    let captions = ["Focus on a firm dibble on the outside of each foot.", "Focus on keeping your hand on top of ball, making your dribble strong and quick. Focus on not going past the center mass of your body.", "Focus on making your dribble quick and slightly rocking your body towards the direction of the ball, right to left.", "Same as 3, focus on making your dribble quick and slightly rocking your body towards the direction of the ball, right to left (body wrap).", "Focus on crossing the ball quick and snappy between the center of your wide base without your arms too far outside your waist. The purpose is to speed up your ball control."]
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(1...5, id: \.self) { number in
                    VStack {
                        Spacer()
                        Text("#\(number)")
                            .font(.title)
                            .foregroundColor(Color.accentColor)
                            .padding(.top, 15)
                        
                        VideoPlayerView(url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!, caption: captions[number-1])
                            .frame(height: 200)
                            .padding([.leading, .trailing, .bottom], 15)
                    } // End VStack
                } // End ForEach
            } // End VStack
        } // End ScrollView
    }
}


#Preview {
    NumberView()
}
