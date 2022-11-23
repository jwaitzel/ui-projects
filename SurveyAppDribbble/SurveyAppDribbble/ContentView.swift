//
//  ContentView.swift
//  SurveyAppDribbble
//
//  Created by javi www on 11/2/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        QuestionResponseView()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
