//
//  Home.swift
//  BreathKav
//
//  Created by javi www on 11/8/22.
//

import SwiftUI

struct Home: View {
    @State var currentType: BreatheType = sampleTypes[0]
    @Namespace var animation
    //MARK: Animation Properties
    @State var showBreathView: Bool = false
    @State var startAnimation: Bool = false
    
    //MARK: Timer
    @State var timerCount: CGFloat = 0
    @State var breatheAction: String = "Breathe In"
    @State var count: Int = 0
    
    var body: some View {
        ZStack {
            background
            
            MainContent()
            
            Text(breatheAction)
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 54)
                .opacity(showBreathView ? 1 : 0)
                .animation(.easeInOut(duration: 1), value: breatheAction)
                .animation(.easeInOut(duration: 1), value: showBreathView)
        }
        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
            if showBreathView {
                //MARK: Extra timer for 0.1 delay
                if timerCount > 3.2 {
                    timerCount = 0
                    breatheAction = (breatheAction ==  "Breathe Out") ? "Breathe In" : "Breathe Out"
                    withAnimation(.easeInOut(duration: 3).delay(0.2)) {
                        startAnimation.toggle()
                    }
                    //MARK: Haptic feedback
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                } else {
                    timerCount += 0.01
                }
                count = 3 - Int(timerCount)
            } else {
                timerCount = 0
            }
        }
    }
    
    var background: some View {
        GeometryReader {
            let size = $0.size
            
            Image("BG")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .offset(y: -50)
                .frame(width: size.width, height: size.height)
                .clipped()
                .blur(radius: showBreathView ? 4 : 0, opaque: true)
                .overlay {
                    ZStack {
                        LinearGradient(colors: [
                            currentType.color.opacity(0.9),
                            .clear,
                            .clear
                        ], startPoint: .top, endPoint: .bottom)
                        .frame(height: size.height / 1.5)
                        .frame(maxHeight: .infinity, alignment: .top)
                        
                        LinearGradient(colors: [
                            .clear,
                            .black,
                            .black,
                            .black,
                            .black,
                        ], startPoint: .top, endPoint: .bottom)
                        .frame(height: size.height / 1.35)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
                
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func MainContent() -> some View {
        VStack {
            HStack {
                Text("Breathe")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    
                } label: {
                    Image(systemName: "suit.heart")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.ultraThinMaterial)
                        }
                }
            }
            .padding()
            .opacity(showBreathView ? 0 : 1)
            
            GeometryReader {
                let size = $0.size
                
                VStack {
                    CirclesAnimated(size: size)
                    
                    Text("Breathe to reduce")
                        .font(.title3)
                        .foregroundColor(.white)
                        .opacity(showBreathView ? 0 : 1)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(sampleTypes) { type in
                                Text(type.title)
                                    .foregroundColor(currentType.id == type.id ? .black : .white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 16)
                                    .background {
                                        ZStack {
                                            if currentType.id == type.id {
                                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                    .fill(.white)
                                                    .matchedGeometryEffect(id: "TAB", in: animation)
                                            } else {
                                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                    .stroke(.white.opacity(0.5))
                                            }
                                        }
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation(.easeInOut) {
                                            currentType = type
                                        }
                                    }
                            }
                        }
                        .padding()
                        .padding(.leading, 24)
                    }
                    .opacity(showBreathView ? 0 : 1)
                    
                    Button {
                        self.startBreathingAction()
                    } label: {
                        Text(showBreathView ? "Finish Breathe" : "START")
                            .fontWeight(.semibold)
                            .foregroundColor(showBreathView ? .white.opacity(0.75) : .black)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .background {
                                if showBreathView {
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(.white.opacity(0.5))
                                } else {
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(currentType.color)
                                }
                            }
                    }
                    .padding()
                }
                .frame(width: size.width, height: size.height, alignment: .bottom)
                
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    func CirclesAnimated(size:CGSize) -> some View {
        ZStack {
            ForEach(1...8, id: \.self) { idx in
                Circle()
                    .fill(currentType.color.gradient.opacity(0.5))
                    .frame(width: 150, height: 150)
                    .offset(x: startAnimation ? 0 : 75)
                    .rotationEffect(.init(degrees: Double(idx) * 45))
                    .rotationEffect(.init(degrees: startAnimation ? -45 : 0))
            }
        }
        .scaleEffect(startAnimation ? 0.8 : 1)
        .overlay(content: {
            Text("\(count == 0 ? 1 : count)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .animation(.easeInOut, value: count)
                .opacity(showBreathView ? 1 : 0)
        })
        .frame(height: (size.width - 40))
    }
    
    func startBreathingAction() {
        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
            showBreathView.toggle()
        }
        
        if showBreathView {
            withAnimation(.easeInOut(duration: 3.0).delay(0.05)) {
                startAnimation = true
            }
        } else {
            withAnimation(.easeInOut(duration: 1.5)) {
                startAnimation = false
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
