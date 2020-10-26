//
//  Protocols.swift
//  Sunflower
//
//  Created by Intersectional Bijection on 10/25/20.
//

import Foundation

// ----------- Mutation of types --------------//
protocol Readable {
   var getters: Dictionary<String, () -> Any> { get }
}
protocol Mutable: Readable {
   mutating func mutate(by closure: (inout Self) throws -> Self) rethrows
}

// ----------- Wrapping --------------//
protocol Container {
   associatedtype Content
}
protocol HasExposedContent where Self: Container {
   func getContent () throws -> Self.Content
}

// ----------- Objects with state --------------//
protocol Stateful {
   associatedtype State
}
protocol HasExposedState where Self: Stateful {
   func getState () throws -> Self.State
}

// ----------- Generative entities --------------//
protocol GeneratingObject {
   associatedtype GeneratedInstance
   associatedtype Arguments
   associatedtype Generator
   mutating func generateConsequentRepresentation
   (with arguments: Arguments) throws -> GeneratedInstance
}
protocol HasExposedGenerator where Self: GeneratingObject {
   var generator: Generator { get }
}
protocol UnfoldingObject: GeneratingObject where Self.Generator: Stateful {
   associatedtype Snapshot
   func getCurrentRepresentation () -> Snapshot
}

// ----------- Conversion --------------//
///Intended to be used when, given two instances of types A and B
///You could turn A into B, and later B into A without loss of additional information
///Think of it like T: Container, HasMetadata  where producing new type
///preserves both metadata and content. Content and Metadata are 'essential'.
protocol LosslesslyConstructible {
   associatedtype Data
   init (from data: Data) throws
}
///Has simmilar purpose as LosslesslyConstructible but Metadata is not inportant part and thus lost in
///conversion .
protocol LosslyConstructible {
   associatedtype Data
   init (from data: Data) throws
}
protocol LosslesslyConvertible {
   associatedtype Target
   associatedtype InvokationArguments
   mutating func performConversion
   (_ invokationArgs: InvokationArguments) throws -> Target
}
protocol LosslyConvertible {
   associatedtype Target
   associatedtype InvokationArguments
   mutating func performConversion
   (_ invokationArgs: InvokationArguments) throws -> Target
}

// -----------  --------------//


// ----------- Session --------------//
protocol Session {
   associatedtype Arguments
   static func makeNew (arguments: Arguments) throws
}

// ----------- Compression --------------//
protocol Compresible where Self: Container, Self.Content: Compresible {
   mutating func compress () throws
}
protocol HasExposedCompressor where Self: Compresible {
   associatedtype Compressor
   var compressor: Compressor { get }
}
