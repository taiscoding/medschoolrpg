# MedSchoolRPG

A text-based role-playing game that simulates the challenging yet rewarding journey of medical school, where players manage stamina, build knowledge, and complete quests on their path to becoming a doctor.

## Key Features

- **Text-based game loop** - Classic command-line interface with real-time text output
- **Stamina and Knowledge stats** - Dual resource management system that affects gameplay decisions  
- **Quest system** - Interactive missions with completion tracking and rewards
- **Command processing** - Robust text parser supporting multiple game actions
- **Real-time UI updates** - Live stat display with SwiftUI reactive interface
- **Game history tracking** - Persistent log of all player actions and game responses
- **MVVM architecture** - Clean separation of concerns for maintainable code
- **Cross-platform compatibility** - Built with SwiftUI for macOS, iOS, and iPadOS

## Available Commands

- `help` - Display all available commands
- `status` - View current stamina and knowledge levels
- `quests` - Show active and completed quests
- `study` - Increase knowledge points (costs stamina)
- `rest` - Restore stamina levels
- `find coffee mug` - Complete the coffee mug quest
- `inventory` - View your items (coming soon)

## How to Run

### Prerequisites
- Xcode 15.0 or later
- macOS 14.0+ (for macOS target) or iOS 17.0+ (for iOS target)
- Swift 5.9+

### Building and Running
1. Clone this repository to your local machine
2. Open `medschoolrpg.xcodeproj` in Xcode
3. Select your target device or simulator
4. Press `Cmd + R` or click the "Run" button to build and launch the app
5. Start playing by typing commands in the input field at the bottom of the window

### First Steps
1. Type `help` to see all available commands
2. Check your initial stats with `status`  
3. View your starting quests with `quests`
4. Begin your medical school journey!

## Future Plans

### Core Gameplay Enhancements
- **Level Up system** - Character progression with experience points and level milestones
- **Skill Tree** - Branching specialization paths (Surgery, Internal Medicine, Pediatrics, etc.)
- **Advanced Quest System** - Multi-step quests, branching storylines, and consequence-based outcomes
- **Inventory Management** - Collectible items, medical equipment, and consumables
- **Day/Night Cycle** - Time-based mechanics affecting stamina regeneration and quest availability

### Social and Competitive Features  
- **Leaderboard** - Global and local rankings based on knowledge points and quest completion
- **Multiplayer Study Groups** - Collaborative quests and shared learning experiences
- **Peer Competition** - Challenge friends and compare medical school progress
- **Achievement System** - Unlockable badges and milestones for various accomplishments

### Content Expansion
- **Multiple Medical Specialties** - Diverse career paths with unique challenges and rewards
- **Realistic Medical Scenarios** - Evidence-based patient cases and clinical decision-making
- **Study Material Integration** - Real medical knowledge incorporated into gameplay
- **Procedural Content** - Dynamically generated quests and scenarios for replayability

### Technical Improvements
- **Save/Load System** - Persistent game state across app launches
- **Settings and Customization** - Configurable difficulty levels and UI themes
- **Performance Optimization** - Enhanced scrolling and memory management for long play sessions
- **Platform-Specific Features** - Touch controls for mobile, keyboard shortcuts for desktop

## Architecture

This project follows the **MVVM (Model-View-ViewModel)** architectural pattern:

- **Model**: `GameState` and `Quest` structures manage game data
- **ViewModel**: `GameViewModel` handles business logic and command processing  
- **View**: `ContentView` provides the SwiftUI interface and user interactions

## Contributing

This project is currently in early development. Future versions will include contribution guidelines for those interested in expanding the medical education gaming experience.

## License

This project is available for educational and personal use. Please check back for formal licensing information in future releases.

---

*Embark on your medical school journey today - where every command shapes your path to becoming a doctor!*