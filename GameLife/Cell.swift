//
//  Cell.swift
//  GameLife
//
//  Created by Shevshelev Lev on 27.05.2022.
//

import Foundation

enum State {
    case alive
    case dead
}

struct Cell {
    let x: Int
    let y: Int
    var state: State
    
    func isNeighbor(to cell: Cell) -> Bool {
        let dx = abs(x - cell.x)
        let dy = abs(y - cell.y)
        switch (dx, dy) {
        case (0, 1), (1, 0), (1, 1):
            return true
        default:
            return false
        }
    }
}

extension Cell: Equatable {
    static func ==(lhs: Cell, rhs: Cell) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y && lhs.state == rhs.state
    }
}
