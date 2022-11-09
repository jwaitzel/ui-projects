//
//  ContentView.swift
//  SwiftTut12
//
//  Created by Javiw on 8/31/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
       Home()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
