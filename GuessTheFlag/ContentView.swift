//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Laurent B on 13/10/2019.
//  Copyright © 2019 Laurent B. All rights reserved.
//
import UIKit
import SwiftUI


struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = "Ready!"
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var score = 0
    
    @State private var flagOpacity = [1.0, 1.0, 1.0]
    @State private var flagBlur: [CGFloat] = [0, 0, 0]
    @State private var animationAmount: [CGFloat] = [1.0, 1.0, 1.0]
    @State var allowhittesting = true
    @State private var flagAngle = [0.0, 0.0, 0.0]
        var showMessage: String {
        return scoreTitle
    }
    
    struct FlagImage: View {
        var country: String
        
        var body: some View {
            Image(self.country)
                .renderingMode(.original)
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 2))
        }
    }
    
    // timer
    @State private var currentDate = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timeRemaining = 4
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of").foregroundColor(.white)
                    Spacer(minLength: 10)
                    Text(countries[correctAnswer])
                        .lineLimit(nil)
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        FlagImage(country: self.countries[number])
                        
                    }
                    .opacity(self.flagOpacity[number])
                    .rotation3DEffect(.degrees(self.flagAngle[number]), axis: (x: 1, y: 1, z: 0))
                    .blur(radius: self.flagBlur[number])
                    .scaleEffect(self.animationAmount[number])
                    .allowsHitTesting(self.allowhittesting ? true : false)
                    .animation(.easeOut)
                }
                
                
                Text("current score \(score)")
                    .foregroundColor(.white)
                Text(scoreTitle)
                    .foregroundColor(.white)
                    .font(.title)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
        }
    }
    func askQuestion() {
        scoreTitle = "Ready!"
        flagAngle = [0.0, 0.0, 0.0]
        animationAmount = [1.0, 1.0, 1.0]
        flagOpacity = [1.0, 1.0, 1.0]
        flagBlur = [0, 0, 0]
        allowhittesting = true
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    func flagTapped(_ number: Int) {
        allowhittesting = false
        if number == correctAnswer {
            score += 1
            scoreTitle = "Correct!"
            correctAnimation()
        } else {
            score -= 1
            scoreTitle = """
            Wrong!
            That was \(countries[number])!
            """
            wrongAnimation(number)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.askQuestion()
            
        }
        
        showingScore = true
    }
    func correctAnimation() {
        for flag in 0...2 {
            if flag == correctAnswer {
                animationAmount[flag] = 1.40
                flagAngle[flag] = 360.0
            } else {
                flagOpacity[flag] = 0
            }
        }
    }
    
    func wrongAnimation(_ number: Int) {
        for flag in 0...2 {
            if flag == number {
                flagBlur[flag] = 0.5
                animationAmount[flag] = 1.40
            } else {
                flagOpacity[flag] = 0
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
