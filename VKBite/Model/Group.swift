import Foundation

struct Group {
    // MARK: Properties
    var humans: [[Human]] = [[]]
    
    // MARK: Initialize
    init(size: Int) {
        self.humans = getGroup(with: size.getMinSquareWithResidue())
    }
}

// MARK: - Methods
private extension Group {
    func getGroup(with pattern: (square: Int, residue: Int)) -> [[Human]] {
        var matrix: [[Human]] = [[]]
        
        // Setup square
        for rowIterator in 0..<pattern.square {
            var row: [Human] = []
            
            for columnIterator in 0..<pattern.square {
                let human = Human(id: UUID())
                
                if rowIterator != 0 {
                    let topNeighbor = matrix[rowIterator - 1][columnIterator]
                    topNeighbor.append(neighbor: human.id)
                    human.append(neighbor: topNeighbor.id)
                }
                
                if rowIterator != pattern.square - 1 {
                    let bottomNeighbor = matrix[rowIterator + 1][columnIterator]
                    bottomNeighbor.append(neighbor: human.id)
                    human.append(neighbor: bottomNeighbor.id)
                }
                
                if columnIterator != 0 {
                    let leftNeighbor = matrix[rowIterator][columnIterator - 1]
                    leftNeighbor.append(neighbor: human.id)
                    human.append(neighbor: leftNeighbor.id)
                }
                
                if columnIterator != pattern.square - 1 {
                    let rightNeighbor = matrix[rowIterator][columnIterator + 1]
                    rightNeighbor.append(neighbor: human.id)
                    human.append(neighbor: rightNeighbor.id)
                }
                
                row.append(human)
            }
            
            matrix.append(row)
        }
        
        // Setup residue
        var residue: [Human] = []
        
        for iterator in 0..<pattern.residue {
            let human = Human(id: UUID())
            
            if iterator != 0 {
                let leftNeighbor = residue[iterator - 1]
                leftNeighbor.append(neighbor: human.id)
                human.append(neighbor: leftNeighbor.id)
            }
            
            if iterator != pattern.residue - 1 {
                let rightNeighbor = residue[iterator + 1]
                rightNeighbor.append(neighbor: human.id)
                human.append(neighbor: rightNeighbor.id)
            }
            
            residue.append(human)
        }
        
        // Merge square and residue
        let squareLastRow = matrix[pattern.square - 1]
        
        for iterator in 0..<residue.count {
            let topHuman = squareLastRow[iterator]
            let bottomHuman = residue[iterator]
            
            topHuman.append(neighbor: bottomHuman.id)
            bottomHuman.append(neighbor: topHuman.id)
        }
        
        matrix.append(residue)
        
        return matrix
    }
}
