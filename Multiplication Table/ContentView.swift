//
//  ContentView.swift
//  Multiplication Table
//
//  Created by Brandon Barros on 5/8/20.
//  Copyright © 2020 Brandon Barros. All rights reserved.
//

import SwiftUI

struct Question {
    var a: Int
    var b: Int
    
    func getAnswer() -> Int {
        a * b
    }
    
    func getQuestion() -> String {
        "What is \(a) X \(b)"
    }
}

struct ContentView: View {
    //Set stage
    @State private var gameStage = 0
    
    //Decided stage 0
    @State private var characters = ["bear", "cow", "dog", "zebra", "monkey", "panda", "pig", "snake", "chicken"]
    @State private var characterChoice = ""
    @State private var noChar = false
    
    //Decided stage 1
    @State private var numberLimit = 8
    @State private var totalQuestionsOptions = ["1", "5", "10", "25", "50", "All"]
    @State private var totalQuestions = 1
    @State private var badInput = false
    @State private var questions: [Question] = []
    
    //Stage 2
    @State private var answerStage = 0
    @State private var questionNumber = 0
    @State private var correct = 0
    @State private var userAnswer = ""
    @State private var gameOver = false

    
    var validInput: Bool {
        questionsToAsk <= (numberLimit + 1) * (numberLimit + 1)
    }
    
    var questionsToAsk: Int {
        let s = totalQuestionsOptions[totalQuestions]
        if (s == "All") {
            return ((numberLimit + 1) * (numberLimit + 1))
        } else {
            return Int(s) ?? 0
        }
    }
    
    
    var body: some View {
        Group {
            ZStack {
                //Background
                AngularGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .red]), center: .center)
                    .edgesIgnoringSafeArea(.all)
                
                
                if (gameStage == 0) {
                    VStack {
                        Text("Choose your player")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        if (characterChoice != "") {
                            Text("Your Selection:")
                                .foregroundColor(.white)
                                .font(.title)
                            Image(characterChoice).renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                        
                        Spacer()
                        
                        HStack {
                            ForEach(0 ..< 3) {num in
                                Button(action: {
                                    self.characterChoice = self.characters[num]
                                }) {
                                    Image(self.characters[num]).renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                        .frame(width: 70, height: 70)
                                }
                            }
                        }
                        HStack {
                            ForEach(3 ..< 6) {num in
                                Button(action: {
                                    self.characterChoice = self.characters[num]
                                }) {
                                    Image(self.characters[num]).renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                        .frame(width: 70, height: 70)
                                }
                            }
                        }
                        HStack {
                            ForEach(6 ..< 9) {num in
                                Button(action: {
                                    self.characterChoice = self.characters[num]
                                }) {
                                    Image(self.characters[num]).renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                        .frame(width: 70, height: 70)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Button("Next Stage") {
                            self.gameStage += 1
                        }
                        
                        Spacer()
                    }
                    .alert(isPresented: $noChar) {
                        Alert(title: Text("Wait!"), message: Text("You haven't picked a character yet!"), dismissButton: .default(Text("Try Again")))
                    }
                    
                } else if (gameStage == 1) {
                    VStack {
                        Text("Game Detials")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Image(characterChoice).renderingMode(.original)
                        
                        Spacer()
                        
                        Section {
                            Stepper("", value: $numberLimit, in: 1...12, step: 1)
                                .frame(width: 80, height: 50)
                            Text("0 to \(numberLimit)")
                        }
                        
                        Section {
                            Picker("Total Questions", selection: $totalQuestions) {
                                ForEach(0 ..< totalQuestionsOptions.count) {num in
                                    Text("\(self.totalQuestionsOptions[num])")
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        Spacer()
                        Section {
                            Button("Start Game") {
                                if (self.validInput) {
                                    self.gameStage += 1
                                    self.createQuestions()
                                    self.questions.shuffle()
                                } else {
                                    self.badInput = true
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .alert(isPresented: $badInput) {
                        Alert(title: Text("Uh Oh!"), message: Text("Not enough possible questions. Try making the range bigger"), dismissButton: .default(Text("Try Again")))
                    }
                    
                } else {
                    VStack {
                        
                        Spacer()
                        
                        HStack {
                            Image(characterChoice).renderingMode(.original)
                            if (answerStage == 0) {
                                Text("You got this!")
                            } else if (answerStage == 1) {
                                Text("Nice! You're killing it")
                            } else {
                                Text("Don't worry you'll get the next one!")
                            }
                        }
                        
                        Spacer()
                        
                        
                        if (!gameOver) {
                            Text(questions[questionNumber].getQuestion())
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        TextField("Enter answer here", text: $userAnswer)
                            
                        
                        Spacer()
                        
                        Button("Check Answer") {
                            if (self.userAnswer == "") {
                                
                            } else {
                                self.checkAnswer()
                                print(self.questionsToAsk)
                                print(self.questionNumber)
                                print(self.gameOver)
                            }
                            
                        }
                        .frame(width: 200, height: 70)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 403))
                        
                        Spacer()
                        
                        Text("Score: \(correct) out of \(questionNumber)")
                    }
                    .alert(isPresented: $gameOver) {
                        Alert(title: Text("Great Job!"), message: Text("You got \(correct) out of \(questionNumber) correct"), dismissButton: .default(Text("New Game"), action: {
                            self.restartGame()
                        }))
                    }
                }
            }
        }
    }
    
    func restartGame() {
        gameStage = 0
        gameOver = false
        correct = 0
        questionNumber = 0
        questions = []
        answerStage = 0
    }
    
    func createQuestions() {
        var q: [(Question)] = []

        for i in 0 ... numberLimit {
            for j in 0 ... numberLimit {
                q.append(Question(a: i, b: j))
            }
        }
        questions = q
    }
    
    func checkAnswer() {
        let a = Int(userAnswer) ?? Int.min
        if (a == questions[questionNumber].getAnswer()) {
            correct += 1
            answerStage = 1
            
        } else {
            answerStage = 2
        }
        questionNumber += 1
        userAnswer = ""
        
        if (questionNumber == questionsToAsk) {
            gameOver = true
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
