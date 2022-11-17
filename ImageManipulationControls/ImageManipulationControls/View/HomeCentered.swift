//
//  HomeCentered.swift
//  ImageManipulationControls
//
//  Created by javi www on 11/16/22.
//

import SwiftUI

struct HomeCentered: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        VStack(spacing: 0) {
            //MARK: Top Buttons
            HStack(spacing: 32) {
                TopButton(title: "HD", iconName: nil) {
                    print("HD Action")
                }
                
                Spacer()
                
                TopButton(title: "4K", iconName: nil) {
                    print("4K Action")
                }
                
                TopButton(title: nil, iconName: "bolt.slash") {
                    print("Flash Action")
                }
                .padding(.trailing, 4)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.top, 0)
            .padding(.bottom, 8)
            
            //MARK: ScrollImage
            GeometryReader {
                let size = $0.size
                ZStack {
                    Image("portrait-image")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .contentShape(Rectangle())
                }
                .frame(width: size.width, height: size.height)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .frame(height: UIScreen.main.bounds.height * 0.6, alignment: .top)
            .overlay {
                OverlayGrid()
            }
            
            //MARK: Check for horizontal to know if it's an iPad
            let paddingVerticalSlider:CGFloat = horizontalSizeClass == .regular ? 44 : 16
            let paddingVerticalToolSelector:CGFloat = horizontalSizeClass == .regular ? 44 : 8

            VStack {
                AspectSelector()
                
                HorizontalSliderSelector()
                    .padding(.top, paddingVerticalSlider)
                
                //MARK: Tool selector
                ToolHorizontalSelector()
                    .padding(.top, paddingVerticalToolSelector)
            }
            .frame(maxHeight: .infinity)

        }
    }
}

struct HomeCentered_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
