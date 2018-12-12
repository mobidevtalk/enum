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

// MARK: - Winning combination
enum WinningCombination{
    case horizontal
    case vertical
    case diagonal
}

extension WinningCombination: RawRepresentable{
    typealias Sequence = Set<Set<Square>>
    
    var rawValue: Sequence{
        switch self {
        case .horizontal:
            return [[.One_One, .One_Two, .One_Three],
                    [.Two_One, .Two_Two, .Two_Three],
                    [.Three_One, .Three_Two, .Three_Three]]
        case .vertical:
            return [[.One_One, .Two_One, .Three_One],
                    [.One_Two, .Two_Two, .Three_Two],
                    [.One_Three, .Two_Three, .Three_Three]]
        case .diagonal:
            return [[.One_One, .Two_Two, .Three_Three],
                    [.One_Three, .Two_Two, .Three_One]]
        }
    }
    
    init?(rawValue: Sequence) {
        switch rawValue {
        case [[.One_One, .One_Two, .One_Three]],
             [[.Two_One, .Two_Two, .Two_Three]],
             [[.Three_One, .Three_Two, .Three_Three]]:
            self = .horizontal
        default:
            return nil
        }
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
    func test_EveryHorizontalRow_shouldBe_winningCombination() {
        let winningCombination: WinningCombination.Sequence = [
            [.One_One, .One_Two, .One_Three],
            [.Two_One, .Two_Two, .Two_Three],
            [.Three_One, .Three_Two, .Three_Three]
        ]

//        winningCombination.forEach({ XCTAssertEqual(WinningCombination(rawValue: $0), .horizontal) })
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
