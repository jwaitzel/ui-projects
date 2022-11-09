//
//  Home.swift
//  SwiftTut12
//
//  Created by Javiw on 8/31/22.
//

import SwiftUI

struct Home: View {
    
    //MARK: Sample cards
    @State var cards: [Card] = []
    
    //MARK: Animation Properties
    @Namespace var animation
    @State var selectedCard: Card?
    @State var showDetail = false
    @State var showDetailContent = false
    @State var showExpenses = false
    
    init() {
        self.initCardVariables()
    }
    
    func initCardVariables() {
        self.cards = [
            .init(cardImage: "Card1"),
            .init(cardImage: "Card2"),
            .init(cardImage: "Card2")
        ]
    }
    
    var body: some View {
        //All view
        VStack {
            
            //Top Views
            VStack (alignment: .leading, spacing: 6) {
                Text("Welcome Back,")
                    .font(.title.bold())
                
                Text("Javiwwww")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .trailing, content: {
                //MARK: Profile Button
                Button {
                    
                } label: {
                    Image("profile-image")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 64.0, height: 64.0)
                        .clipShape(Circle())
                }

            
            })
            .padding(16)
            
            //Total Balance
            VStack (alignment: .leading, spacing: 6) {
                
                Text("Total Balance,")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                Text("$1,924.35")
                    .font(.title.bold())
                

            }
            .padding(16)
            .padding(.top, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            CardScrollView()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .opacity(showDetail ? 0 : 1)
        .background (
            Color("BG")
        )
        .overlay {
            if let selectedCard, showDetail {
                DetailView(card: selectedCard)
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: 1)))
            }
        }
        .overlay {
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.initCardVariables()
            }
            
        }
    }
    
    @ViewBuilder
    func CardScrollView() -> some View {
        ScrollView (.horizontal, showsIndicators: false) {
            HStack {
                ForEach(cards) { card in
                    
                    //Card cell
                    GeometryReader { proxy in
                        let size = proxy.size
                        
                        
                        if selectedCard?.id == card.id && showDetail {
                            
                            Rectangle()
                                .fill(.clear)
                                .frame(width: size.width, height: size.height)
                            
                        } else {
                            
                            Image(card.cardImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .matchedGeometryEffect(id: "\(card.id)", in: animation)
                            //MARK:- Rotation effect
                                .rotationEffect(.init(degrees: -90))
                            //MARK:- Rotated frame
                                .frame(width:size.height, height: size.width)
                            //MARK:- Placing it center
                                .frame(width:size.width, height: size.height)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8)) {
                                        selectedCard = card
                                        showDetail = true
                                    }
                                }
                            
                        }

                    }
                    .frame(width: 340.0)
                }
            }
            .padding(16)
            .padding(.leading, 16)
        }
    }
        
    //MARK:- Detail card view
    @ViewBuilder
    func DetailView(card:Card) -> some View {
        VStack {
            HStack {
                
                Button {
                    withAnimation (.easeInOut(duration: 0.4)){
                        showDetailContent = false
                        showExpenses = false
                    }
                    withAnimation (.easeInOut(duration: 0.5).delay(0.05)){
                        showDetail = false
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.white)
                }

                Text("Back")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 16.0)
            .opacity(showDetailContent ? 1.0 : 0.0)
            
            Image(card.cardImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .matchedGeometryEffect(id: card.id, in: animation)
            //MARK: Fixing rotation
            //We need new variable for doing detail animations
            //For more why? ...
                .rotationEffect(.init(degrees: showDetailContent ? 0.0 : -90))
                .frame(height: 220)
            
            ExpenseView()
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                showDetailContent = true
            }
            
            withAnimation(.easeInOut.delay(0.1)) {
                showExpenses = true
            }
        }
    }

    
    @ViewBuilder
    func ExpenseView() -> some View {
        
        GeometryReader { proxy in
            let size = proxy.size
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack (spacing: 20) {
                    ForEach(expenses) { expense in
                        ExpenseCardView(expense: expense)
                    }
                }
                .padding()
            }
            .clipShape(Rectangle())
            .frame(width: size.width, height: size.height)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.white)
            }
            .offset(y: showExpenses ? 0.0 : size.height + 50)
        }
        .padding(.top)
        .padding(.horizontal, 16.0)
    }
    
    
   
    
    
     
}

//MARK:- Expense card view
//Why new view?
//Becuase card carries new @State variables
struct ExpenseCardView: View {
    var expense: Expense
    @State var showView = false
    var body: some View {
        HStack (spacing: 14.0){
            
            Image(expense.productIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 44.0, height:44.0)
            
            VStack (alignment: .leading, spacing: 8.0) {
                Text(expense.product)
                    .fontWeight(.bold)
                
                Text(expense.spendType)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack (alignment: .leading, spacing: 8.0) {
                Text(expense.amountSpent)
                    .fontWeight(.bold)
                
                Text(Date().formatted(date: .numeric, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        //MARK: Animation
        .opacity(showView ? 1 : 0)
        .foregroundColor(.black)
        //MARK: To look like it's pushing from bottom
        .offset(y: showView ? 0 : 24)
        .onAppear {
            
            //Should wait for matched geometry
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                //We need index to animate the content with proper timing
                withAnimation(.easeInOut(duration: 0.3).delay(Double(getIndex()) * 0.1)) {
                    showView = true
                }
            }
        }
        
    }
    
    func getIndex() -> Int {
        let index = expenses.firstIndex { C1 in
            return C1.id == expense.id
        } ?? 0
        
        return index < 20 ? index : 20
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
