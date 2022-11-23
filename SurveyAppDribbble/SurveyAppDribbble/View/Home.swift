//
//  Home.swift
//  SurveyAppDribbble
//
//  Created by javi www on 11/2/22.
//

import SwiftUI

struct Home: View {
    
    @State var showSurvey = false
    var body: some View {
        ZStack {
            if showSurvey {
                
                ZStack {
                    Color("BG 4")
                        .ignoresSafeArea()
                    
                    Button {
                        showSurvey = false
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding()
                }
                .transition(.move(edge: .trailing))
                
            } else {
                ZStack {
                    Color("BG")
                        .ignoresSafeArea()
                    
                    //TopBar
                    topBar
                    
                    //Center text content
                    centerTextContent
                    
                    //Bottom create button and login
                    bottomCreateAndLogin

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .animation(.easeOut(duration: 0.43), value: showSurvey)
        .background {
            Color("BG")
                .ignoresSafeArea()
        }
    }
     
    var topBar: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("SUR\nVEY.")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                
                Spacer()
                
                let cSize:CGFloat = 8
                
                ForEach(0..<3) { idx in
                    HStack(spacing: 0) {
                        if idx == 2 {
                         Capsule()
                                .fill(.black)
                                .frame(width: cSize * 3.2, height: cSize)
                        } else {
                            Circle()
                                .fill(.gray)
                                .frame(width: cSize, height: cSize)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 30)
            .padding(.top, -10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    var centerTextContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Want to know")
                    .lineSpacing(16)
                    .offset(x: -6)
                    .overlay(alignment: .leading) {
                        HStack(spacing: 48) {
                            AvatarCircle(image: "1", color: "BG 1")
                            AvatarsCapsule(images: ["7", "2"], color: "BG 2")
                        }
                        .offset(x: 138, y: 78)
                    }
                
                Text("what")
                    .offset(x: -6)
                
                Text("people")
                    .offset(x: 120)
                    .overlay(alignment: .leading) {
                        HStack(spacing: 48) {
                            AvatarsCapsule(images: ["4", "9"], color: "BG 3")
                        }
                        .offset(x: -8, y: 0)
                    }

                Text("want?")
                    .offset(x: -6)
            }
            .font(.system(size: 50, weight: .bold))
            .padding(.top, 102)
            .kerning(1.2)
            .offset(x: -4)
            
            Button {
                showSurvey = true
            } label: {
                Text("Just ask")
                    .font(.system(size: 28, weight: .semibold))
                    .kerning(0.9)
                    .padding(.vertical, 32)
                    .padding(.horizontal, 34)
                    .background(Material.ultraThick.opacity(0.9), in: Capsule(style: .circular))
                    
            }
            .padding(.top, 28)
            .padding(.leading, 44)
            .foregroundColor(.primary)
            .background {
                AvatarCircle(image: "10", color: "BG 4")
                    .scaleEffect(2.3)
                    .rotationEffect(.degrees(-15))
                    .offset(x: 140, y: -44)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.leading, 40)
    }
    
    @ViewBuilder
    func AvatarCircle(image: String, color: String) -> some View {
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .background {
                Circle()
                    .fill(Color(color))
            }
            .clipShape(Circle())
            .frame(width: 74, height: 74)
    }
    
    @ViewBuilder
    func AvatarsCapsule(images: [String], color: String) -> some View {
        HStack(spacing: 0) {
            ForEach(images, id: \.self) { img in
                Image(img)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .background {
            Capsule()
                .fill(Color(color))
        }
        .clipShape(Capsule())
        .frame(width: 74, height: 74)
    }
    
    var bottomCreateAndLogin: some View {
        VStack(spacing: 38) {
            CreateSlider(showSurvey: $showSurvey)
                .frame(maxWidth: .infinity)
                .frame(height: 92)
            
            //Login
            HStack(spacing: 0) {
                Button {
                    
                } label: {
                    Text("Have an account?")
                }
                .foregroundColor(.secondary)
                .kerning(0.8)
                .allowsHitTesting(false)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Log In")
                        .underline()
                }
                .foregroundColor(.primary)
            }
            .padding(.bottom, 24)
            .font(.system(size: 18, weight: .semibold))

        }
        .padding(.horizontal, 30)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
}

struct CreateSlider: View {
    
    @State var offsetX: CGFloat = 0
    @State var endOffsetX:CGFloat = 0
    private let paddingHorizontal: CGFloat = 8
    private let handlerWidth: CGFloat = 160.0
    
    @Binding var showSurvey: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(.primary)
                .overlay(alignment: .trailing) {
                    HStack(spacing: 0) {
                        ForEach(0..<3) { idx in
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                        }
                        
                    }
                    .padding(.trailing, 46)
                    .modifier(ShimmerModifier())
                    
                }
            
            GeometryReader {
                let size = $0.size
                Capsule()
                    .fill(Color("BG"))
                    .frame(width: handlerWidth)
                    .overlay {
                        Text("Create")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, paddingHorizontal)
                    .offset(x: offsetX)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                dragOnChanged(value: value, size: size)
                            }
                            .onEnded { value in
                                dragOnEnded(value: value, size: size)
                            }
                )
            }
                
        }
    }
    
    func maxHandlerOffset(size: CGSize) -> CGFloat {
        return size.width - paddingHorizontal * 2 - handlerWidth
    }
    
    func dragOnChanged(value:DragGesture.Value, size:CGSize) {
        let maxAvWidth = maxHandlerOffset(size: size)
        offsetX = max(0, min(maxAvWidth, endOffsetX + value.translation.width))
    }
    
    func dragOnEnded(value:DragGesture.Value, size:CGSize) {
        let maxAvWidth = maxHandlerOffset(size: size)
        if offsetX > maxAvWidth * 0.5 {
            withAnimation(.interactiveSpring(blendDuration: 0.23)) {
                offsetX = maxAvWidth
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.23) {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                showSurvey = true
            }
        } else {
            withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.23)) {   
                offsetX = 0
            }
        }
        
        endOffsetX = offsetX
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct ShimmerModifier: ViewModifier {
    
    @State var animationShimmer = false

    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .mask {
                    Rectangle()
                        .fill(
                            LinearGradient(colors: [.white.opacity(0.5), .white, .white.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                        )
                        .rotationEffect(.init(degrees: 70))
                        .padding(0)
                        .offset(x: -50)
                        .offset(x: animationShimmer ? 130 : 0)
                }
                .task {
                    withAnimation(.linear(duration: 1.0).repeatForever(autoreverses:false)) {
                        animationShimmer.toggle()
                    }
                }
        } else {
            content
        }
        
    }
}
