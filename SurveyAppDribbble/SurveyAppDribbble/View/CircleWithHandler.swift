//
//  CircleWithHandler.swift
//  SurveyAppDribbble
//
//  Created by javi www on 11/18/22.
//

import SwiftUI

struct CircleWithHandler: View {
    var controllerSize: CGFloat = 320
    let handlerSize: CGFloat = 44
    @State var handlerOffset: CGPoint = .zero
    @State private var handlerEndOffset: CGPoint = .zero
    @State private var onDragging = false
    
    @Binding var value: Int
    
    init(controllerSize: CGFloat, handlerOffset: CGPoint, value: Binding<Int>) {
        self.controllerSize = controllerSize
        self.handlerOffset = handlerOffset
        self.handlerEndOffset = handlerOffset
        self.onDragging = false
        self._value = value
    }
    
    var distanceFromCenter: CGFloat {
        CGPoint.zero.distance(from: handlerOffset)
    }
    var relativeSize: CGFloat {
        min(controllerSize, distanceFromCenter/(controllerSize/2) * controllerSize)
    }
    
    var body: some View {
        ZStack {
            //Out container
            Circle()
                .stroke(.clear)
            
            Circle()
                .stroke(.white.opacity(0.5), lineWidth: 3)
                .frame(width: relativeSize, height: relativeSize)
                .background {
                    Circle()
                        .fill(.white.opacity(0.2))
                }
            
            //MARK: Handler
            let angle = CGPoint.zero.angle(ending: handlerOffset)

            let dragGesture = DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if !onDragging {
                        onDragging.toggle()
                        UISelectionFeedbackGenerator().selectionChanged()
                    }
                    handlerOffset = CGPoint(x:handlerEndOffset.x + value.translation.width, y: handlerEndOffset.y + value.translation.height)
                    
                    let angle = CGPoint.zero.angle(ending: handlerOffset)
                    let maxXForAngle = cos(Angle(degrees: angle).radians) * (controllerSize/2)
                    let maxYForAngle = sin(Angle(degrees: angle).radians) * (controllerSize/2)
                    let cappedX = handlerOffset.x < 0 ? max(maxXForAngle, handlerOffset.x) : min(maxXForAngle, handlerOffset.x)
                    let cappedY = handlerOffset.y < 0 ? max(maxYForAngle, handlerOffset.y) : min(maxYForAngle, handlerOffset.y)

                    handlerOffset = CGPoint(x:cappedX, y: cappedY)

                    let relValue = relativeSize/controllerSize
                    self.value = Int(relValue * 10)
                }
                .onEnded { value in
                    handlerEndOffset = handlerOffset
                    onDragging = false
                }
            
            
            Circle()
                .fill(onDragging ? .black : .black.opacity(0.8))
                .frame(width: handlerSize, height: handlerSize)
                .overlay {
                    Text("< >")
                        .font(.title3.bold())
                        .fontWidth(.condensed)
                        .foregroundColor(.white)
                        .offset(y: -2)
                }
                .overlay(content: {
                    Circle()
                        .stroke(onDragging ? .white : .clear)
                })
                .scaleEffect(onDragging ? 1.125 : 1)
                .rotationEffect(.init(degrees: angle))
                .offset(x:handlerOffset.x, y: handlerOffset.y)
                .gesture(dragGesture)
                .shadow(color: onDragging ? .black.opacity(0.4) : .clear, radius: 4.0)
            
        }
        .frame(width:controllerSize, height: controllerSize)
    }
}

struct CircleWithHandler_Previews: PreviewProvider {
    static var previews: some View {
        CircleWithHandler(controllerSize: 320, handlerOffset: CGPoint(x: 75, y: 0), value: .constant(4))
            .background(Color("BG 4"))
    }
}

extension CGPoint {
    
    func distance(from point: CGPoint) -> CGFloat {
        return hypot(point.x - x, point.y - y)
    }
    
    func angle(ending: CGPoint) -> CGFloat {
        let center = CGPoint(x: ending.x - self.x, y: ending.y - self.y)
        let radians = atan2(center.y, center.x)
        let degrees = radians * 180 / .pi
        return degrees //degrees > 0 ? degrees : degrees + degrees
    }
}
