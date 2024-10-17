//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Razvan Pricop on 07.10.24.
//

import SwiftUI

enum Move: CaseIterable {
    case Rock, Paper, Scissors
}

struct ContentView: View {
    @State var playerMove: Move = .Rock
    @State var computerMove: Move = .Rock
    @State var win: Bool = false
    @State var score: Int = 0
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Score: \(score)")
                    .font(.title)
                Text("Computer move: \(computerMove)")
                    .font(.title)
                win ? Text("You should win!") : Text("You should lose!")
                    .font(.title2)
            }
            
            HStack {
                Button("🪨") {
                    handleMove(.Rock)
                }
                Button("📄") {
                    handleMove(.Paper)
                }
                Button("✂️") {
                    handleMove(.Scissors)
                }
            }
            .font(.system(size: 80))
        }
        .alert("End round", isPresented: $showAlert) {
            Button("Continue") {
                endRound()
            }
        } message: {
            Text("You chose \(playerMove)")
        }
        .navigationBarTitle("Rock, Paper, Scissors")
        .padding()
    }
    
    func handleMove(_ move: Move) {
        playerMove = move
        determineOutcome(playerMove: playerMove, computerMove: computerMove, win: win)
        alertMessage = "You chose \(playerMove)"
        showAlert = true
    }
    
    func determineOutcome(playerMove: Move, computerMove: Move, win: Bool) {
        let outcomes: [((Move, Move), () -> Void)] = [
            ((.Rock, .Paper), { win ? loss() : pass()}),
            ((.Paper, .Scissors), { win ? pass() : loss()}),
            ((.Scissors, .Rock), { win ? loss() : pass()}),
            ((.Rock, .Scissors), { win ? pass() : loss()}),
            ((.Paper, .Rock), { win ? pass() : loss()}),
            ((.Scissors, .Rock), { win ? pass() : loss()}),
            ((.Rock, .Rock), draw),
            ((.Paper, .Paper), draw),
            ((.Scissors, .Scissors), draw)
        ]
        
        if let outcome = outcomes.first(where: { $0.0 == (playerMove, computerMove)}) {
            outcome.1()
        }
    }
    
    func pass() {
        score += 1
    }
    
    func loss() {
        score -= 1
    }
    
    func draw() {
        
    }
    
    func endRound() {
        if score == 10 {
            score = 0
        }
        
        computerMove = Move.allCases.randomElement()!
        win = Bool.random()
    }
}

#Preview {
    ContentView()
}
