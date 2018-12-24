//: A UIKit based Playground for presenting user interface
  
import Foundation

/*:
 rawValue
 */
struct Rectangle : Equatable{
    let width: Float
    let height: Float
}

enum RectFractions{
    case whole
    case half
    case quarter
}

extension RectFractions: RawRepresentable{
    typealias RawValue = Rectangle
    
    var rawValue: Rectangle{
        switch self {
        case .whole:
            return Rectangle(width: 1, height: 1)
        case .half:
            return Rectangle(width: 0.5, height: 0.5)
        case .quarter:
            return Rectangle(width: 0.25, height: 0.25)
        }
    }
    
    init?(rawValue: RectFractions.RawValue) {
        
        switch rawValue {
        case Rectangle(width: 1, height: 1) :
            self = .whole
        case Rectangle(width: 0.5, height: 0.5) :
            self = .half
        case Rectangle(width: 0.75, height: 0.75) :
            self = .quarter
        default:
            return nil
        }
    }
}

let halfRect = RectFractions.half.rawValue
halfRect.width
halfRect.height

RectFractions(rawValue: Rectangle(width: 0.75, height: 0.75))


/*:
 associated values
 */
enum LoginState{
    case loggedOut
    case loggedIn(String)
}

extension LoginState{
    var userName : String?{
        switch self {
        case let .loggedIn(name):
            return name
        case .loggedOut:
            return nil
        }
    }
}

extension LoginState: CustomStringConvertible{
    var description: String {
        switch self {
        case .loggedOut:
            return "User is logged out"
        case .loggedIn(name: let userName):
            return "\(userName) is currently logged in"
        }
    }
}

let state = LoginState.loggedIn("mobiDevTalk")
state.userName
state.description


/*:
 hashValue
 */

enum Suits{
    case clubs
    case diamonds
    case hearts
    case spades
}
Suits.clubs.hashValue


/*:
 rawValue vs associated Values
 */
