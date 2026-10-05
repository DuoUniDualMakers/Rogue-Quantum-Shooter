# Rogue Quantum Shooter: Anomaly Breach Survival

Developers:
  Maksims Mirgaļejevs mm23175
  Mareks Vasiļevskis mv23041

Game Concept:
  Topdown 2D Roguelike Shooter that combines elements of the Quantum Mechanics. The aim of the game is to survive a set amount of time while battling and shooting aliens and monsters in the large arena.

Story:
  The protagonist is a rogue operative who works outside the official organizations that control the region. One night, while traveling through a massive restricted forest, he encounters something impossible: an Anomaly Breach. Reality itself has started breaking down. Creatures from somewhere-or somewhen-are appearing inside the forest. Objects exist in multiple states simultaneously. Dead creatures sometimes return. And the protagonist discovers that his own body has become affected by the anomaly. Instead of simply dying from exposure, he becomes capable of existing in different quantum states.
  Main Character - Codename: ROGUE. A former anomaly-response operative who abandoned his organization after discovering they were experimenting on civilians. Now he works alone, taking dangerous contracts beyond the quarantine zone. He's just extremely good with guns and has survived situations that should have killed him.
  Location - Darkwood Exclusion Zone: The Null Forest of the Dark or, simply, The Dark Forest. 
  TL;DR: A rogue operative trapped inside a reality-breaking forest must survive an ever-expanding anomaly while using its quantum effects against the creatures emerging from it.


Quantum Concept(s):
  Superposition
    The player starts in |1⟩ (represents "alive" state).The first enemy hit on the player applies a Hadamard gate H|1⟩ =1/√2 * |0⟩−1/√2 – |1⟩ . The character is now neither alive or dead - this will be displayed on the screen.
  Quantum States
    Basically 4 States:
    |0⟩ - represents "dead" state, end of game
    |+⟩ - represents superposition, the "doomed" phase
    |-⟩ - represents superposition, the "safe" phase
    |1⟩ - represents "alive" state, stable
    |+⟩ and |-⟩ will look the same to a direct alive/dead measurement (50/50). They differ only in relative phase, and that is hidden difference decides what happens at the level Gate
  Quantum gates
    X gate - may be used to recover from the "dead" state. Well, no one restricts the player to use it while in the alive state also...
    H gate Hadamard - applied on the first enemy hit, and again on the level Gate
    Z gate phase flip - |-⟩ -> |+⟩ . Applied when the player survives a hit in |-⟩ state
    Rz​(θ)=[e^−iθ/2 0]
    [0​ e^iθ/2​)] (Luck) - is rotation around Z axis. When the accumulated angle reaches pi it becomes a Z gate and flips  |+⟩ back to |-⟩
  Measurements
    Each hit taken in superposition is a measurement attempt. Its chance of killinmg the player is modified by the Luck variable, more Luck, lower chance of death
  Interference
    The end-of-level Gate applies H and measures. Because of interference the result is deterministic H|-⟩ = |1⟩ (alive) and H|+⟩ = |0⟩ (dead). Some items can apply a Z phase flip. since we use Z phase flip two times with two similar items we will be in same phase so the items cancel each other out. This may    give player opportunity to pay attention at the details to combine items correctly.
    Luck itself represents constructive/destructive interference, because it modifies the survival rate on measurement, in other words, it may happen so that there is 90% of death, and 10% survival: 90% |0⟩ or 10% |1⟩ .
  Entanglement
    Entangle Bullet Skill:
      You entangle yourself with an enemy: PLAYER ←────────→ ENEMY. For example If the enemy is measured into 0, you become 1.
      High Luck → strongly favors Player |1⟩ / Enemy |0⟩ 
      Low Luck → much more dangerous 
      Successful entanglement → enemy dies, player remains stable 
      Failed entanglement → player collapses to |0⟩ and the run ends

  Idea for the second play mode:    make |0⟩ also playable, e.g. injured state. Assign health points to the states: 0 - 50HP, 1 - 100HP, While the superposition combines the whole potential - 150HP. Meaning the player is simultaneously potentially injured and stable until measurement. 150 HP in superposition doesn't necessarily mean you're simply stronger. It could mean those 150 HP are distributed between the two possible states. Then measurement collapses you into either |0⟩ or |1⟩, and your available HP changes accordingly. And an X gate would simply swap: 100 HP ↔ 50 HP while H could be our way to enter superposition. Being |0⟩ isn't automatically a failure state. You might actually have abilities that are stronger while injured. That could create a nice loop: Injured → manipulate probability → superposition → measure → empowered → deliberately flip back → exploit injured-state ability → repeat.
  
  Quantum Game Mechanics:
    Core loop - The player fights enemies in top-down roguelike rooms. The first hit starts the quantum cycle:
      1. |1⟩ -> |-⟩ In-game character state transitions after the first hit
      2. In |-⟩ state every hit is a death roll modified by Luck variable. On death the state become |0⟩. On survival Z phase flip is applied which moves player to the |+⟩ state
      3. In |+⟩, hits are death rolls with worse odds. The playter is not safe, if they reach the level Gate in |+⟩ they will shift in |0⟩ which means game end
      4. Luck is earned by killing enemies quickly and in close combat. At the threshold Rz(pi) Z phase flip applied and moves player from |+⟩ to the |-⟩ state
      5. End of level Gate - A player |1⟩ passes and probably rewarded . A player in superposition gets H gate and a measurement |-⟩ passes and returns to |1⟩ state, and |+⟩ dies
      6. Quantum Enemies - there may be superposition enemies that should be measured to fully destroy them, while regularly shooting them with regular bullets may stop them for a while until they are ressurected again.
    What to do. Reading the state is the core mechanic: in |+⟩ the player must farm Luck, so player is pushed to the aggresively exactly when most vulnerable. Items mostly affect Luck, Armor, weapons and a unique items that provide additional ways to avoid death. This is not just random.
    Hidden phase. |+⟩ and |-⟩ look the same to a normal measurment, yet they lead to opposite outcomes at the Gate. This information is only revealed through interference.
    Gates compose and cancel. Using twice the same H or Z phase flip cancels each other
    Order matters. Gate sequences are not commutative (if H then Z phase flip doesn't equivalent to Z and then H gates)
    

Gameplay and Rules:
  Main Player Actions:
    Move around the arena and shoot approaching enemies.
    Fight to build Luck.
    Collect weapons, armor, and quantum items that modify Luck, survivability, or quantum states.
    Monitor the player's hidden quantum phase and make decisions based on the current state.
    Reach the Level Gate before the end of the level and attempt to survive the measurement.

  Turn/game structure: Real-time top-down combat; there are no traditional turns. Each level consists of an arena where the player fights enemies for a set amount of time.

  Single-player or multiplayer: Single-player. The game is designed around managing the player's own quantum state and making risk/reward decisions during combat.

  Typical flow of one round/session: The player spawns in the arena. Timer starts. Enemies start spawning. Player shoots enemies while dodging the incoming projectiles/melee enemies. Player gets experience from killing enemies and upgrades his level. He also gets a 3-5 cards to pick from, a new ability, equipment, stat upgrades etc. When the timer ends the final gate spawns. Player enters the gate and passes the level or dies. 

Winning / Losing / Game Objectives: Winning is surviving the arena level for a set amount of time. Losing is dying while trying to survive the arena level. Game Objective is to pass all of the levels.

Platform and Development Tools: Windows Platform, Godot Engine

Originality / Existing Games: There are similar Rogue-like games, because the genre itself is instantly recognizable. This project is different in its aim to apply quantum-mechanics inspired elements and systems to the popular Rogue-like game genre, which the developers of this project havent seen before yet. The project doesn't exactly adapt an existing game.




