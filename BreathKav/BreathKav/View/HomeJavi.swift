//
//  HomeJavi.swift
//  BreathKav
//
//  Created by javi www on 11/8/22.
//

import SwiftUI

struct HomeJavi: View {
    var body: some View {
        ZStack {
            //Breathe title
            VStack {
                Text("Breathe Out")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 36)
            
            //Center circles animation
            VStack {
                Text("1")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                BreatheCircles()
            }
            
            //Bottom button
            VStack {
                Button {
                    
                } label: {
                    Text("Finish breathe")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(.black, lineWidth: 2)
                        }
                        
                }
                
                .padding(.horizontal, 12)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            Image("breath-overlay")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .scaleEffect(1.2)
                .offset(x:0)
                .opacity(0.8)
                .allowsHitTesting(false)
                
        }
    }
}

struct BreatheCircles: View {
    
    let circleSize: CGFloat = 120
    @State var animateCircles = false
    var body: some View {
        ZStack {
            
            let circlesCount: Int = 8
            let slice = CGFloat.pi * 2.0 / CGFloat(circlesCount)
            let radius: CGFloat = animateCircles ? 1 : 130
            ForEach(0..<circlesCount, id: \.self) { idx in
                
                let theta = slice * CGFloat(idx)
                let pos = CGPoint(x: cos(theta) * radius, y: sin(theta) * radius)
                Circle()
                    .fill(.pink)
                    .frame(width: circleSize, height: circleSize)
                    .offset(x: pos.x, y: pos.y)
            }
            
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                animateCircles = true
            }
        }
    }
}

struct HomeJavi_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
