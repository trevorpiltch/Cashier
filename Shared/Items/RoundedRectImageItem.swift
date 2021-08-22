//
//  RoundedRectImageView.swift
//  Plates
//
//  Created by Trevor Piltch on 6/18/21.
//

import SwiftUI

struct RoundedRectImageItem: View {
    var imageName: String
    var color: Color
    var size: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .frame(width: size, height: size)
                .foregroundColor(color)
            
            Image(systemName: imageName)
                .foregroundColor(.white)
                .font(.title2)
        }
    }
}

struct RoundedRectImageView_Previews: PreviewProvider {
    static var previews: some View {
        RoundedRectImageItem(imageName: "person", color: .red, size: 44)
    }
}
