//
//  QuestionResponseView.swift
//  SurveyAppDribbble
//
//  Created by javi www on 11/17/22.
//

import SwiftUI

struct QuestionResponseView: View {
    
    @State var responseValue: Int = 8
    
    var body: some View {
        VStack(spacing: 0) {
            //Top buttons
            let headerBtnSize: CGFloat = 76
            HStack(spacing: 12) {
                Button {
                    
                } label: {
                    Image(systemName: "rectangle.grid.2x2.fill")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("BG"))
                        .frame(width: headerBtnSize, height: headerBtnSize)
                        .background {
                            Circle()
                                .fill(Color("DarkGray"))
                        }
                }
                                
                Button {
                    
                } label: {
                    HStack(spacing: 24) {
                        Image(systemName: "checkmark")
                            .font(.title3)
                            .fontWeight(.bold)

                        Text("Use Template")
                            .font(.callout)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.black)
                    .frame(height: headerBtnSize)
                    .padding(.horizontal, 32)
                    .background {
                        Capsule()
                            .fill(Color("BG"))
                    }
                    .padding(.leading, 28)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 32)
            .padding(.top, 72)
            //Title and page count
            HStack(alignment: .bottom) {
                Text("Market\nResearch")
                    .font(.system(size: 44))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    
                Spacer()
                HStack(spacing: 0) {
                    Text("6")
                        .foregroundColor(.white)
                    Text("of 12")
                        .foregroundColor(.gray)
                        .padding(.leading, 4)
                }
                .offset(y: -4)
                .padding(.trailing, 24)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 28)
            .padding(.top, 44)
            //Value
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { reader in
                    HStack(spacing: 8) {
                        ForEach(1...10, id: \.self) { i in
                            Button {
                                responseValue = i
                            } label: {
                                Text("\(i)")
                                    .foregroundColor(.white)
                                    .frame(width: 74, height: 74)
                                    .background {
                                        if responseValue == i {
                                            Circle()
                                                .stroke(Color("DarkGray"))
                                        } else {
                                            Circle()
                                                .fill(Color("DarkGray"))
                                        }
                                        
                                    }
                            }
                            .id(String(i))
                        }
                    }
                    .onAppear {
                        reader.scrollTo(String(responseValue))
                    }
                }
                
            }
            .padding(.top, 32)
            
            
            //Question and Value slider
            VStack {
                QuestionResponseSlider(value:$responseValue)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .rotationEffect(.init(degrees: -10))
//            .hidden()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//        .background {
//            Image("survey-question-reply")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: screenSize.width, height: screenSize.height)
//                .offset(y: -14)
////                .hidden()
//        }
    }
    
    var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }
}

struct QuestionResponseSlider: View {
    @Binding var value:Int
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color("BG 4"))
            
            VStack(spacing: 0) {
                Text("How do you feel about the quality of the product?")
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal, 32)
                
                ConcentricCirclesValuesSlider(value:$value)
                    .padding(.top, 32)
                    .padding(.bottom, 24)
                

            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, 32)
            
        }
        .frame(height: 440)
        .padding(.horizontal, 16)

    }
    
}

struct ConcentricCirclesValuesSlider: View {
    @State var anglesForEmojis: [CGFloat] = Array(repeating: 0, count: 4)
    @Binding var value:Int
    
    var body: some View {
        let circleEmojiValues = Array(["😍", "🙂", "😕", "☹️"].reversed())
        let innerPaddingOffset:CGFloat = 70
        let innerCircle: CGFloat = 70
        let outSize = innerCircle + innerPaddingOffset * 3
        ZStack {
            //Final size 70 + 70 * 3 = 450
            ForEach(0..<circleEmojiValues.count, id: \.self) { idx in
                let emojiIcon = circleEmojiValues[idx]
                let circleSize = innerCircle + innerPaddingOffset * CGFloat(idx)
                ZStack {
                    Circle()
                        .stroke(.white.opacity(CGFloat(idx) * 0.2 + 0.3))
                    
                    Text(emojiIcon)
                        .rotationEffect(.radians(-anglesForEmojis[idx]))
                        .offset(x: circleSize/2.0)
                        .rotationEffect(.radians(anglesForEmojis[idx]))
                }
                .frame(width: circleSize, height: circleSize)
                
            }
            
            let initialValue = 0.3//0.36 is max, depends on angle
            CircleWithHandler(controllerSize: outSize, handlerOffset: CGPoint(x: outSize * initialValue, y: outSize * initialValue), value: $value)

        }
        .onAppear{
            initRandomAnglesForEmojis()
        }
    }
    
    func initRandomAnglesForEmojis() {
        for i in 0..<anglesForEmojis.count {
            anglesForEmojis[i] = CGFloat.random(in: 0...CGFloat.pi * 2.0)
        }

        for i in 0..<anglesForEmojis.count {
            withAnimation(.linear(duration: 10.0 + CGFloat(i) * 4.0).repeatForever(autoreverses:false)) {
                anglesForEmojis[i] += CGFloat.pi * 2
            }
        }
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}


struct QuestionResponseView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
