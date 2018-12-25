import Foundation

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
