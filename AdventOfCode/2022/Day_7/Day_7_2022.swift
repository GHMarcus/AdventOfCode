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

    static var dirsToDelete: [Dir] = []

    class File {
        let name: String
        let size: Int

        init(name: String, size: Int) {
            self.name = name
            self.size = size
        }
    }

    class Dir {
        let name: String
        var parent: Dir?
        var subDirs: [Dir]
        var files: [File]

        init(name: String, parent: Dir? = nil, subDirs: [Dir], files: [File]) {
            self.name = name
            self.parent = parent
            self.subDirs = subDirs
            self.files = files
        }

        var size: Int {
            let fileSize = files.reduce(0) { partialResult, file in
                partialResult + file.size
            }

            let dirSize = subDirs.reduce(0) { partialResult, dir in
                partialResult + dir.size
            }

            return fileSize + dirSize
        }
    }

    static func solvePart1(input: [String]) -> String {
        var startDir: Dir?
        var currentDir: Dir?

        for line in input {
            if line.contains("$") {
                if line.contains("cd") && !line.contains(".."){
                    let newDir = Dir(
                        name: line.components(separatedBy: " ")[2],
                        parent: currentDir,
                        subDirs: [],
                        files: []
                    )
                    currentDir?.subDirs.append(newDir)
                    currentDir = newDir
                    if newDir.name == "/" {
                        startDir = newDir
                    }
                } else if line.contains("cd") {
                    currentDir = currentDir?.parent
                } else if line.contains("ls") {
                    continue
                }
            } else {
                if !line.contains("dir") {
                    let cmp = line.components(separatedBy: " ")
                    let newFile = File(name: cmp[1], size: Int(cmp[0])!)
                    currentDir?.files.append(newFile)
                }

            }
        }

        let sum = startDir?.subDirs.reduce(0, { partialResult, dir in
            partialResult + sumOfSmallDirs(dir: dir)
        })


        return "\(sum ?? -1)"
    }

    static func solvePart2(input: [String]) -> String {
        var startDir: Dir?
        var currentDir: Dir?

        for line in input {
            if line.contains("$") {
                if line.contains("cd") && !line.contains(".."){
                    let newDir = Dir(
                        name: line.components(separatedBy: " ")[2],
                        parent: currentDir,
                        subDirs: [],
                        files: []
                    )
                    currentDir?.subDirs.append(newDir)
                    currentDir = newDir
                    if newDir.name == "/" {
                        startDir = newDir
                    }
                } else if line.contains("cd") {
                    currentDir = currentDir?.parent
                } else if line.contains("ls") {
                    continue
                }
            } else {
                if !line.contains("dir") {
                    let cmp = line.components(separatedBy: " ")
                    let newFile = File(name: cmp[1], size: Int(cmp[0])!)
                    currentDir?.files.append(newFile)
                }

            }
        }

        let sizeWhichMustBeDeleted = abs(40000000 - (startDir?.size ?? 0))
        print(sizeWhichMustBeDeleted)

        findDirsToDelete(minSizeToDelete: sizeWhichMustBeDeleted, dir: startDir!)

        let smalestDir = dirsToDelete.sorted {
            $0.size < $1.size
        }.first!

        return "\(smalestDir.name): \(smalestDir.size)"
    }

    static func sumOfSmallDirs(dir: Dir) -> Int {
        var ownSize = 0
        if dir.size > 100000 {
            ownSize = 0
        } else {
            ownSize = dir.size
        }

        let subDirSize = dir.subDirs.reduce(0) { partialResult, dir in
            partialResult + sumOfSmallDirs(dir: dir)
        }

        return ownSize + subDirSize
    }

    static func findDirsToDelete(minSizeToDelete: Int, dir: Dir) {
        if dir.size < minSizeToDelete {
            return
        } else {
            dirsToDelete.append(dir)
            dir.subDirs.forEach { dir in
                findDirsToDelete(minSizeToDelete: minSizeToDelete, dir: dir)
            }
        }
    }
}
