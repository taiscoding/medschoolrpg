//
//  ContentView.swift
//  medschoolrpg
//
//  Created by Theodore Addo on 9/24/25.
//

import SwiftUI
import Combine

// MARK: - 1. Model (Data Layer)

// Create a simple Quest model.
struct Quest: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    var isCompleted: Bool = false
}

// Create the GameState model to hold all game data.
class GameState: ObservableObject {
    @Published var playerStamina: Int = 100
    @Published var playerKnowledge: Int = 0
    @Published var gameHistory: [String] = [
        "Welcome to MedSchoolRPG. Your journey begins...",
        "",
        "Type 'help' to see available commands."
    ]
    @Published var quests: [Quest] = [
        Quest(title: "Find the missing coffee mug", description: "Search the cafeteria for your lost mug. -10 stamina."),
        Quest(title: "Review patient charts", description: "Increase your knowledge by studying medical records. -15 stamina.")
    ]
    
    func addToHistory(_ text: String) {
        gameHistory.append(text)
    }
    
    func addMultipleToHistory(_ texts: [String]) {
        gameHistory.append(contentsOf: texts)
    }
}

// MARK: - 2. View Model (Logic Layer)

// Create the GameViewModel to manage game logic and state updates.
class GameViewModel: ObservableObject {
    @Published var gameState: GameState = GameState()
    @Published var playerInput: String = ""
    
    // Function to process player commands.
    func processCommand(_ command: String) {
        let lowercasedCommand = command.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !lowercasedCommand.isEmpty else { return }
        
        // Add command to history
        gameState.addToHistory("> \(command)")
        gameState.addToHistory("") // Add blank line for readability
        
        switch lowercasedCommand {
        case "help":
            let helpLines = [
                "Available Commands:",
                "• status - View your current stamina and knowledge",
                "• quests - See your active quests",
                "• find coffee mug - Complete the coffee mug quest",
                "• study - Study to increase knowledge (costs stamina)",
                "• rest - Restore some stamina",
                "• inventory - Check your items (coming soon)",
                "• help - Show this help message"
            ]
            gameState.addMultipleToHistory(helpLines)
            
        case "status":
            let statusLines = [
                "=== Current Status ===",
                "Stamina: \(gameState.playerStamina)/100",
                "Knowledge: \(gameState.playerKnowledge)"
            ]
            gameState.addMultipleToHistory(statusLines)
            
            if gameState.playerStamina < 20 {
                gameState.addToHistory("")
                gameState.addToHistory("⚠️ You're getting tired! Consider resting.")
            }
            
        case "quests":
            let activeQuests = gameState.quests.filter { !$0.isCompleted }
            let completedQuests = gameState.quests.filter { $0.isCompleted }
            
            gameState.addToHistory("=== Active Quests ===")
            if activeQuests.isEmpty {
                gameState.addToHistory("No active quests available.")
            } else {
                for quest in activeQuests {
                    gameState.addToHistory("• \(quest.title)")
                    gameState.addToHistory("  \(quest.description)")
                }
            }
            
            if !completedQuests.isEmpty {
                gameState.addToHistory("")
                gameState.addToHistory("=== Completed Quests ===")
                for quest in completedQuests {
                    gameState.addToHistory("✅ \(quest.title)")
                }
            }
            
        case "find coffee mug":
            if let index = gameState.quests.firstIndex(where: { $0.title == "Find the missing coffee mug" && !$0.isCompleted }) {
                if gameState.playerStamina >= 10 {
                    gameState.playerStamina -= 10
                    gameState.quests[index].isCompleted = true
                    gameState.addToHistory("☕ You found the coffee mug hidden behind some textbooks!")
                    gameState.addToHistory("You feel slightly more awake.")
                    gameState.addToHistory("")
                    gameState.addToHistory("✅ Quest completed: Find the missing coffee mug")
                } else {
                    gameState.addToHistory("You're too tired to search properly.")
                    gameState.addToHistory("Rest first to restore your stamina.")
                }
            } else {
                gameState.addToHistory("You've already found the coffee mug, or that quest isn't available right now.")
            }
            
        case "study":
            if gameState.playerStamina >= 15 {
                gameState.playerStamina -= 15
                gameState.playerKnowledge += 20
                gameState.addToHistory("📚 You spent an hour studying medical textbooks.")
                gameState.addToHistory("Your knowledge has increased by 20 points!")
                gameState.addToHistory("You feel mentally sharper but physically tired.")
                
                // Check if this completes the study quest
                if let index = gameState.quests.firstIndex(where: { $0.title == "Review patient charts" && !$0.isCompleted }) {
                    gameState.quests[index].isCompleted = true
                    gameState.addToHistory("")
                    gameState.addToHistory("✅ Quest completed: Review patient charts")
                }
            } else {
                gameState.addToHistory("You're too tired to focus on studying.")
                gameState.addToHistory("Rest first to restore your stamina.")
            }
            
        case "rest":
            let staminaGain = min(30, 100 - gameState.playerStamina)
            gameState.playerStamina += staminaGain
            gameState.addToHistory("😴 You take a well-deserved break and restore \(staminaGain) stamina.")
            gameState.addToHistory("Current stamina: \(gameState.playerStamina)/100")
            
        case "inventory":
            let inventoryLines = [
                "🎒 Your inventory:",
                "• Medical textbooks",
                "• Stethoscope",
                "• Notepad",
                "",
                "(Inventory system coming in future updates!)"
            ]
            gameState.addMultipleToHistory(inventoryLines)
            
        default:
            gameState.addToHistory("❓ I don't understand '\(command)'.")
            gameState.addToHistory("Type 'help' to see available commands.")
        }
        
        // Add blank line after each command response
        gameState.addToHistory("")
        
        // Clear input after processing
        DispatchQueue.main.async {
            self.playerInput = ""
        }
    }
}

// MARK: - 3. View (UI Layer)

// Create the main view for the game interface.
struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with game title and stats
            HStack {
                VStack(alignment: .leading) {
                    Text("MedSchoolRPG")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Your medical journey awaits...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Text("Stamina: \(viewModel.gameState.playerStamina)")
                    }
                    HStack {
                        Image(systemName: "brain.head.profile")
                            .foregroundColor(.blue)
                        Text("Knowledge: \(viewModel.gameState.playerKnowledge)")
                    }
                }
            }
            .padding()
            .background(Color(.controlBackgroundColor))
            
            Divider()
            
            // Game Text Output Area
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(viewModel.gameState.gameHistory.enumerated()), id: \.offset) { index, text in
                            HStack {
                                if text.isEmpty {
                                    // Empty line for spacing
                                    Text(" ")
                                        .font(.system(.body, design: .monospaced))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                } else {
                                    Text(text)
                                        .font(.system(.body, design: .monospaced))
                                        .textSelection(.enabled)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(text.hasPrefix(">") ? .secondary : .primary)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                            .id(index)
                        }
                        
                        // Invisible spacer to ensure proper scrolling
                        Spacer()
                            .frame(height: 1)
                            .id("spacer")
                    }
                    .padding(.vertical)
                }
                .background(Color(.textBackgroundColor))
                .onChange(of: viewModel.gameState.gameHistory.count) { _ in
                    // Scroll to bottom when new content is added
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeOut(duration: 0.3)) {
                            proxy.scrollTo("spacer", anchor: .bottom)
                        }
                    }
                }
            }
            
            Divider()
            
            // Player Input Area
            HStack {
                TextField("Enter your command here...", text: $viewModel.playerInput)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        viewModel.processCommand(viewModel.playerInput)
                    }
                
                Button("Submit") {
                    viewModel.processCommand(viewModel.playerInput)
                }
                .keyboardShortcut(.return)
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(Color(.controlBackgroundColor))
        }
        .frame(minWidth: 700, minHeight: 500)
        .navigationTitle("MedSchoolRPG")
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}