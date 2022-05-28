//
//  ContentView.swift
//  GameLife
//
//  Created by Shevshelev Lev on 27.05.2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    private var gameField: [GridItem] {
        Array(
            repeating: GridItem(.adaptive(minimum: 10), spacing: 0),
            count: viewModel.size
        )
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: gameField, spacing: 0) {
                    ForEach(0..<viewModel.cells.count) { i in
                        Rectangle()
                            .foregroundColor(
                                viewModel.cells[i].state == .dead
                                ? .white
                                : .black
                            )
                            .frame(
                                width: geometry.size.width / CGFloat(viewModel.size),
                                height: geometry.size.width / CGFloat(viewModel.size)
                            )
                    }
                }
                Spacer()
                HStack(alignment: .center, spacing: 100) {
                    Button(action: viewModel.startLive) {
                        Text(viewModel.startButtonTitle)
                            .foregroundColor(
                                viewModel.isAlive
                                ?.red
                                : viewModel.isOver
                                ? .gray
                                : .blue)
                    }
                    .disabled(viewModel.isOver)
                    Button("Randomize") {
                        viewModel.getFirstGeneration()
                    }
                    .disabled(viewModel.isAlive)
                }
                .alert("Life is over!", isPresented: $viewModel.isOver) {
                    Button("Start all over again") {
                        viewModel.getFirstGeneration()
                    }
                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
