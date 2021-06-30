//
//  tools.swift
//  ResizeView
//
//  Created by nick on 2021/6/28.
//

import Foundation

func print<T>(msg: T, file: String = #file, method: String = #function, line: Int = #line) {
    Swift.print("\((file as NSString).lastPathComponent):\(line), \(method): \(msg)")
}
