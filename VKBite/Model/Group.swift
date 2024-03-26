import Foundation

struct Group {
    // MARK: Properties
    var humans: [[Human]] = []
    
    // MARK: Initialize
    init(size: Int) {
        self.humans = getGroup(with: size.getMaxRectangle())
    }
}

// MARK: - Methods
private extension Group {
    func getGroup(with pattern: (height: Int, residue: Int)) -> [[Human]] {
        var matrix: [[Human]] = []
        
        guard pattern.height != 0 else { return matrix }
        
        var height = pattern.height
        let width = height / 2
        var residue = pattern.residue
        
        while residue > width {
            residue -= width
            height += 1
        }
        
        // Setup square
        for rowIterator in 0..<height {
            var row: [Human] = []
            
            for columnIterator in 0..<width {
                let human = Human(id: UUID())
                
                if rowIterator != 0 {
                    let topNeighbor = matrix[rowIterator - 1][columnIterator]
                    topNeighbor.append(neighbor: human.id)
                    human.append(neighbor: topNeighbor.id)
                }
                
                if columnIterator != 0 {
                    let leftNeighbor = row[columnIterator - 1]
                    leftNeighbor.append(neighbor: human.id)
                    human.append(neighbor: leftNeighbor.id)
                }
                
                row.append(human)
            }
            
            matrix.append(row)
        }
        
        // Setup residue
        var residueRow: [Human] = []
        
        for iterator in 0..<residue {
            let human = Human(id: UUID())
            
            if iterator != 0 {
                let leftNeighbor = residueRow[iterator - 1]
                leftNeighbor.append(neighbor: human.id)
                human.append(neighbor: leftNeighbor.id)
            }
            
            residueRow.append(human)
        }
        
        // Merge square and residue
        let squareLastRow = matrix[height - 1]
        
        for iterator in 0..<residueRow.count {
            let topHuman = squareLastRow[iterator]
            let bottomHuman = residueRow[iterator]
            
            topHuman.append(neighbor: bottomHuman.id)
            bottomHuman.append(neighbor: topHuman.id)
        }
        
        matrix.append(residueRow)
        
        return matrix
    }
}
