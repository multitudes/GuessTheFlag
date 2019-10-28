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
    @State private var scoreTitle = "Lets start!"

    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var score = 0

    @State private var flagOpacity = [1.0, 1.0, 1.0]
    @State private var flagBlur: [CGFloat] = [0, 0, 0]
    @State private var animationAmount: [CGFloat] = [1.0, 1.0, 1.0]
    @State var allowhittesting = true
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
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        FlagImage(country: self.countries[number])

                    }
                    .opacity(self.flagOpacity[number])
                    .blur(radius: self.flagBlur[number])
                    .scaleEffect(self.animationAmount[number])
                    .allowsHitTesting(self.allowhittesting ? true : false)
                    .animation(.default)
                     }
                
                
                Text("current score \(score)")
                    .foregroundColor(.white)
                Text(scoreTitle)
                    .foregroundColor(.white)
                    .font(.title)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                Text("Details go here.")
                .transition(.move(edge: .bottom))
                Spacer()
            }
            //            .alert(isPresented: $showingScore) {
            //                Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")) {
            //                    self.askQuestion()
            //
            //                    })
            //            }
        } 
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        animationAmount = [1.0, 1.0, 1.0]
        flagOpacity = [1.0, 1.0, 1.0]
        flagBlur = [0, 0, 0]
        allowhittesting = true
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
            wrongAnimation()
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
            } else {
                flagOpacity[flag] = 0.25
            }
        }
    }
    
    func wrongAnimation() {
        for flag in 0...2 {
            if flag != correctAnswer {
                flagBlur[flag] = 6
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
