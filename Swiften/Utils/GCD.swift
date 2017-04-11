//
//  GCD.swift
//  Swiften
//
//  Created by Cator Vee on 10/03/2017.
//  Copyright © 2017 Cator Vee. All rights reserved.
//

import Foundation

/// 延迟执行代码（秒）
public func delay(seconds: Int, execute: @escaping () -> Void) {
	DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds), execute: execute)
}

/// 延迟执行代码（毫秒）
public func delay(milliseconds ms: Int, task: @escaping () -> Void) {
	DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(ms), execute: task)
}

/// 异步执行代码块（先非主线程执行，再返回主线程执行）
public func async<T>(background backgroundTask: @escaping () -> T?, main mainTask: @escaping (T?) -> Void) {
	DispatchQueue.global(qos: .utility).async {
		let result = backgroundTask()
		DispatchQueue.main.sync {
			mainTask(result)
		}
	}
}

/// 异步执行代码块（主线程执行）
public func async(execute: @escaping () -> Void) {
	DispatchQueue.main.async(execute: execute)
}
