//
//  ContentView.swift
//  LazyClockWatch Watch App
//
//  Created by Hundter Biede on 11/5/22.
//  Copyright © 2022 Hundter Biede. All rights reserved.
//

import SwiftUI

let calendar = Calendar.current

struct ContentView: View {
    @State var textColorIndex = 0
    @State var timeString = NaturalLanguageTime(Date()).description
    @State var lastRan = Date()
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()

    var body: some View {
        VStack {
            Text(timeString)
                .font(.system(size: 500))
                .minimumScaleFactor(0.01)
                .foregroundColor(swiftUIColorRotation[textColorIndex])
                .onReceive(timer) { _ in
                    if calendar.component(.hour, from: lastRan) != calendar.component(.hour, from: lastRan) ||
                        calendar.component(.minute, from: lastRan) != calendar.component(.minute, from: lastRan) {
                        self.lastRan = Date()
                        self.timeString = NaturalLanguageTime(lastRan).description
                    }
                }
        }
        .padding()
        .onTapGesture {
            textColorIndex = textColorIndex + 1 == swiftUIColorRotation.count
                ? 1
                : textColorIndex + 1
        }
        .onAppear {
            // Loads saved data for the clock
            textColorIndex =
                UserDefaults.standard.integer(forKey: "LazyClock-ColorIndex")
            if textColorIndex >= colorRotation.count || textColorIndex < 1 {
                // Prevent using 0
                textColorIndex = 1
            }
        }
        .onDisappear {
            UserDefaults.standard.set(textColorIndex, forKey: "LazyClock-ColorIndex")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
