import Foundation

/*:
 Generic enum
 */
enum Status<T: CustomStringConvertible>{
    case success(T)
    case failed
}

extension Status{
    var description: String{
        switch self {
        case .success(let text):
            return text.description
        case .failed:
            return "Failed...."
        }
    }
}

Status.success("Good to go").description
Status.success(5).description

/*:
 Error definition through enum
 */
enum Mismatched : String{
    case notFound
    case undefined
    case invalid
}

extension Mismatched: Error{}

func find(text: String?, on sentence: String?) throws {
    guard let text = text, text.count > 0 else { throw Mismatched.undefined }
    guard let sentence = sentence, sentence.count > 0 else { throw Mismatched.invalid }
    
    if !sentence.contains(text) { throw Mismatched.notFound }
}

do {
    try find(text: nil, on: "Some input")
} catch Mismatched.undefined { Mismatched.undefined.rawValue }

do {
    try find(text: "any", on: nil)
} catch Mismatched.invalid { Mismatched.invalid.rawValue }

do {
    try find(text: "any", on: "Nothing is here")
} catch Mismatched.notFound { Mismatched.notFound.rawValue }

do {
    try find(text: "any", on: "any")
    "Gotcha"
} catch Mismatched.notFound { Mismatched.notFound.rawValue }

/*:
 Enum mutation, code smelling
 */
enum State{
    case notConnected
    case connecting
    case disconnected
    case connected(String)
    
    indirect case currentState(State)
}

extension State{
    mutating func updateCurrentState(state: State) {
        self = .currentState(state)
    }
}

var state = State.connecting
state.updateCurrentState(state: .connected("Oh ya"))

/*:
 Recursive enum
 */
indirect enum Buffer{
    case data(String)
    case append(Buffer, Buffer, Buffer)
}

extension Buffer{
    func convert() -> String {
        switch self {
        case .data(let text):
            return text
        case .append(let appendedBuffer):
            return appendedBuffer.0.convert() + " " + appendedBuffer.1.convert() + " " + appendedBuffer.2.convert()
        }
    }
}

let mobi = Buffer.data("Mobile")
let dev = Buffer.data("development")
let talk = Buffer.data("talk")

let mobiDevTalk = Buffer.append(mobi, dev, talk)
mobiDevTalk.convert()

/*:
 allCases of CaseIterable
 */
enum Direction{
    case north
    case south
    case east
    case west
}
extension Direction: CaseIterable{}
Direction.allCases
