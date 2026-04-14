# Star Border Animation (8086 Assembly Language)

##  Overview
The **Star Border Animation** is a low-level graphics simulation project developed in **8086 Assembly Language (NASM syntax)** and executed in a **DOSBox environment**.

The project demonstrates direct interaction with **video memory (0xB800)** to create a text-mode graphical animation without using any high-level libraries or interrupts for rendering.

It simulates a moving 3-character object (`***`) that travels continuously along a rectangular border in a controlled loop.


##  Objectives
- Understand low-level memory manipulation in x86 architecture
- Work with text-mode video memory (0xB800)
- Implement loop-based animation in Assembly
- Learn screen coordinate calculation in 80×25 text mode
- Develop timing control using software delays

##  Features
- Full-screen clearing (80×25 text mode)
- Rectangular border rendering using ASCII characters
- Animated 3-star object (`***`)
- Continuous clockwise movement:
  - Top edge (Left → Right)
  - Right edge (Top → Bottom)
  - Bottom edge (Right → Left)
  - Left edge (Bottom → Top)
- Software-based delay for visible animation effect
- Clean exit using keyboard interrupt

##  Technical Architecture

###  Video Memory Model
- Memory Segment: `0xB800`
- Each screen cell = 2 bytes:
  - Byte 1: ASCII Character
  - Byte 2: Attribute (Color, e.g. `0x07` = Light Grey)


###  Screen Initialization
The program clears the screen by filling all **2000 character cells** with blank spaces using direct memory writes.


###  Border Rendering Logic
A fixed rectangular boundary is drawn using:
- `-` → Horizontal borders (Top & Bottom)
- `|` → Vertical borders (Left & Right)

Screen resolution:
- 80 columns × 25 rows (standard text mode)


##  Animation Flow (State Machine Logic)

The animation follows a **clockwise cyclic traversal**:

### Phase 1: Top Row Movement
- Direction: Left → Right
- Step size: +2 (next column)
- Condition: Stop at right boundary


### Phase 2: Right Column Movement
- Direction: Top → Bottom
- Step size: +160 (next row)
- Condition: Stop at bottom boundary


### Phase 3: Bottom Row Movement
- Direction: Right → Left
- Step size: -2
- Condition: Stop at left boundary


### Phase 4: Left Column Movement
- Direction: Bottom → Top
- Step size: -160
- Condition: Stop at top boundary


##  Delay Mechanism
A software delay is implemented using nested loops:

- Outer loop counter: `DX = 1000`
- Inner loop counter: `SI = 250`

This ensures visible animation speed on DOSBox emulation.


##  Key Concepts Used
- Direct hardware-level memory access
- Segment register manipulation (`ES = 0xB800`)
- Offset-based screen addressing
- Loop control with conditional jumps
- Basic finite-state animation logic
- BIOS and DOS interrupt usage


##  Program Termination
- Waits for keyboard input using BIOS interrupt:


##  Requirements
- NASM Assembler
- DOSBox (8086 environment)

##  How to Run

### 1. Assemble the program
mount x d:\filename
nasm file.asm -o file.com
file.com
