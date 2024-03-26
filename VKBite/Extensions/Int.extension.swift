import Foundation

extension Int {
    func getMinSquareWithResidue() -> (square: Int, residue: Int) {
        let squareRoot = Int(sqrt(Double(self)))
        let residue = self - squareRoot * squareRoot
        return (squareRoot, residue)
    }
}
