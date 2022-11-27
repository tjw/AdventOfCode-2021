//
//  Input.swift
//
//  Created by Timothy Wood on 11/26/22.
//

import Foundation

enum Input {
    static var lines: [String] {
        let processName = ProcessInfo().processName
        let base = URL(fileURLWithPath: #file).deletingLastPathComponent().deletingLastPathComponent()
        let inputURL = base.appendingPathComponent(processName).appendingPathComponent("input.txt")

        let inputData = try! Data(contentsOf: inputURL, options: [])
        return String(data: inputData, encoding: .utf8)!.split(separator: "\n").map { String($0) }
    }
}
