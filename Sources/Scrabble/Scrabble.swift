import Foundation

enum WordError : Error {
case doesNotContainOnlyLetters
}

let tileScore  = ["a": 1, "c": 3, "b": 3, "e": 1, "d": 2, "g": 2,
"f": 4, "i": 1, "h": 4, "k": 5, "j": 8, "m": 3,
"l": 1, "o": 1, "n": 1, "q": 10, "p": 3, "s": 1,
"r": 1, "u": 1, "t": 1, "w": 4, "v": 4, "y": 4,
"x": 8, "z": 10]

public struct Word: Equatable, Comparable, CustomStringConvertible {
  var score: Int
  var word: String
  public var description: String {
    return "\(self.word) \(self.score)\n"
  }
  var letterCount: [Character:Int] = [:]
  public static var wordList: [Word] {
    get {
      var wordList: [Word] = []
      do {
        // Make sure the importing module has this file in its root directory
        // Bad practice, but can't find information on how to use relative path within imported module
        // Maybe I can export the file as a dependency? I don't know.
        let commonWordFile = try String(contentsOfFile: "3letter_words.txt")
        for line in commonWordFile.components(separatedBy: CharacterSet.newlines) {
          if line.count > 0 {
            let rangeWord = line.startIndex..<line.index(line.startIndex, offsetBy: 3)
            let word = line[rangeWord]
            do {
              try wordList.append(Word(word: String(word)))
            }
            catch {
              throw error
            }
          }
        }
      }
      catch {
        print("Error: \(error)")
      }
      return wordList
    }
  }

  public init(word: String) throws {
    self.word = word.uppercased()
    var sum = 0
    let characters = Array(self.word)
    for char in characters {
      guard tileScore[String(char).lowercased()] != nil else {
        throw WordError.doesNotContainOnlyLetters
      }
      sum +=  tileScore[String(char).lowercased()]!
      if letterCount[char] == nil {
        letterCount[char] = 1
      }
      else {
        letterCount[char]! += 1
      }
    }
    self.score = sum
  }

  public static func == (lhs: Word, rhs: Word) -> Bool {
    return lhs.score == rhs.score
  }

  public static func < (lhs: Word, rhs: Word) -> Bool {
    return lhs.score < rhs.score
  }
}

public func isSubset(rack: Word, threeLetter: Word) -> Bool {
  for pair in threeLetter.letterCount {
    if let rackCount = rack.letterCount[pair.key] {
      if let wordCount = threeLetter.letterCount[pair.key] {
        if rackCount >= wordCount {
          continue
        }
        else {
          return false
        }
      }
      else {
        return false
      }
    }
    else {
      return false
    }
  }
  return true
}
