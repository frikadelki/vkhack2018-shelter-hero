// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: MapObject.proto
//
// For information on using the generated types, please see the documenation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that your are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct Sh_Generated_MapObjectRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Sh_Generated_VenueMapObject {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var venue: Sh_Generated_Venue {
    get {return _storage._venue ?? Sh_Generated_Venue()}
    set {_uniqueStorage()._venue = newValue}
  }
  /// Returns true if `venue` has been explicitly set.
  var hasVenue: Bool {return _storage._venue != nil}
  /// Clears the value of `venue`. Subsequent reads from it will return its default value.
  mutating func clearVenue() {_uniqueStorage()._venue = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

struct Sh_Generated_ShelterMapObject {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var shelter: Sh_Generated_Shelter {
    get {return _storage._shelter ?? Sh_Generated_Shelter()}
    set {_uniqueStorage()._shelter = newValue}
  }
  /// Returns true if `shelter` has been explicitly set.
  var hasShelter: Bool {return _storage._shelter != nil}
  /// Clears the value of `shelter`. Subsequent reads from it will return its default value.
  mutating func clearShelter() {_uniqueStorage()._shelter = nil}

  var availableOrders: [Sh_Generated_ShelterOrder] {
    get {return _storage._availableOrders}
    set {_uniqueStorage()._availableOrders = newValue}
  }

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

struct Sh_Generated_MapObjectResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var shelters: [Sh_Generated_ShelterMapObject] = []

  var venues: [Sh_Generated_VenueMapObject] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "sh.generated"

extension Sh_Generated_MapObjectRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".MapObjectRequest"
  static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Sh_Generated_MapObjectRequest, rhs: Sh_Generated_MapObjectRequest) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Sh_Generated_VenueMapObject: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".VenueMapObject"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "venue"),
  ]

  fileprivate class _StorageClass {
    var _venue: Sh_Generated_Venue? = nil

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _venue = source._venue
    }
  }

  fileprivate mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        switch fieldNumber {
        case 1: try decoder.decodeSingularMessageField(value: &_storage._venue)
        default: break
        }
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if let v = _storage._venue {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Sh_Generated_VenueMapObject, rhs: Sh_Generated_VenueMapObject) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._venue != rhs_storage._venue {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Sh_Generated_ShelterMapObject: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ShelterMapObject"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "shelter"),
    2: .same(proto: "availableOrders"),
  ]

  fileprivate class _StorageClass {
    var _shelter: Sh_Generated_Shelter? = nil
    var _availableOrders: [Sh_Generated_ShelterOrder] = []

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _shelter = source._shelter
      _availableOrders = source._availableOrders
    }
  }

  fileprivate mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        switch fieldNumber {
        case 1: try decoder.decodeSingularMessageField(value: &_storage._shelter)
        case 2: try decoder.decodeRepeatedMessageField(value: &_storage._availableOrders)
        default: break
        }
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if let v = _storage._shelter {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
      }
      if !_storage._availableOrders.isEmpty {
        try visitor.visitRepeatedMessageField(value: _storage._availableOrders, fieldNumber: 2)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Sh_Generated_ShelterMapObject, rhs: Sh_Generated_ShelterMapObject) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._shelter != rhs_storage._shelter {return false}
        if _storage._availableOrders != rhs_storage._availableOrders {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Sh_Generated_MapObjectResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".MapObjectResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "shelters"),
    2: .same(proto: "venues"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeRepeatedMessageField(value: &self.shelters)
      case 2: try decoder.decodeRepeatedMessageField(value: &self.venues)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.shelters.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.shelters, fieldNumber: 1)
    }
    if !self.venues.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.venues, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Sh_Generated_MapObjectResponse, rhs: Sh_Generated_MapObjectResponse) -> Bool {
    if lhs.shelters != rhs.shelters {return false}
    if lhs.venues != rhs.venues {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
