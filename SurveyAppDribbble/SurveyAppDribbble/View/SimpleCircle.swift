//
//  SimpleCircle.swift
//  SurveyAppDribbble
//
//  Created by javi www on 11/17/22.
//

import SwiftUI

struct SimpleCircle: View {
    
    @State var angle:CGFloat = 0
    @State var polarCoords: CGPoint = .zero
    
    @State var animateTimer: Timer?
    let radius:CGFloat = 150.0
    
    @State var angle2: CGFloat = 0.0

    var body: some View {
        let polarCoordinates = CGPoint(x: cos(angle) * radius, y: sin(angle) * radius)

        ZStack {
            Circle()
                .stroke(.primary)
                .overlay {
                    ZStack {
                        Text("a")
                            .offset(x:polarCoordinates.x, y: polarCoordinates.x)
                    }
                    .frame(width: 300, height: 300)
                    
                    Text("p")
                        .rotationEffect(.radians(-angle))
                        .offset(x: 150)
                        .rotationEffect(.radians(angle))
                        
                }
                .frame(width: 300, height: 300)
            
        }
        .frame(width: 300, height: 300)
        .onAppear {
            withAnimation(.linear(duration: 5).repeatForever(autoreverses:false)) {
                angle = .pi * 2.0
            }
            
            animateTimer = Timer.scheduledTimer(withTimeInterval: 1.0/30.0, repeats: true, block: { _ in
                angle2 += 0.04

                polarCoords = CGPoint(x: CGFloat(cosf(Float(angle2)) * Float(radius)), y: CGFloat(sinf(Float(angle2)) * Float(radius)))
            })
        }
        .overlay {
            Text("😍")
                .frame(width: 300, height: 300)
                .position(x: 300, y: 300)
                .position(x: polarCoords.x, y: polarCoords.y)

            Text("\(Int(polarCoords.x)) - \(Int(polarCoords.y))")
        }
        .frame(width: 300, height: 300)

    }
    
}

struct SimpleCircle_Previews: PreviewProvider {
    static var previews: some View {
        SimpleCircle()
    }
}
