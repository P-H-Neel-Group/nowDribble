//
//  NumberView.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 10/30/23.
//

import SwiftUI

struct NumberView: View {
    let captions = ["Focus on a firm dibble on the outside of each foot.", "Keep your hand on top of ball to make your dribble strong and quick. Don't go past your center of mass.", "Focus on making your dribble quick and slightly rocking your body towards the direction of the ball, right to left.", "Same as 3, focus on making your dribble quick and slightly rocking your body towards the direction of the ball, right to left (body wrap).", "To speed up ball control, focus on crossing the ball quick and snappy between the center of your wide base without your arms too far outside your waist."]
    
    let urls = ["https://nowdribble-static.s3.amazonaws.com/1intro.mp4", "https://nowdribble-static.s3.amazonaws.com/2intro.mp4", "https://nowdribble-static.s3.amazonaws.com/3intro.mp4",  "https://nowdribble-static.s3.amazonaws.com/4intro.mp4",
        "https://nowdribble-static.s3.amazonaws.com/5intro.mp4"]
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0...4, id: \.self) { i in
                    VStack {
                        Spacer()
                        Text("#\(i+1)")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.top, 15)
                        
                        VideoPlayerView(url: URL(string: urls[i])!, showCaption: true, caption: captions[i])
                            .padding([.leading, .trailing, .bottom], 15)
                    } // End VStack
                } // End ForEach
                Spacer()
            } // End VStack
        } // End ScrollView
        .background(Color("PrimaryBlueColor"))
    }
}

/*
#Preview {
    NumberView()
}*/
