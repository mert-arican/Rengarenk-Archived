//
//  Grid.swift
//  Color Coded
//
//  Created by Mert Arıcan on 10.11.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

class Grid {
    struct GridPosition {
        let coordinate: (row: Int, col: Int)
        let frame: CGRect
    }
    
    init(bounds: CGRect, cellCount: Int) {
        self.bounds = bounds ; self.cellCount = cellCount ; getGrid()
    }
    
    subscript(index: Int) -> GridPosition { rects[index] }
    
    var gridPosition: GridPosition { rects.popLast() ?? basic }
    var currentLetterLength: CGFloat { rects.first?.frame.width ?? 0.0 }
    
    func setCellCount(_ count: Int) {
        self.cellCount = count ; getGrid()
    }
    
    func getGridPosition(atCoordinate coordinate: (Int, Int)) -> GridPosition {
        backup.first(where: { $0.coordinate == coordinate }) ?? basic
    }
    
    private var bounds: CGRect
    private var cellCount: Int
    private let standartCellWidth: CGFloat = DesignConstants.standartSizeForLetter.width
    private var spacing: CGFloat = UserPreferences.flyingModeIsActive ? (DesignConstants.spacing + (isPad ? 7.0 : 4.0)) : 4.0
    private var cellWidth: CGFloat = DesignConstants.standartSizeForLetter.width
    private var horizontalOffset: CGFloat = 0.0
    
    private var horizontalCount = 0
    private var verticalCount = 0
    
    private var rects = [GridPosition]()
    private var backup = [GridPosition]()
    
    private var basic: GridPosition {
        return GridPosition(coordinate: (0, 0), frame: .init(origin: self.bounds.origin, size: CGSize(squareWith: cellWidth)))
    }
    
    private func isValidWidth() -> Bool {
        let x = Int((bounds.width + spacing) / (cellWidth + spacing))
        let y = Int((bounds.height + spacing) / (cellWidth + spacing))
        horizontalCount = x ; verticalCount = y
        return x*y >= self.cellCount
    }
    
    private func getBiggestPossibleWidth() {
        cellWidth = standartCellWidth
        while !isValidWidth() { cellWidth -= 1 }
        let horizontalCount = CGFloat(self.horizontalCount)
        horizontalOffset = (bounds.width - (((horizontalCount-1) * (spacing)) + (horizontalCount * cellWidth))) / 2
    }
    
    private func getOriginForGrid() -> CGPoint {
        return .init(x: horizontalOffset, y: bounds.maxY - cellWidth - spacing)
    }
    
    private func getGrid() {
        getBiggestPossibleWidth()
        let origin = getOriginForGrid()
        let size = CGSize(squareWith: cellWidth)
        DesignConstants.scaleForFlies = cellWidth / DesignConstants.standartSizeForLetter.width
        for index in 0..<cellCount {
            let row = index / horizontalCount
            let col = index % horizontalCount
            
            let verticalOffset = CGFloat(row) * cellWidth + ((CGFloat(row)-1)*spacing) + spacing
            let horizontalOffset = CGFloat(col) * cellWidth + ((CGFloat(col))*spacing)
            
            let org = origin.offsetBy(dx: horizontalOffset, dy: -verticalOffset)
            let gridPos = GridPosition(coordinate: (row: row, col: col), frame: CGRect(origin: org, size: size))
            rects.append(gridPos) ; backup.append(gridPos)
        }
        rects.reverse() ; backup.reverse()
    }
}
