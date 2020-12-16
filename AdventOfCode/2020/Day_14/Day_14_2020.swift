//
//  Day_14.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 04.12.20.
//

// https://adventofcode.com/2020/day/14

enum Day_14_2020: Solvable {
    static var day: Input.Day = .Day_14
    static var year: Input.Year = .Year_2020

    static func solvePart1(input: [String]) -> String {
        var mask: Array<String.Element> = []
        var mem: Dictionary<String, UInt64> = [:]
        for line in input {
            let cmp = line.components(separatedBy: " = ")
            guard cmp.first != "mask" else {
                let tmpMask = cmp.last ?? ""
                mask = Array(tmpMask).reversed()
                continue
            }

            guard let value = UInt64(cmp.last ?? ""),
                  let keyTmp = cmp.first?.dropFirst(4).dropLast() else {
                fatalError("No Value found")
            }

            let memKey = String(keyTmp)
            mem[memKey] = applyMaskToValue(value, mask)
        }

        var sum: UInt64 = 0
        mem.forEach { (key, value) in
            sum += value
        }
        return "\(sum)"
    }

    static func solvePart2(input: [String]) -> String {
        var mask: Array<String.Element> = []
        var mem: Dictionary<Int, UInt64> = [:]
        for line in input {
            let cmp = line.components(separatedBy: " = ")
            guard cmp.first != "mask" else {
                let tmpMask = cmp.last ?? ""
                mask = Array(tmpMask).reversed()
                continue
            }

            guard let addressTmp = cmp.first?.dropFirst(4).dropLast(),
                  let address = UInt64(addressTmp) else {
                fatalError("No Address found")
            }

            let newAddress = applyMaskToAddress(address, mask)
            let addresses = getAllAddressesFor(newAddress)
            for address in addresses {
                guard let value = Int(address, radix: 2) else {
                    fatalError("Address is not valid")
                }
                mem[value] = UInt64(cmp.last ?? "")
            }
        }
        var sum: UInt64 = 0
        mem.forEach { (key, value) in
            sum += value
        }
        return "\(sum)"
    }

    static func applyMaskToValue(_ value: UInt64, _ mask: Array<String.Element>) -> UInt64 {
        var newValue = ""
        let arrValue: Array<String.Element> = Array(String(value, radix: 2)).reversed()
        var savedIndex = 0
        for (index, bit) in arrValue.enumerated() {
            let maskBit = mask[index]
            switch maskBit {
            case "X":
                newValue = String(bit) + newValue
            case "0":
                newValue = "0" + newValue
            case "1":
                newValue = "1" + newValue
            default:
                fatalError("Should not be executed")
            }
            savedIndex = index
        }

        for i in (savedIndex + 1) ..< mask.count {
            if mask[i] == "X" {
                newValue = "0" + newValue
            } else {
                newValue = String(mask[i]) + newValue
            }
        }

        guard newValue.count == 36 else {
            fatalError("New Value has not the right size")
        }

        guard let intValue = UInt64(newValue, radix: 2) else {
            fatalError("No Value can be formed")
        }

        return  intValue
    }

    static func applyMaskToAddress(_ address: UInt64, _ mask: Array<String.Element>) -> String {
        var newAddress = ""
        let arrAddress: Array<String.Element> = Array(String(address, radix: 2)).reversed()
        var savedIndex = 0
        for (index, bit) in arrAddress.enumerated() {
            let maskBit = mask[index]
            switch maskBit {
            case "X":
                newAddress = "X" + newAddress
            case "0":
                newAddress = String(bit) + newAddress
            case "1":
                newAddress = "1" + newAddress
            default:
                fatalError("Should not be executed")
            }
            savedIndex = index
        }

        for i in (savedIndex + 1) ..< mask.count {
            newAddress = String(mask[i]) + newAddress
        }

        guard newAddress.count == 36 else {
            fatalError("New Value has not the right size")
        }

        return  newAddress
    }

    static func getAllAddressesFor(_ address: String) -> Array<String> {
        var newAddresses: Array<String> = [address]
        var xRemain = true
        while xRemain {
            outerLoop: for address in newAddresses {
                for (index, c) in Array(address).enumerated() {
                    if c == "X" {
                        var newAddress = Array(address)
                        newAddress[index] = "0"
                        newAddresses.append(String(newAddress))
                        newAddress[index] = "1"
                        newAddresses.append(String(newAddress))
                        newAddresses.remove(at: 0)
                        continue outerLoop
                    }
                }
            }
            for address in newAddresses {
                if !address.contains("X") {
                    xRemain = false
                }
            }
        }




        return newAddresses
    }
}


// 12607777229252 -> To low
