//
//  World.swift
//  GameLife
//
//  Created by Shevshelev Lev on 27.05.2022.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var cells: [Cell] = []
    @Published var startButtonTitle = "Start"
    @Published var isAlive: Bool = false
    @Published var isOver: Bool = false
    private var timer: Timer?
    private var prevCells: [Cell]?
    let size: Int = 50
    
    init() {
        getFirstGeneration()
    }
    
    func startLive() {
        if timer == nil {
        timer = Timer.scheduledTimer(
            timeInterval: 0.250,
            target: self,
            selector: #selector(updateCells),
            userInfo: nil,
            repeats: true
        )
            isAlive = true
        } else {
            isAlive = false
            timer?.invalidate()
            timer = nil
        }
        startButtonTaped()
    }
    
    func getFirstGeneration() {
        var cells: [Cell] = []
        for x in 0..<size {
            for y in 0..<size {
                let randomState = arc4random_uniform(3)
                let cell = Cell(x: x, y: y, state: randomState == 0 ? .alive : .dead)
                cells.append(cell)
            }
        }
        isAlive = false
        isOver = false
        startButtonTitle = "Start"
        self.cells = cells
    }
    
    @objc private func updateCells() {
        DispatchQueue.global(qos: .userInitiated).sync {
            var updatedCells:[Cell] = []
            let liveCells = cells.filter { $0.state == .alive }
            for cell in cells {
                let livingNeighbors = liveCells.filter { $0.isNeighbor(to: cell) }
                switch livingNeighbors.count {
                case 2...3 where cell.state == .alive:
                    updatedCells.append(cell)
                case 3 where cell.state == .dead:
                    let liveCell = Cell(x: cell.x, y: cell.y, state: .alive)
                    updatedCells.append(liveCell)
                default:
                    let deadCell = Cell(x: cell.x, y: cell.y, state: .dead)
                    updatedCells.append(deadCell)
                }
            }
            DispatchQueue.main.async {[unowned self] in
                if updatedCells != prevCells && updatedCells != cells {
                    prevCells = cells
                    cells = updatedCells
                } else {
                    isAlive = false
                    isOver = true
                    startButtonTitle = "Life is over"
                    timer?.invalidate()
                    timer = nil
                }
            }
        }
    }
    
    private func startButtonTaped() {
        if startButtonTitle == "Start" {
            startButtonTitle = "Stop"
        } else {
            startButtonTitle = "Start"
        }
    }
}
