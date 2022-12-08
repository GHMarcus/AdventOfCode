//
//  Day_7.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2022/day/7

enum Day_7_2022: Solvable {
    static var day: Input.Day = .Day_7
    static var year: Input.Year = .Year_2022
    
    enum LogLine {
        case command(Command)
        case output(Output)
    }
    
    enum Command {
        case changeDirectory(String)
        case listFiles
        
        init?(from str: String) {
            if str.contains("$") {
                let cmp = str.components(separatedBy: " ")
                switch cmp[1] {
                case "ls":
                    self = .listFiles
                case "cd":
                    self = .changeDirectory(cmp[2])
                default:
                    return nil
                }
            } else {
                return nil
            }
        }
    }
    
    enum Output {
        case directory
        case file(File)
        
        init?(from str: String) {
            let cmp = str.components(separatedBy: " ")
            switch cmp[0] {
            case "$":
                return nil
            case "dir":
                self = .directory
            default:
                let file = File(name: cmp[1], size: Int(cmp[0])!)
                self = .file(file)
            }
        }
    }
    
    class File {
        let name: String
        let size: Int

        init(name: String, size: Int) {
            self.name = name
            self.size = size
        }
    }

    class Directory {
        let name: String
        var parent: Directory?
        var subDirectories: [Directory]
        var files: [File]

        init(name: String, parent: Directory? = nil, subDirectories: [Directory] = [], files: [File] = []) {
            self.name = name
            self.parent = parent
            self.subDirectories = subDirectories
            self.files = files
        }

        var size: Int {
            let fileSize = files.reduce(0) { partialResult, file in
                partialResult + file.size
            }

            let dirSize = subDirectories.reduce(0) { partialResult, dir in
                partialResult + dir.size
            }

            return fileSize + dirSize
        }
    }

    static func solvePart1(input: [String]) -> String {
        
        let startDirectory = createFileTree(for: input)

        let sum = sumOfSmallDirectories(for: startDirectory)
        
        printFileTree(form: startDirectory, with: 0)

        return "\(sum)"
    }

    static func solvePart2(input: [String]) -> String {
        
        let startDirectory = createFileTree(for: input)

        let sizeWhichMustBeDeleted = abs(40000000 - (startDirectory.size))

        let directoriesToDelete = findDirectoriesToDelete(for: sizeWhichMustBeDeleted, in: startDirectory)
        
        let smallestDir = directoriesToDelete.sorted {
            $0.size < $1.size
        }.first!

        return "\(smallestDir.size)"
    }
    
    private static func createFileTree(for input: [String]) -> Directory {
        var startDirectory: Directory?
        var currentDir: Directory?
        
        let convertedInput: [LogLine] = input.compactMap {
            if let command = Command(from: $0) {
                return .command(command)
            } else if let output = Output(from: $0) {
                return .output(output)
            } else {
                return nil
            }
        }
        
        for line in convertedInput {
            switch line {
            case .command(let command):
                switch command {
                case .changeDirectory(let name):
                    if name == ".." {
                        currentDir = currentDir?.parent
                    } else {
                        let newDir = Directory(name: name, parent: currentDir)
                        currentDir?.subDirectories.append(newDir)
                        currentDir = newDir
                        if startDirectory == nil {
                            startDirectory = newDir
                        }
                    }
                case .listFiles:
                    continue
                }
            case .output(let output):
                switch output {
                case .file(let file):
                    currentDir?.files.append(file)
                case .directory:
                    continue
                }
            }
        }
        
        return startDirectory!
    }

    private static func sumOfSmallDirectories(for directory: Directory) -> Int {
        var ownSize = 0
        if directory.size > 100000 {
            ownSize = 0
        } else {
            ownSize = directory.size
        }

        let subDirectorySize = directory.subDirectories.reduce(0) { partialResult, subDirectory in
            partialResult + sumOfSmallDirectories(for: subDirectory)
        }

        return ownSize + subDirectorySize
    }

    private static func findDirectoriesToDelete(for minSizeToDelete: Int, in directory: Directory) -> [Directory] {
        if directory.size < minSizeToDelete {
            return []
        } else {
            var newFound = [directory]
            newFound += directory.subDirectories.reduce([], { partialResult, subDirectory in
                partialResult + findDirectoriesToDelete(for: minSizeToDelete, in: subDirectory)
            })
            return newFound
        }
    }
    
    private static func printFileTree(form directory: Directory, with depth: Int) {
        let indentation = Array(repeating: "  ", count: depth).joined()
        print(indentation + "- \(directory.name) (dir)")
        if directory.subDirectories.isEmpty {
            directory.files.forEach {
                print(indentation + "  - \($0.name) (file, size:\($0.size))")
            }
        } else {
            directory.subDirectories.forEach {
                printFileTree(form: $0, with: (depth+1))
            }
            directory.files.forEach {
                print(indentation + "  - \($0.name) (file, size:\($0.size))")
            }
        }
    }
}
