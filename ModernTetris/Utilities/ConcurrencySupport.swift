//
//  ConcurrencySupport.swift
//  SamoTetris
//
//  Created on 2026-01-03
//

import Foundation
import Combine

// Suppress concurrency warnings for Combine framework
@available(iOS 13.0, *)
extension Publisher {
    @_disfavoredOverload
    public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        self.receive(subscriber: subscriber)
    }
}
