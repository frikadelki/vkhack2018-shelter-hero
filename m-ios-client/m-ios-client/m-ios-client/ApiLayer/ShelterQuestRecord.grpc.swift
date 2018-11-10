//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: ShelterQuestRecord.proto
//

//
// Copyright 2018, gRPC Authors All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import Foundation
import Dispatch
import SwiftGRPC
import SwiftProtobuf

internal protocol Sh_Generated_ShelterQuestRecordServicelistCall: ClientCallUnary {}

fileprivate final class Sh_Generated_ShelterQuestRecordServicelistCallBase: ClientCallUnaryBase<Sh_Generated_ShelterQuestListRequest, Sh_Generated_ShelterQuestListResponse>, Sh_Generated_ShelterQuestRecordServicelistCall {
  override class var method: String { return "/sh.generated.ShelterQuestRecordService/list" }
}

internal protocol Sh_Generated_ShelterQuestRecordServiceshelterCall: ClientCallUnary {}

fileprivate final class Sh_Generated_ShelterQuestRecordServiceshelterCallBase: ClientCallUnaryBase<Sh_Generated_ShelterQuestRequest, Sh_Generated_ShelterQuestResponse>, Sh_Generated_ShelterQuestRecordServiceshelterCall {
  override class var method: String { return "/sh.generated.ShelterQuestRecordService/shelter" }
}

internal protocol Sh_Generated_ShelterQuestRecordServicestartCall: ClientCallUnary {}

fileprivate final class Sh_Generated_ShelterQuestRecordServicestartCallBase: ClientCallUnaryBase<Sh_Generated_ShelterQuestStartRequest, Sh_Generated_ShelterQuestResponse>, Sh_Generated_ShelterQuestRecordServicestartCall {
  override class var method: String { return "/sh.generated.ShelterQuestRecordService/start" }
}

internal protocol Sh_Generated_ShelterQuestRecordServiceupdateDemandCall: ClientCallUnary {}

fileprivate final class Sh_Generated_ShelterQuestRecordServiceupdateDemandCallBase: ClientCallUnaryBase<Sh_Generated_ShelterQuestUpdateDemandRequest, Sh_Generated_ShelterQuestUpdateDemandResponse>, Sh_Generated_ShelterQuestRecordServiceupdateDemandCall {
  override class var method: String { return "/sh.generated.ShelterQuestRecordService/updateDemand" }
}

internal protocol Sh_Generated_ShelterQuestRecordServicedoneCall: ClientCallUnary {}

fileprivate final class Sh_Generated_ShelterQuestRecordServicedoneCallBase: ClientCallUnaryBase<Sh_Generated_ShelterQuestRequest, Sh_Generated_ShelterQuestResponse>, Sh_Generated_ShelterQuestRecordServicedoneCall {
  override class var method: String { return "/sh.generated.ShelterQuestRecordService/done" }
}


/// Instantiate Sh_Generated_ShelterQuestRecordServiceServiceClient, then call methods of this protocol to make API calls.
internal protocol Sh_Generated_ShelterQuestRecordServiceService: ServiceClient {
  /// Synchronous. Unary.
  func list(_ request: Sh_Generated_ShelterQuestListRequest) throws -> Sh_Generated_ShelterQuestListResponse
  /// Asynchronous. Unary.
  func list(_ request: Sh_Generated_ShelterQuestListRequest, completion: @escaping (Sh_Generated_ShelterQuestListResponse?, CallResult) -> Void) throws -> Sh_Generated_ShelterQuestRecordServicelistCall

  /// Synchronous. Unary.
  func shelter(_ request: Sh_Generated_ShelterQuestRequest) throws -> Sh_Generated_ShelterQuestResponse
  /// Asynchronous. Unary.
  func shelter(_ request: Sh_Generated_ShelterQuestRequest, completion: @escaping (Sh_Generated_ShelterQuestResponse?, CallResult) -> Void) throws -> Sh_Generated_ShelterQuestRecordServiceshelterCall

  /// Synchronous. Unary.
  func start(_ request: Sh_Generated_ShelterQuestStartRequest) throws -> Sh_Generated_ShelterQuestResponse
  /// Asynchronous. Unary.
  func start(_ request: Sh_Generated_ShelterQuestStartRequest, completion: @escaping (Sh_Generated_ShelterQuestResponse?, CallResult) -> Void) throws -> Sh_Generated_ShelterQuestRecordServicestartCall

  /// Synchronous. Unary.
  func updateDemand(_ request: Sh_Generated_ShelterQuestUpdateDemandRequest) throws -> Sh_Generated_ShelterQuestUpdateDemandResponse
  /// Asynchronous. Unary.
  func updateDemand(_ request: Sh_Generated_ShelterQuestUpdateDemandRequest, completion: @escaping (Sh_Generated_ShelterQuestUpdateDemandResponse?, CallResult) -> Void) throws -> Sh_Generated_ShelterQuestRecordServiceupdateDemandCall

  /// Synchronous. Unary.
  func done(_ request: Sh_Generated_ShelterQuestRequest) throws -> Sh_Generated_ShelterQuestResponse
  /// Asynchronous. Unary.
  func done(_ request: Sh_Generated_ShelterQuestRequest, completion: @escaping (Sh_Generated_ShelterQuestResponse?, CallResult) -> Void) throws -> Sh_Generated_ShelterQuestRecordServicedoneCall

}

internal final class Sh_Generated_ShelterQuestRecordServiceServiceClient: ServiceClientBase, Sh_Generated_ShelterQuestRecordServiceService {
  /// Synchronous. Unary.
  internal func list(_ request: Sh_Generated_ShelterQuestListRequest) throws -> Sh_Generated_ShelterQuestListResponse {
    return try Sh_Generated_ShelterQuestRecordServicelistCallBase(channel)
      .run(request: request, metadata: metadata)
  }
  /// Asynchronous. Unary.
  internal func list(_ request: Sh_Generated_ShelterQuestListRequest, completion: @escaping (Sh_Generated_ShelterQuestListResponse?, CallResult) -> Void) throws -> Sh_Generated_ShelterQuestRecordServicelistCall {
    return try Sh_Generated_ShelterQuestRecordServicelistCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

  /// Synchronous. Unary.
  internal func shelter(_ request: Sh_Generated_ShelterQuestRequest) throws -> Sh_Generated_ShelterQuestResponse {
    return try Sh_Generated_ShelterQuestRecordServiceshelterCallBase(channel)
      .run(request: request, metadata: metadata)
  }
  /// Asynchronous. Unary.
  internal func shelter(_ request: Sh_Generated_ShelterQuestRequest, completion: @escaping (Sh_Generated_ShelterQuestResponse?, CallResult) -> Void) throws -> Sh_Generated_ShelterQuestRecordServiceshelterCall {
    return try Sh_Generated_ShelterQuestRecordServiceshelterCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

  /// Synchronous. Unary.
  internal func start(_ request: Sh_Generated_ShelterQuestStartRequest) throws -> Sh_Generated_ShelterQuestResponse {
    return try Sh_Generated_ShelterQuestRecordServicestartCallBase(channel)
      .run(request: request, metadata: metadata)
  }
  /// Asynchronous. Unary.
  internal func start(_ request: Sh_Generated_ShelterQuestStartRequest, completion: @escaping (Sh_Generated_ShelterQuestResponse?, CallResult) -> Void) throws -> Sh_Generated_ShelterQuestRecordServicestartCall {
    return try Sh_Generated_ShelterQuestRecordServicestartCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

  /// Synchronous. Unary.
  internal func updateDemand(_ request: Sh_Generated_ShelterQuestUpdateDemandRequest) throws -> Sh_Generated_ShelterQuestUpdateDemandResponse {
    return try Sh_Generated_ShelterQuestRecordServiceupdateDemandCallBase(channel)
      .run(request: request, metadata: metadata)
  }
  /// Asynchronous. Unary.
  internal func updateDemand(_ request: Sh_Generated_ShelterQuestUpdateDemandRequest, completion: @escaping (Sh_Generated_ShelterQuestUpdateDemandResponse?, CallResult) -> Void) throws -> Sh_Generated_ShelterQuestRecordServiceupdateDemandCall {
    return try Sh_Generated_ShelterQuestRecordServiceupdateDemandCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

  /// Synchronous. Unary.
  internal func done(_ request: Sh_Generated_ShelterQuestRequest) throws -> Sh_Generated_ShelterQuestResponse {
    return try Sh_Generated_ShelterQuestRecordServicedoneCallBase(channel)
      .run(request: request, metadata: metadata)
  }
  /// Asynchronous. Unary.
  internal func done(_ request: Sh_Generated_ShelterQuestRequest, completion: @escaping (Sh_Generated_ShelterQuestResponse?, CallResult) -> Void) throws -> Sh_Generated_ShelterQuestRecordServicedoneCall {
    return try Sh_Generated_ShelterQuestRecordServicedoneCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

}

