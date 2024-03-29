//
//  ContentView.swift
//  project2-GuessTheFlag
//
//  Created by Beto Toro on 28/06/22.
//

import SwiftUI

struct Flagimage: View {
  
  let countries: String
  let animationAmount: Double
  let isAnimated: Bool
  let selectedFlag: Int
  let flagNumber: Int
  
  var body: some View {
    Image(countries)
      .renderingMode(.original)
      .clipShape(Capsule())
      .shadow(radius: 5)
      .rotation3DEffect(.degrees(isAnimated ? animationAmount : 0.0), axis: (x: 0, y: 1, z: 0))
      .opacity(selectedFlag == -1 || flagNumber == selectedFlag ? 1 : 0.25)
    
  }
}

struct Title: ViewModifier {
  func body(content: Content) -> some View {
    content
      .foregroundColor(.white)
      .font(.largeTitle.bold())
  }
}

extension View {
  func titleStyle() -> some View {
    modifier(Title())
  }
}

struct ContentView: View {
  
  @State private var showingScore = false
  @State private var scoreTitle = ""
  @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
  let labels = [
    "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
    "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
    "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
    "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
    "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
    "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
    "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
    "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
    "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
    "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
    "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
  ]
  @State private var correctAnswer = Int.random(in: 0...2)
  @State private var score = 0
  @State private var animationAmount = 0.0
  @State private var selectedflag = -1
  
  var body: some View {
    ZStack {
      RadialGradient(stops: [
        .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
        .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
      ], center: .top, startRadius: 200, endRadius: 400)
      .ignoresSafeArea()
      
      VStack {
        
        Spacer()
        
        Text("Guess the flag")
          .titleStyle()
        
        Spacer()
        
        VStack(spacing: 15) {
          VStack {
            Text("Tap the flag of")
              .foregroundColor(.white)
              .font(.subheadline.weight(.heavy))
            
            Text(countries[correctAnswer])
              .foregroundColor(.white)
              .font(.largeTitle.weight(.semibold))
            
          }
          ForEach(0..<3) { number in
            Button {
              flagTapped(number)
            } label: {
              Flagimage(countries: countries[number], animationAmount: animationAmount, isAnimated: number == correctAnswer, selectedFlag: selectedflag, flagNumber: number)
                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
            }
          }
        }
        
        Spacer()
        
        Text("Score \(score)")
          .foregroundColor(.white)
          .font(.title.bold())
        
        Spacer()
      }
    }
    .alert(scoreTitle, isPresented: $showingScore) {
      Button("Continue", action: askQuestion)
    } message: {
      Text("Your score is \(score)!")
    }
  }
  
  func flagTapped(_ number: Int) {
    selectedflag = number
    
    if number == correctAnswer {
      scoreTitle = "Correct"
      score += 5
      withAnimation() {
        animationAmount = 360
      }
    } else {
      scoreTitle = "Wrong"
      score -= 5
    }
    
    showingScore = true
  }
  
  func askQuestion() {
    selectedflag = -1
    countries.shuffle()
    correctAnswer = Int.random(in: 0...2)
    withAnimation() {
      animationAmount = 0
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
