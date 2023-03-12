//
//  ContentView.swift
//  Edutainment
//
//  Created by Brandon Coston on 3/11/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingFinalScore = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isSetup = true
    @State private var minMultiplier = 2
    @State private var maxMultiplier = 12
    @State private var numOfQuestions = 10
    @State private var guess: Int? = nil
    @State private var mult1 = 2
    @State private var mult2 = 10
    @State private var score = 0
    @State private var answerCount = 1
    
    @FocusState private var guessIsFocussed: Bool
    
    var answer: Int {
        mult1 * mult2
    }
    let questionCount = [5, 10, 20]
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [
                    Color.white,
                    Color(red: 0.4627, green: 0.8392, blue: 1.0)
                ], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    if isSetup {
                        Form {
                            Section {
                                Stepper(value: $minMultiplier, in: 2...maxMultiplier) {
                                    Text("Minimum value: \(minMultiplier)")
                                }
                                Stepper(value: $maxMultiplier, in: minMultiplier...12) {
                                    Text("Maximum value: \(maxMultiplier)")
                                }
                            } header: {
                                Text("Times table range")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                            
                            Section {
                                Picker("How many Equations?", selection: $numOfQuestions) {
                                    ForEach(questionCount, id: \.self) {
                                        Text("\($0)")
                                    }
                                }
                                .pickerStyle(.segmented)
                            } header: {
                                Text("How many Equations?")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .transition(.push(from: .leading))
                        
                        Spacer()
                        
                        Button {
                            newEquation()
                            withAnimation {
                                isSetup.toggle()
                            }
                        } label: {
                            Text(isSetup ? "Start!" : "Quit")
                        }
                        .frame(width: 200, height: 80)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                    } else {
                        VStack(spacing: 10) {
                            Spacer()
                            ZStack {
                                Color.white
                                VStack {
                                    Text("Problem \(answerCount) of \(numOfQuestions)")
                                        .padding()
                                        .font(.largeTitle.bold())
                                    Spacer()
                                    Text("What is:")
                                    Text("\(mult1) x \(mult2)?")
                                    TextField("", value: $guess, format: .number)
                                        .textFieldStyle(.plain)
                                        .multilineTextAlignment(.center)
                                        .keyboardType(.numberPad)
                                        .focused($guessIsFocussed)
                                        .onChange(of: guessIsFocussed) { _ in
                                            guess = nil
                                        }
                                        
                                    Divider()
                                        .padding(.horizontal, 30)
                                        .backgroundStyle(.black)
                                    Spacer()
                                    Text("Score: \(score)")
                                        .font(.title2)
                                }
                                .font(.largeTitle)
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        Button("Submit") {
                                            checkAnswer()
                                            newEquation()
                                        }
                                    }
                                }
                            }
                            .backgroundStyle(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(50)
                            
                            Spacer()
                            Spacer()
                        }
                            .transition(.push(from: .leading))
                    }
                    
                }
                .navigationTitle(isSetup ? "Edutainment Setup" : "Lets Do Math!")
                .animation(.easeOut, value: isSetup)
            }
        }
        .alert(alertTitle, isPresented: $showingFinalScore) {
            HStack {
                Button("Done") {
                    reset()
                    isSetup = true
                }
                Button("Replay") {
                    reset()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func reset() {
        answerCount = 1
        score = 0
        newEquation()
    }
    
    private func newEquation() {
        mult1 = Int.random(in: minMultiplier...maxMultiplier)
        mult2 = Int.random(in: minMultiplier...maxMultiplier)
        guess = nil
    }
    
    private func checkAnswer() {
        if guess == answer {
            score += 1
        }
        guessIsFocussed = false
        guess = nil
        answerCount += 1
        if answerCount > numOfQuestions {
            alertTitle = score > answerCount / 2 ? "Good Job!" : "Better Luck Next Time"
            alertMessage = "Final score was \(score) out of \(numOfQuestions)"
            showingFinalScore = true
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
