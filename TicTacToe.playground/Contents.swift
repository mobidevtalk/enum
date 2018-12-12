//: A UIKit based Playground for presenting user interface
  
import Foundation
import XCTest

// MARK: - TicTacToe
class TicTacToe{
    enum Player {
        case First
        case Second
    }
    
    enum Square {
        case One_One, One_Two, One_Three
        case Two_One, Two_Two, Two_Three
        case Three_one, Three_Two, Three_Three
    }
    
    enum GameState {
        case inProgress
        case draw
        case win(Player)
    }
}


// MARK: - CaseIterable
extension TicTacToe.Player : CaseIterable{}

extension TicTacToe.Square : CaseIterable{}

extension TicTacToe.GameState: CaseIterable {
    static var allCases: [TicTacToe.GameState]{
        return [.inProgress, .draw] + TicTacToe.Player.allCases.map({ TicTacToe.GameState.win($0) })
    }
}

extension TicTacToe.GameState: CustomStringConvertible{
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

// MARK: - Test
class EnumTests: XCTestCase{
    func testSetup() {
        XCTAssert(true, "Things are not ok 🤯")
    }
    
    // MARK: - Game setup
    func test_twoPlayerGame() {
        XCTAssertEqual(TicTacToe.Player.allCases.count, 2, "more or less than two player 😕")
    }

    func test_3X3_square() {
        XCTAssertEqual(TicTacToe.Square.allCases.count, 9, "more or less than Nine square 😕")
    }
    
    func test_GameState() {
        XCTAssertEqual(TicTacToe.GameState.allCases.count, 4, "Should only have 4 states 🎮")
    }
    
    func test_GameState_StringPresentation() {
        TicTacToe.GameState.allCases.forEach({XCTAssertFalse($0.description.isEmpty, "Description should not be Empty")})
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
