//
//  PerfectSumProblem.swift
//  AdventOfCode
//
//  Created by Marcus Gollnick on 20.11.21.
//

// https://www.geeksforgeeks.org/perfect-sum-problem-print-subsets-given-sum/

// dp[i][j] is going to store true if sum j is
// possible with array elements from 0 to i.
private var dp: [[Bool]] = []

// A recursive function to print all subsets with the
// help of dp[][]. Vector p[] stores current subset.
private func calculateSubsetsRec(arr: [Int], i: Int, sum: Int, p: inout [Int], subArrays: inout [[Int]])
{
    
    // If we reached end and sum is non-zero. We print
    // p[] only if arr[0] is equal to sum OR dp[0][sum]
    // is true.
    if (i == 0 && sum != 0 && dp[0][sum]) {
        p.append(arr[i])
        subArrays.append(p)
        p = []
        return
    }
    
    // If sum becomes 0
    if (i == 0 && sum == 0) {
        subArrays.append(p)
        p = []
        return
    }
    
    // If given sum can be achieved after ignoring
    // current element.
    if (dp[i-1][sum]) {
        // Create a new vector to store path
        var b = p
        calculateSubsetsRec(arr: arr, i: i-1, sum: sum, p: &b, subArrays: &subArrays)
    }
    
    // If given sum can be achieved after considering
    // current element.
    if (sum >= arr[i] && dp[i-1][sum-arr[i]]) {
        p.append(arr[i])
        calculateSubsetsRec(arr: arr, i: i-1, sum: sum-arr[i], p: &p, subArrays: &subArrays);
    }
}

// Prints all subsets of arr[0..n-1] with sum 0.
func perfectSumCombinations(for arr: [Int], sum: Int) -> [[Int]] {
    if (arr.count == 0 || sum < 0) {
        return []
    }
    // Sum 0 can always be achieved with 0 elements
    let inner_dp = Array(repeating: false, count: sum+1)
    dp = Array(repeating: inner_dp, count: arr.count)
    
    for i in 0..<arr.count {
        dp[i][0] = true;
    }
    
    // Sum arr[0] can be achieved with single element
    if (arr[0] <= sum) {
        dp[0][arr[0]] = true
    }
    
    // Fill rest of the entries in dp[][]
    
    for i in 1..<arr.count {
        for j in 0..<(sum+1) {
            dp[i][j] = (arr[i] <= j)
            ? (dp[i-1][j] || dp[i-1][j-arr[i]])
            : dp[i - 1][j]
        }
    }
    
    
    if (dp[arr.count-1][sum] == false) {
        print("There are no subsets with sum \(sum)")
        return []
    }
    
    // Now recursively traverse dp[][] to find all
    // paths from dp[n-1][sum]
    var subArrays: [[Int]] = []
    var p: [Int] = []
    calculateSubsetsRec(arr: arr, i: arr.count-1, sum: sum, p: &p, subArrays: &subArrays)
    return subArrays
}
