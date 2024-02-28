//
//  Category.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 2/27/24.
//

import Foundation


struct CategoryBoxView: View {
    let item: CategoryItem

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: item.imageUrl))
                .aspectRatio(contentMode: .fill)
                .overlay(BlurView(style: .systemMaterialDark))
            
            Text(item.text)
                .foregroundColor(.white)
                .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
    }
}
