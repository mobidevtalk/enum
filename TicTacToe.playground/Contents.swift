//: A UIKit based Playground for presenting user interface
  
import Foundation
import XCTest

// MARK: - Player
enum Player {
    case First
    case Second
}

extension Player : CaseIterable{}

// MARK: - Square
enum Square {
    case One_One, One_Two, One_Three
    case Two_One, Two_Two, Two_Three
    case Three_One, Three_Two, Three_Three
}

extension Square : CaseIterable{}

extension Square: RawRepresentable{
    
    typealias Position = (row: Int, column: Int)
    
    var rawValue: Position{
        switch self {
        case .One_One: return (row: 1, column: 1)
        case .One_Two: return (row: 1, column: 2)
        case .One_Three: return (row: 1, column: 3)
            
        case .Two_One: return (row: 2, column: 1)
        case .Two_Two: return (row: 2, column: 2)
        case .Two_Three: return (row: 2, column: 3)
            
        case .Three_One: return (row: 3, column: 1)
        case .Three_Two: return (row: 3, column: 2)
        case .Three_Three: return (row: 3, column: 3)
        }
    }
    
    init?(rawValue: Position) {
        switch rawValue {
        case (row: 1, column: 1): self = .One_One
        case (row: 1, column: 2): self = .One_Two
        case (row: 1, column: 3): self = .One_Three
        
        case (row: 2, column: 1): self = .Two_One
        case (row: 2, column: 2): self = .Two_Two
        case (row: 2, column: 3): self = .Two_Three
            
        case (row: 3, column: 1): self = .Three_One
        case (row: 3, column: 2): self = .Three_Two
        case (row: 3, column: 3): self = .Three_Three
            
        default: return nil
        }
    }
}

// MARK: - Game State
enum GameState {
    case inProgress
    case draw
    case win(Player)
}

extension GameState: CaseIterable {
    static var allCases: [GameState]{
        return [.inProgress, .draw] + Player.allCases.map({ GameState.win($0) })
    }
}

extension GameState: CustomStringConvertible{
    var description: String{
        switch self {
        case .inProgress:
            return "Game is running"
        case .draw:
            return "Game ended up in a draw"
        case .win(let player):
            return "\(player) won"
        }
    }
}

extension GameState: Equatable{}

// MARK: - Game Logic
enum WinningStreak{
    case horizontal
    case vertical
    case diagonal
}

func result(for sequence: [Square]) -> WinningStreak?{
    guard sequence.count == 3, sequence[0] != sequence [1], sequence[1] != sequence[2], sequence[2] != sequence[0] else { return nil }
    
    if sequence[0].rawValue.row == sequence[1].rawValue.row && sequence[1].rawValue.row == sequence[2].rawValue.row {
        return .horizontal
    }
    
    if sequence[0].rawValue.column == sequence[1].rawValue.column && sequence[1].rawValue.column == sequence[2].rawValue.column {
        return .vertical
    }
    
    if (sequence[0].rawValue.row == sequence[0].rawValue.column && sequence[1].rawValue.row == sequence[1].rawValue.column && sequence[2].rawValue.row == sequence[2].rawValue.column) ||
        Set(arrayLiteral: sequence) == Set(arrayLiteral:  [Square.One_Three, .Two_Two, .Three_One]){
        return .diagonal
    }
    
    return nil
}

// MARK: - Game Play
class TicTacToe{
    
    
    func progress(_ square: Square) -> GameState {
        
        return .inProgress
    }
}

// MARK: - Test
class EnumTests: XCTestCase{
    func testSetup() {
        XCTAssert(true, "Things are not ok 🤯")
    }
    
    // MARK: - Game setup
    func test_twoPlayerGame() {
        XCTAssertEqual(Player.allCases.count, 2, "more or less than two player 😕")
    }

    func test_3X3_square() {
        XCTAssertEqual(Square.allCases.count, 9, "more or less than Nine square 😕")
    }
    
    func test_GameState() {
        XCTAssertEqual(GameState.allCases.count, 4, "Should only have 4 states 🎮")
    }
    
    func test_GameState_StringPresentation() {
        GameState.allCases.forEach({XCTAssertFalse($0.description.isEmpty, "Description should not be Empty")})
    }
    
    // MARK: - Game Logic
    func test_HorizontalStreak_shouldBe_HorizontalWinningCombination() {
        let allCombination: [[Square]] = [
            [.One_One, .One_Two, .One_Three],
            [.Two_One, .Two_Two, .Two_Three],
            [.Three_One, .Three_Two, .Three_Three]
        ]
        
        allCombination.forEach({ XCTAssertTrue( result(for: $0) == .horizontal, "horizontal winning combination didn't match")})
    }
    
    func test_VerticalStreak_shouldBe_VerticalWinningCombination() {
        let allCombination: [[Square]] = [
            [.One_One, .Two_One,.Three_One],
            [.One_Two, .Two_Two, .Three_Two],
            [.One_Three, .Two_Three, .Three_Three]
        ]
        
        allCombination.forEach({ XCTAssertTrue( result(for: $0) == .vertical, "vertical winning combination didn't match")})
    }
    
    func test_DiagonalStreak_shouldBe_DiagonalWinningCombination() {
        let allCombination: [[Square]] = [
            [.One_One, .Two_Two,.Three_Three],
            [.One_Three, .Two_Two, .Three_One]
        ]
        
        allCombination.forEach({ XCTAssertTrue( result(for: $0) == .diagonal, "diagonal winning combination didn't match")})
    }

    func test_sameSquareType_shouldReturnNil() {
        let allCombination: [[Square]] = [
            [.One_One, .One_One,.Three_One],
            [.One_Three, .One_Three, .One_Three]
        ]
        
        allCombination.forEach({ XCTAssertNil( result(for: $0), "Same square for result should return nil")})
    }
    
    func test_sequenceAlwaysShouldContains_ThreeElements() {
        let allCombination: [[Square]] = [
            [.One_One, .Three_One],
            [.One_Three],
            []
        ]
        
        allCombination.forEach({ XCTAssertNil( result(for: $0), "Sequece should be exact 3 elements")})
    }
    
    func test_InappropriateInput_shouldResultNil() {
        let allCombination: [[Square]] = [
            [.One_One, .One_Two, .Three_One],
            [.Two_One, .One_One, .Two_Three],
            [.Three_One, .Three_Two, .Two_One]
        ]
        
        allCombination.forEach({ XCTAssertNil( result(for: $0), "Inappropriate input should Result nil")})
    }
    
    // MARK: - Game Play
    func test_GamePlay_shouldReturn_inProgress_State_onGamePlay() {
        XCTAssertEqual(TicTacToe().progress(.One_One), GameState.inProgress, "Default progress should be inProgress")
    }
    func test_gamePlay_draw() {
        
        
    }
    
}

class TestObserver: NSObject, XCTestObservation {
    func testCase(_ testCase: XCTestCase,
                  didFailWithDescription description: String,
                  inFile filePath: String?,
                  atLine lineNumber: Int) {
        assertionFailure(description, line: UInt(lineNumber))
    }
}
let testObserver = TestObserver()
XCTestObservationCenter.shared.addTestObserver(testObserver)
EnumTests.defaultTestSuite.run()
