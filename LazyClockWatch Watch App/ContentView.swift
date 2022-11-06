//
//  ContentView.swift
//  LazyClockWatch Watch App
//
//  Created by Hundter Biede on 11/5/22.
//  Copyright © 2022 Hundter Biede. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text(NaturalLanguageTime().description)
                .font(.system(size: 500))
                .minimumScaleFactor(0.01)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
