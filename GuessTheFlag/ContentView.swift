//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Sebastian Cioată on 12.03.2023.
//

import SwiftUI


struct FlagImage: View{
    var text: String
    
    var body: some View{
        Image(text)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}
struct ContentView: View {
    
    @State private var showingScore = false
    @State private var isRestart = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var round = 1
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var selectedNumber = 0
    @State private var correctFlag = false
    @State private var wrongFlag = false
    @State private var makeFlagOpaque = false
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack(spacing: 15){
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3 ) { number in
                        Button(action: {
                            withAnimation {
                                flagTapped(number)
                            }
                        }){
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                                .shadow(color: .black, radius: 2)
                        }.rotation3DEffect(.degrees(correctFlag && selectedNumber == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                            .opacity(self.makeFlagOpaque && !(self.selectedNumber == number) ? 0.25 : 1)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Text("Round: \(round)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action:askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("8 occurences. Restart the game?", isPresented: $isRestart){
            Button("Restart", action:restartGame)
        } message: {
            Text("Your score is \(score)")
        }
    }
    
    func flagTapped(_ number: Int){
        selectedNumber = number
        if round == 8{
            isRestart = true
        }else{
            if number == correctAnswer{
                scoreTitle = "Correct"
                score += 1
                correctFlag = true
            } else {
                scoreTitle = "Wrong! That's the flag of \(countries[number])"
                wrongFlag = true
            }
            round += 1
            showingScore = true
        }
    }

    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        correctFlag = false
        wrongFlag = false

    }
    func restartGame(){
        score = 0
        round = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        correctFlag = false
        wrongFlag = false
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
