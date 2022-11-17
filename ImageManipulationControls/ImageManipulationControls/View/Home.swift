//
//  Home.swift
//  ImageManipulationControls
//
//  Created by javi www on 11/16/22.
//

import SwiftUI

struct Home: View {
    
    @State var contentModelIdxSelected = 0
    
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
            .padding(.top, 64)
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
            .frame(height: 440, alignment: .top)
            .overlay {
                OverlayGrid()
            }
            

            VStack {
                AspectSelector()
                
                HorizontalSliderSelector()
                    .padding(.top, 16)
                
                //MARK: Tool selector
                ToolHorizontalSelector()
                    .padding(.top, 8)
            }
            .frame(maxHeight: .infinity)
           
            
            //MARK: Content Selector
            let buttonTitles = ["VIDEO", "SHOOT", "PORTRAIT"]
            HStack(spacing: 0) {
                ForEach(buttonTitles.indices, id: \.self) { titleIdx in
                    let title = buttonTitles[titleIdx]
                    let selContent = contentModelIdxSelected == titleIdx
                    Button {
                        contentModelIdxSelected = titleIdx
                    } label: {
                        Text(title)
                            .font(.callout)
                            .fontWeight(selContent ? .bold : .regular)
                            .foregroundColor(selContent ? Color("Orange") : .white.opacity(0.4))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 26)
            .padding(.bottom, 16)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(content: {
            Image("image-manipulation-base")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .scaleEffect(1.01)
                .ignoresSafeArea()
                .allowsHitTesting(false)
                .hidden()
        })
        //MARK: Vertical line ruler
    }
    
}

struct OverlayGrid: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            let nLines = 3
            let widthDivided = size.width / CGFloat(nLines)
            let heightDivided = size.height / CGFloat(nLines)
            Path { path in
                //MARK: X Lines
                for i in 1..<nLines {
                    let iF = CGFloat(i)
                    path.move(to: CGPoint(x: widthDivided * iF, y: 0))
                    path.addLine(to: CGPoint(x: widthDivided * iF, y: size.height))
                }
                
                //MARK: Y Lines
                for i in 1..<nLines {
                    let iF = CGFloat(i)
                    path.move(to: CGPoint(x: 0, y: heightDivided * iF))
                    path.addLine(to: CGPoint(x: size.width, y: heightDivided * iF))
                }
            }
            .stroke(.white.opacity(0.3), lineWidth: 1)
            .blendMode(.difference)
        }

    }
}

struct TopButton: View {
    var title: String?
    var iconName: String?
    var action: (()->())
    var body: some View {
        Button {
            action()
        } label: {
            if let title = title {
                Text(title)
                    .font(.system(size: 18))
                    .fontWeight(.light)
                    .foregroundColor(.primary)
            }
            if let iconName = iconName {
                Image(systemName: iconName)
                    .font(.system(size: 18))
                    .fontWeight(.light)
                    .foregroundColor(.primary)
            }
        }

    }
}

struct ToolHorizontalSelector: View {
    let buttonIconNames = ["pencil.circle", "aspectratio", "slider.horizontal.3", "selection.pin.in.out", "bandage.fill", "dial.high", "slider.horizontal.below.rectangle"]
    
    @State var toolIdxSelected = 0
    
    var body: some View {
        let btnsSize = 36.0
        let btnPadding = 10.0
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxyReader in
                HStack(spacing: 30) {
                    ForEach(buttonIconNames.indices, id: \.self) { idx in
                        let iconName = buttonIconNames[idx]
                        let toolSelected = idx == toolIdxSelected
                        Button {
                            toolIdxSelected = idx
                            withAnimation(.easeInOut(duration: 0.23)) {
                                proxyReader.scrollTo(String(idx), anchor: .center)
                            }
                        } label: {
                            Image(systemName: iconName)
                                .font(.title.bold())
                                .foregroundColor(toolSelected ? .black : .white.opacity(0.4))
                                .frame(width: btnsSize, height: btnsSize)
                                .padding(btnPadding)
                                .background {
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(toolSelected ? Color("Orange") : .clear)
                                }
                        }
                        .id(String(idx))
                        .allowsHitTesting(!toolSelected)
                    }
                }
                .padding(.horizontal, UIScreen.main.bounds.width/2.0-btnsSize/2.0-btnPadding)
                .padding(.vertical, 8)
            }
        }
        .background {
            LinearGradient(colors: [.clear, .white.opacity(0.2), .clear], startPoint: .leading, endPoint: .trailing)
        }
        .overlay {
            LinearGradient(colors: [.black, .black.opacity(0.2), .clear, .black.opacity(0.2), .black], startPoint: .leading, endPoint: .trailing)
                .allowsHitTesting(false)
        }

    }
}

struct HorizontalSliderSelector: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scrollProxy in
                let lastIdx = 5
                HStack(spacing: 0) {
                    ForEach(-5..<lastIdx, id: \.self) { idx in
                        VStack(alignment: .leading, spacing: 0) {
                            ZStack(alignment: .leading) {
                                SegmentedRect(isLast: idx == 4)

                                Rectangle()
                                    .fill(.clear)
                                    .frame(width: 1)
                                    .id(String(idx))
                            }

                            if idx == 0 {
                                Image(systemName: "arrowtriangle.up.fill")
                                    .frame(width: 14, height: 24)
                                    .offset(x: -7)
                                    .scaleEffect(0.7, anchor: .leading)

                            } else {
                                Text("\(idx)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .frame(width: 14, height: 24)
                                    .offset(x: -7)
                            }
                            
                        }
                        .frame(width: 44)
                    }
                }
                .overlay(alignment:.bottomTrailing, content: {
                    Text("\(lastIdx)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(width: 14, height: 24)
                        .offset(x: 8)
                })
                .padding(.horizontal, UIScreen.main.bounds.width/2.0)
                .onAppear {
                    scrollProxy.scrollTo(String(0), anchor: .center)
                }
            }

        }
        .frame(height: 84)
        .overlay(content: {
            LinearGradient(colors: [.black, .black.opacity(0.2), .clear, .black.opacity(0.2), .black], startPoint: .leading, endPoint: .trailing)
                .allowsHitTesting(false)
        })
    }
    
    @ViewBuilder
    func SegmentedRect(isLast: Bool = false) -> some View {
        GeometryReader {
            let size = $0.size
            ZStack(alignment: .bottom) {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: size.height * 0.5))
                    path.addLine(to: CGPoint(x: 0, y: size.height * 1.0))
                }
                .stroke(.white, lineWidth: 2)
                                
                let subDivs = 5
                let subDivWidth = size.width / CGFloat(subDivs)
                Path { path in
                    for i in 1..<subDivs {
                        let iFloat = CGFloat(i)
                        path.move(to: CGPoint(x: iFloat * subDivWidth, y: size.height * 0.7))
                        path.addLine(to: CGPoint(x: iFloat * subDivWidth, y: size.height * 1.0))
                    }
                }
                .stroke(.white, lineWidth: 1)
                if isLast {
                    Path { path in
                        let iFloat = CGFloat(subDivs)
                        path.move(to: CGPoint(x: iFloat * subDivWidth, y: size.height * 0.5))
                        path.addLine(to: CGPoint(x: iFloat * subDivWidth, y: size.height * 1.0))

                    }
                    .stroke(.white, lineWidth: 2)
                }
            }
            
            
        }
    }
}

struct AspectSelector: View {
    
    @State var selectedAspectIdx = 0
    @Namespace var tabAnimated

    var body: some View {
        let aspectTitles = ["4:3", "1:1", "3:4", "16:9"]
        HStack(spacing: 2) {
            ForEach(aspectTitles.indices, id: \.self) { idx in
                let aspectTitle = aspectTitles[idx]
                let selIdx = idx == selectedAspectIdx
                Button {
                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.5, blendDuration: 0.32)) {
                        selectedAspectIdx = idx
                    }
                } label: {
                    Text(aspectTitle)
                        .font(.system(size: 16))
                        .fontWeight(selIdx ? .bold : .regular )
                        .fontWidth(selIdx ? .standard : .compressed)
                        .foregroundColor(selIdx ? .black : .white)
                        .animation(.none, value: selectedAspectIdx)
                        .frame(width: 44, height: 44)
                        .background {
                            if selIdx {
                                Capsule()
                                    .fill(Color("Yellow"))
                                    .matchedGeometryEffect(id: "aspect_tab", in: tabAnimated)
                            }
                        }
                        .padding(.horizontal, idx != 0 && idx != aspectTitles.count-1 ? 8 : 0)
                }
                .allowsHitTesting(!selIdx)
                .padding(.vertical, 0)
                .padding(.horizontal, 0)

            }
            
        }
        .background {
            Capsule(style: .continuous)
                .fill(.white.opacity(0.2))
        }
        .padding(.top, 14)

    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
