// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: Shelter.proto
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

struct Sh_Generated_Shelter {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var id: Int32 {
    get {return _storage._id}
    set {_uniqueStorage()._id = newValue}
  }

  var coordinate: Sh_Generated_GeoPoint {
    get {return _storage._coordinate ?? Sh_Generated_GeoPoint()}
    set {_uniqueStorage()._coordinate = newValue}
  }
  /// Returns true if `coordinate` has been explicitly set.
  var hasCoordinate: Bool {return _storage._coordinate != nil}
  /// Clears the value of `coordinate`. Subsequent reads from it will return its default value.
  mutating func clearCoordinate() {_uniqueStorage()._coordinate = nil}

  var iconName: String {
    get {return _storage._iconName}
    set {_uniqueStorage()._iconName = newValue}
  }

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

struct Sh_Generated_ShelterOrder {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var title: String {
    get {return _storage._title}
    set {_uniqueStorage()._title = newValue}
  }

  var description_p: String {
    get {return _storage._description_p}
    set {_uniqueStorage()._description_p = newValue}
  }

  var tags: [String] {
    get {return _storage._tags}
    set {_uniqueStorage()._tags = newValue}
  }

  var shelter: Sh_Generated_Shelter {
    get {return _storage._shelter ?? Sh_Generated_Shelter()}
    set {_uniqueStorage()._shelter = newValue}
  }
  /// Returns true if `shelter` has been explicitly set.
  var hasShelter: Bool {return _storage._shelter != nil}
  /// Clears the value of `shelter`. Subsequent reads from it will return its default value.
  mutating func clearShelter() {_uniqueStorage()._shelter = nil}

  var demands: [Sh_Generated_ShelterDemand] {
    get {return _storage._demands}
    set {_uniqueStorage()._demands = newValue}
  }

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

struct Sh_Generated_ShelterDemand {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var text: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "sh.generated"

extension Sh_Generated_Shelter: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Shelter"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "id"),
    2: .same(proto: "coordinate"),
    3: .same(proto: "iconName"),
  ]

  fileprivate class _StorageClass {
    var _id: Int32 = 0
    var _coordinate: Sh_Generated_GeoPoint? = nil
    var _iconName: String = String()

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _id = source._id
      _coordinate = source._coordinate
      _iconName = source._iconName
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
        case 1: try decoder.decodeSingularInt32Field(value: &_storage._id)
        case 2: try decoder.decodeSingularMessageField(value: &_storage._coordinate)
        case 3: try decoder.decodeSingularStringField(value: &_storage._iconName)
        default: break
        }
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if _storage._id != 0 {
        try visitor.visitSingularInt32Field(value: _storage._id, fieldNumber: 1)
      }
      if let v = _storage._coordinate {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
      }
      if !_storage._iconName.isEmpty {
        try visitor.visitSingularStringField(value: _storage._iconName, fieldNumber: 3)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Sh_Generated_Shelter, rhs: Sh_Generated_Shelter) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._id != rhs_storage._id {return false}
        if _storage._coordinate != rhs_storage._coordinate {return false}
        if _storage._iconName != rhs_storage._iconName {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Sh_Generated_ShelterOrder: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ShelterOrder"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "title"),
    2: .same(proto: "description"),
    3: .same(proto: "tags"),
    4: .same(proto: "shelter"),
    5: .same(proto: "demands"),
  ]

  fileprivate class _StorageClass {
    var _title: String = String()
    var _description_p: String = String()
    var _tags: [String] = []
    var _shelter: Sh_Generated_Shelter? = nil
    var _demands: [Sh_Generated_ShelterDemand] = []

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _title = source._title
      _description_p = source._description_p
      _tags = source._tags
      _shelter = source._shelter
      _demands = source._demands
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
        case 1: try decoder.decodeSingularStringField(value: &_storage._title)
        case 2: try decoder.decodeSingularStringField(value: &_storage._description_p)
        case 3: try decoder.decodeRepeatedStringField(value: &_storage._tags)
        case 4: try decoder.decodeSingularMessageField(value: &_storage._shelter)
        case 5: try decoder.decodeRepeatedMessageField(value: &_storage._demands)
        default: break
        }
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if !_storage._title.isEmpty {
        try visitor.visitSingularStringField(value: _storage._title, fieldNumber: 1)
      }
      if !_storage._description_p.isEmpty {
        try visitor.visitSingularStringField(value: _storage._description_p, fieldNumber: 2)
      }
      if !_storage._tags.isEmpty {
        try visitor.visitRepeatedStringField(value: _storage._tags, fieldNumber: 3)
      }
      if let v = _storage._shelter {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 4)
      }
      if !_storage._demands.isEmpty {
        try visitor.visitRepeatedMessageField(value: _storage._demands, fieldNumber: 5)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Sh_Generated_ShelterOrder, rhs: Sh_Generated_ShelterOrder) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._title != rhs_storage._title {return false}
        if _storage._description_p != rhs_storage._description_p {return false}
        if _storage._tags != rhs_storage._tags {return false}
        if _storage._shelter != rhs_storage._shelter {return false}
        if _storage._demands != rhs_storage._demands {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Sh_Generated_ShelterDemand: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ShelterDemand"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "text"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularStringField(value: &self.text)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.text.isEmpty {
      try visitor.visitSingularStringField(value: self.text, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Sh_Generated_ShelterDemand, rhs: Sh_Generated_ShelterDemand) -> Bool {
    if lhs.text != rhs.text {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
