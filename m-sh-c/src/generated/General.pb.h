// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: General.proto

#ifndef PROTOBUF_INCLUDED_General_2eproto
#define PROTOBUF_INCLUDED_General_2eproto

#include <string>

#include <google/protobuf/stubs/common.h>

#if GOOGLE_PROTOBUF_VERSION < 3006001
#error This file was generated by a newer version of protoc which is
#error incompatible with your Protocol Buffer headers.  Please update
#error your headers.
#endif
#if 3006001 < GOOGLE_PROTOBUF_MIN_PROTOC_VERSION
#error This file was generated by an older version of protoc which is
#error incompatible with your Protocol Buffer headers.  Please
#error regenerate this file with a newer version of protoc.
#endif

#include <google/protobuf/io/coded_stream.h>
#include <google/protobuf/arena.h>
#include <google/protobuf/arenastring.h>
#include <google/protobuf/generated_message_table_driven.h>
#include <google/protobuf/generated_message_util.h>
#include <google/protobuf/inlined_string_field.h>
#include <google/protobuf/metadata.h>
#include <google/protobuf/message.h>
#include <google/protobuf/repeated_field.h>  // IWYU pragma: export
#include <google/protobuf/extension_set.h>  // IWYU pragma: export
#include <google/protobuf/generated_enum_reflection.h>
#include <google/protobuf/unknown_field_set.h>
// @@protoc_insertion_point(includes)
#define PROTOBUF_INTERNAL_EXPORT_protobuf_General_2eproto 

namespace protobuf_General_2eproto {
// Internal implementation detail -- do not use these members.
struct TableStruct {
  static const ::google::protobuf::internal::ParseTableField entries[];
  static const ::google::protobuf::internal::AuxillaryParseTableField aux[];
  static const ::google::protobuf::internal::ParseTable schema[3];
  static const ::google::protobuf::internal::FieldMetadata field_metadata[];
  static const ::google::protobuf::internal::SerializationTable serialization_table[];
  static const ::google::protobuf::uint32 offsets[];
};
void AddDescriptors();
}  // namespace protobuf_General_2eproto
namespace sh {
namespace generated {
class GeoPoint;
class GeoPointDefaultTypeInternal;
extern GeoPointDefaultTypeInternal _GeoPoint_default_instance_;
class SearchParams;
class SearchParamsDefaultTypeInternal;
extern SearchParamsDefaultTypeInternal _SearchParams_default_instance_;
class TimeWindow;
class TimeWindowDefaultTypeInternal;
extern TimeWindowDefaultTypeInternal _TimeWindow_default_instance_;
}  // namespace generated
}  // namespace sh
namespace google {
namespace protobuf {
template<> ::sh::generated::GeoPoint* Arena::CreateMaybeMessage<::sh::generated::GeoPoint>(Arena*);
template<> ::sh::generated::SearchParams* Arena::CreateMaybeMessage<::sh::generated::SearchParams>(Arena*);
template<> ::sh::generated::TimeWindow* Arena::CreateMaybeMessage<::sh::generated::TimeWindow>(Arena*);
}  // namespace protobuf
}  // namespace google
namespace sh {
namespace generated {

enum Transport {
  PEDESTRIAN = 0,
  PUBLIC_TRANSPORT = 1,
  CAR = 2,
  Transport_INT_MIN_SENTINEL_DO_NOT_USE_ = ::google::protobuf::kint32min,
  Transport_INT_MAX_SENTINEL_DO_NOT_USE_ = ::google::protobuf::kint32max
};
bool Transport_IsValid(int value);
const Transport Transport_MIN = PEDESTRIAN;
const Transport Transport_MAX = CAR;
const int Transport_ARRAYSIZE = Transport_MAX + 1;

const ::google::protobuf::EnumDescriptor* Transport_descriptor();
inline const ::std::string& Transport_Name(Transport value) {
  return ::google::protobuf::internal::NameOfEnum(
    Transport_descriptor(), value);
}
inline bool Transport_Parse(
    const ::std::string& name, Transport* value) {
  return ::google::protobuf::internal::ParseNamedEnum<Transport>(
    Transport_descriptor(), name, value);
}
// ===================================================================

class TimeWindow : public ::google::protobuf::Message /* @@protoc_insertion_point(class_definition:sh.generated.TimeWindow) */ {
 public:
  TimeWindow();
  virtual ~TimeWindow();

  TimeWindow(const TimeWindow& from);

  inline TimeWindow& operator=(const TimeWindow& from) {
    CopyFrom(from);
    return *this;
  }
  #if LANG_CXX11
  TimeWindow(TimeWindow&& from) noexcept
    : TimeWindow() {
    *this = ::std::move(from);
  }

  inline TimeWindow& operator=(TimeWindow&& from) noexcept {
    if (GetArenaNoVirtual() == from.GetArenaNoVirtual()) {
      if (this != &from) InternalSwap(&from);
    } else {
      CopyFrom(from);
    }
    return *this;
  }
  #endif
  static const ::google::protobuf::Descriptor* descriptor();
  static const TimeWindow& default_instance();

  static void InitAsDefaultInstance();  // FOR INTERNAL USE ONLY
  static inline const TimeWindow* internal_default_instance() {
    return reinterpret_cast<const TimeWindow*>(
               &_TimeWindow_default_instance_);
  }
  static constexpr int kIndexInFileMessages =
    0;

  void Swap(TimeWindow* other);
  friend void swap(TimeWindow& a, TimeWindow& b) {
    a.Swap(&b);
  }

  // implements Message ----------------------------------------------

  inline TimeWindow* New() const final {
    return CreateMaybeMessage<TimeWindow>(NULL);
  }

  TimeWindow* New(::google::protobuf::Arena* arena) const final {
    return CreateMaybeMessage<TimeWindow>(arena);
  }
  void CopyFrom(const ::google::protobuf::Message& from) final;
  void MergeFrom(const ::google::protobuf::Message& from) final;
  void CopyFrom(const TimeWindow& from);
  void MergeFrom(const TimeWindow& from);
  void Clear() final;
  bool IsInitialized() const final;

  size_t ByteSizeLong() const final;
  bool MergePartialFromCodedStream(
      ::google::protobuf::io::CodedInputStream* input) final;
  void SerializeWithCachedSizes(
      ::google::protobuf::io::CodedOutputStream* output) const final;
  ::google::protobuf::uint8* InternalSerializeWithCachedSizesToArray(
      bool deterministic, ::google::protobuf::uint8* target) const final;
  int GetCachedSize() const final { return _cached_size_.Get(); }

  private:
  void SharedCtor();
  void SharedDtor();
  void SetCachedSize(int size) const final;
  void InternalSwap(TimeWindow* other);
  private:
  inline ::google::protobuf::Arena* GetArenaNoVirtual() const {
    return NULL;
  }
  inline void* MaybeArenaPtr() const {
    return NULL;
  }
  public:

  ::google::protobuf::Metadata GetMetadata() const final;

  // nested types ----------------------------------------------------

  // accessors -------------------------------------------------------

  // int32 from = 1;
  void clear_from();
  static const int kFromFieldNumber = 1;
  ::google::protobuf::int32 from() const;
  void set_from(::google::protobuf::int32 value);

  // int32 to = 2;
  void clear_to();
  static const int kToFieldNumber = 2;
  ::google::protobuf::int32 to() const;
  void set_to(::google::protobuf::int32 value);

  // @@protoc_insertion_point(class_scope:sh.generated.TimeWindow)
 private:

  ::google::protobuf::internal::InternalMetadataWithArena _internal_metadata_;
  ::google::protobuf::int32 from_;
  ::google::protobuf::int32 to_;
  mutable ::google::protobuf::internal::CachedSize _cached_size_;
  friend struct ::protobuf_General_2eproto::TableStruct;
};
// -------------------------------------------------------------------

class GeoPoint : public ::google::protobuf::Message /* @@protoc_insertion_point(class_definition:sh.generated.GeoPoint) */ {
 public:
  GeoPoint();
  virtual ~GeoPoint();

  GeoPoint(const GeoPoint& from);

  inline GeoPoint& operator=(const GeoPoint& from) {
    CopyFrom(from);
    return *this;
  }
  #if LANG_CXX11
  GeoPoint(GeoPoint&& from) noexcept
    : GeoPoint() {
    *this = ::std::move(from);
  }

  inline GeoPoint& operator=(GeoPoint&& from) noexcept {
    if (GetArenaNoVirtual() == from.GetArenaNoVirtual()) {
      if (this != &from) InternalSwap(&from);
    } else {
      CopyFrom(from);
    }
    return *this;
  }
  #endif
  static const ::google::protobuf::Descriptor* descriptor();
  static const GeoPoint& default_instance();

  static void InitAsDefaultInstance();  // FOR INTERNAL USE ONLY
  static inline const GeoPoint* internal_default_instance() {
    return reinterpret_cast<const GeoPoint*>(
               &_GeoPoint_default_instance_);
  }
  static constexpr int kIndexInFileMessages =
    1;

  void Swap(GeoPoint* other);
  friend void swap(GeoPoint& a, GeoPoint& b) {
    a.Swap(&b);
  }

  // implements Message ----------------------------------------------

  inline GeoPoint* New() const final {
    return CreateMaybeMessage<GeoPoint>(NULL);
  }

  GeoPoint* New(::google::protobuf::Arena* arena) const final {
    return CreateMaybeMessage<GeoPoint>(arena);
  }
  void CopyFrom(const ::google::protobuf::Message& from) final;
  void MergeFrom(const ::google::protobuf::Message& from) final;
  void CopyFrom(const GeoPoint& from);
  void MergeFrom(const GeoPoint& from);
  void Clear() final;
  bool IsInitialized() const final;

  size_t ByteSizeLong() const final;
  bool MergePartialFromCodedStream(
      ::google::protobuf::io::CodedInputStream* input) final;
  void SerializeWithCachedSizes(
      ::google::protobuf::io::CodedOutputStream* output) const final;
  ::google::protobuf::uint8* InternalSerializeWithCachedSizesToArray(
      bool deterministic, ::google::protobuf::uint8* target) const final;
  int GetCachedSize() const final { return _cached_size_.Get(); }

  private:
  void SharedCtor();
  void SharedDtor();
  void SetCachedSize(int size) const final;
  void InternalSwap(GeoPoint* other);
  private:
  inline ::google::protobuf::Arena* GetArenaNoVirtual() const {
    return NULL;
  }
  inline void* MaybeArenaPtr() const {
    return NULL;
  }
  public:

  ::google::protobuf::Metadata GetMetadata() const final;

  // nested types ----------------------------------------------------

  // accessors -------------------------------------------------------

  // double lat = 1;
  void clear_lat();
  static const int kLatFieldNumber = 1;
  double lat() const;
  void set_lat(double value);

  // double lon = 2;
  void clear_lon();
  static const int kLonFieldNumber = 2;
  double lon() const;
  void set_lon(double value);

  // @@protoc_insertion_point(class_scope:sh.generated.GeoPoint)
 private:

  ::google::protobuf::internal::InternalMetadataWithArena _internal_metadata_;
  double lat_;
  double lon_;
  mutable ::google::protobuf::internal::CachedSize _cached_size_;
  friend struct ::protobuf_General_2eproto::TableStruct;
};
// -------------------------------------------------------------------

class SearchParams : public ::google::protobuf::Message /* @@protoc_insertion_point(class_definition:sh.generated.SearchParams) */ {
 public:
  SearchParams();
  virtual ~SearchParams();

  SearchParams(const SearchParams& from);

  inline SearchParams& operator=(const SearchParams& from) {
    CopyFrom(from);
    return *this;
  }
  #if LANG_CXX11
  SearchParams(SearchParams&& from) noexcept
    : SearchParams() {
    *this = ::std::move(from);
  }

  inline SearchParams& operator=(SearchParams&& from) noexcept {
    if (GetArenaNoVirtual() == from.GetArenaNoVirtual()) {
      if (this != &from) InternalSwap(&from);
    } else {
      CopyFrom(from);
    }
    return *this;
  }
  #endif
  static const ::google::protobuf::Descriptor* descriptor();
  static const SearchParams& default_instance();

  static void InitAsDefaultInstance();  // FOR INTERNAL USE ONLY
  static inline const SearchParams* internal_default_instance() {
    return reinterpret_cast<const SearchParams*>(
               &_SearchParams_default_instance_);
  }
  static constexpr int kIndexInFileMessages =
    2;

  void Swap(SearchParams* other);
  friend void swap(SearchParams& a, SearchParams& b) {
    a.Swap(&b);
  }

  // implements Message ----------------------------------------------

  inline SearchParams* New() const final {
    return CreateMaybeMessage<SearchParams>(NULL);
  }

  SearchParams* New(::google::protobuf::Arena* arena) const final {
    return CreateMaybeMessage<SearchParams>(arena);
  }
  void CopyFrom(const ::google::protobuf::Message& from) final;
  void MergeFrom(const ::google::protobuf::Message& from) final;
  void CopyFrom(const SearchParams& from);
  void MergeFrom(const SearchParams& from);
  void Clear() final;
  bool IsInitialized() const final;

  size_t ByteSizeLong() const final;
  bool MergePartialFromCodedStream(
      ::google::protobuf::io::CodedInputStream* input) final;
  void SerializeWithCachedSizes(
      ::google::protobuf::io::CodedOutputStream* output) const final;
  ::google::protobuf::uint8* InternalSerializeWithCachedSizesToArray(
      bool deterministic, ::google::protobuf::uint8* target) const final;
  int GetCachedSize() const final { return _cached_size_.Get(); }

  private:
  void SharedCtor();
  void SharedDtor();
  void SetCachedSize(int size) const final;
  void InternalSwap(SearchParams* other);
  private:
  inline ::google::protobuf::Arena* GetArenaNoVirtual() const {
    return NULL;
  }
  inline void* MaybeArenaPtr() const {
    return NULL;
  }
  public:

  ::google::protobuf::Metadata GetMetadata() const final;

  // nested types ----------------------------------------------------

  // accessors -------------------------------------------------------

  // .sh.generated.GeoPoint start = 1;
  bool has_start() const;
  void clear_start();
  static const int kStartFieldNumber = 1;
  private:
  const ::sh::generated::GeoPoint& _internal_start() const;
  public:
  const ::sh::generated::GeoPoint& start() const;
  ::sh::generated::GeoPoint* release_start();
  ::sh::generated::GeoPoint* mutable_start();
  void set_allocated_start(::sh::generated::GeoPoint* start);

  // .sh.generated.GeoPoint finish = 2;
  bool has_finish() const;
  void clear_finish();
  static const int kFinishFieldNumber = 2;
  private:
  const ::sh::generated::GeoPoint& _internal_finish() const;
  public:
  const ::sh::generated::GeoPoint& finish() const;
  ::sh::generated::GeoPoint* release_finish();
  ::sh::generated::GeoPoint* mutable_finish();
  void set_allocated_finish(::sh::generated::GeoPoint* finish);

  // .sh.generated.TimeWindow availabilityWindow = 4;
  bool has_availabilitywindow() const;
  void clear_availabilitywindow();
  static const int kAvailabilityWindowFieldNumber = 4;
  private:
  const ::sh::generated::TimeWindow& _internal_availabilitywindow() const;
  public:
  const ::sh::generated::TimeWindow& availabilitywindow() const;
  ::sh::generated::TimeWindow* release_availabilitywindow();
  ::sh::generated::TimeWindow* mutable_availabilitywindow();
  void set_allocated_availabilitywindow(::sh::generated::TimeWindow* availabilitywindow);

  // .sh.generated.Transport transport = 3;
  void clear_transport();
  static const int kTransportFieldNumber = 3;
  ::sh::generated::Transport transport() const;
  void set_transport(::sh::generated::Transport value);

  // int32 timeLimit = 5;
  void clear_timelimit();
  static const int kTimeLimitFieldNumber = 5;
  ::google::protobuf::int32 timelimit() const;
  void set_timelimit(::google::protobuf::int32 value);

  // int32 distanceLimit = 6;
  void clear_distancelimit();
  static const int kDistanceLimitFieldNumber = 6;
  ::google::protobuf::int32 distancelimit() const;
  void set_distancelimit(::google::protobuf::int32 value);

  // @@protoc_insertion_point(class_scope:sh.generated.SearchParams)
 private:

  ::google::protobuf::internal::InternalMetadataWithArena _internal_metadata_;
  ::sh::generated::GeoPoint* start_;
  ::sh::generated::GeoPoint* finish_;
  ::sh::generated::TimeWindow* availabilitywindow_;
  int transport_;
  ::google::protobuf::int32 timelimit_;
  ::google::protobuf::int32 distancelimit_;
  mutable ::google::protobuf::internal::CachedSize _cached_size_;
  friend struct ::protobuf_General_2eproto::TableStruct;
};
// ===================================================================


// ===================================================================

#ifdef __GNUC__
  #pragma GCC diagnostic push
  #pragma GCC diagnostic ignored "-Wstrict-aliasing"
#endif  // __GNUC__
// TimeWindow

// int32 from = 1;
inline void TimeWindow::clear_from() {
  from_ = 0;
}
inline ::google::protobuf::int32 TimeWindow::from() const {
  // @@protoc_insertion_point(field_get:sh.generated.TimeWindow.from)
  return from_;
}
inline void TimeWindow::set_from(::google::protobuf::int32 value) {
  
  from_ = value;
  // @@protoc_insertion_point(field_set:sh.generated.TimeWindow.from)
}

// int32 to = 2;
inline void TimeWindow::clear_to() {
  to_ = 0;
}
inline ::google::protobuf::int32 TimeWindow::to() const {
  // @@protoc_insertion_point(field_get:sh.generated.TimeWindow.to)
  return to_;
}
inline void TimeWindow::set_to(::google::protobuf::int32 value) {
  
  to_ = value;
  // @@protoc_insertion_point(field_set:sh.generated.TimeWindow.to)
}

// -------------------------------------------------------------------

// GeoPoint

// double lat = 1;
inline void GeoPoint::clear_lat() {
  lat_ = 0;
}
inline double GeoPoint::lat() const {
  // @@protoc_insertion_point(field_get:sh.generated.GeoPoint.lat)
  return lat_;
}
inline void GeoPoint::set_lat(double value) {
  
  lat_ = value;
  // @@protoc_insertion_point(field_set:sh.generated.GeoPoint.lat)
}

// double lon = 2;
inline void GeoPoint::clear_lon() {
  lon_ = 0;
}
inline double GeoPoint::lon() const {
  // @@protoc_insertion_point(field_get:sh.generated.GeoPoint.lon)
  return lon_;
}
inline void GeoPoint::set_lon(double value) {
  
  lon_ = value;
  // @@protoc_insertion_point(field_set:sh.generated.GeoPoint.lon)
}

// -------------------------------------------------------------------

// SearchParams

// .sh.generated.GeoPoint start = 1;
inline bool SearchParams::has_start() const {
  return this != internal_default_instance() && start_ != NULL;
}
inline void SearchParams::clear_start() {
  if (GetArenaNoVirtual() == NULL && start_ != NULL) {
    delete start_;
  }
  start_ = NULL;
}
inline const ::sh::generated::GeoPoint& SearchParams::_internal_start() const {
  return *start_;
}
inline const ::sh::generated::GeoPoint& SearchParams::start() const {
  const ::sh::generated::GeoPoint* p = start_;
  // @@protoc_insertion_point(field_get:sh.generated.SearchParams.start)
  return p != NULL ? *p : *reinterpret_cast<const ::sh::generated::GeoPoint*>(
      &::sh::generated::_GeoPoint_default_instance_);
}
inline ::sh::generated::GeoPoint* SearchParams::release_start() {
  // @@protoc_insertion_point(field_release:sh.generated.SearchParams.start)
  
  ::sh::generated::GeoPoint* temp = start_;
  start_ = NULL;
  return temp;
}
inline ::sh::generated::GeoPoint* SearchParams::mutable_start() {
  
  if (start_ == NULL) {
    auto* p = CreateMaybeMessage<::sh::generated::GeoPoint>(GetArenaNoVirtual());
    start_ = p;
  }
  // @@protoc_insertion_point(field_mutable:sh.generated.SearchParams.start)
  return start_;
}
inline void SearchParams::set_allocated_start(::sh::generated::GeoPoint* start) {
  ::google::protobuf::Arena* message_arena = GetArenaNoVirtual();
  if (message_arena == NULL) {
    delete start_;
  }
  if (start) {
    ::google::protobuf::Arena* submessage_arena = NULL;
    if (message_arena != submessage_arena) {
      start = ::google::protobuf::internal::GetOwnedMessage(
          message_arena, start, submessage_arena);
    }
    
  } else {
    
  }
  start_ = start;
  // @@protoc_insertion_point(field_set_allocated:sh.generated.SearchParams.start)
}

// .sh.generated.GeoPoint finish = 2;
inline bool SearchParams::has_finish() const {
  return this != internal_default_instance() && finish_ != NULL;
}
inline void SearchParams::clear_finish() {
  if (GetArenaNoVirtual() == NULL && finish_ != NULL) {
    delete finish_;
  }
  finish_ = NULL;
}
inline const ::sh::generated::GeoPoint& SearchParams::_internal_finish() const {
  return *finish_;
}
inline const ::sh::generated::GeoPoint& SearchParams::finish() const {
  const ::sh::generated::GeoPoint* p = finish_;
  // @@protoc_insertion_point(field_get:sh.generated.SearchParams.finish)
  return p != NULL ? *p : *reinterpret_cast<const ::sh::generated::GeoPoint*>(
      &::sh::generated::_GeoPoint_default_instance_);
}
inline ::sh::generated::GeoPoint* SearchParams::release_finish() {
  // @@protoc_insertion_point(field_release:sh.generated.SearchParams.finish)
  
  ::sh::generated::GeoPoint* temp = finish_;
  finish_ = NULL;
  return temp;
}
inline ::sh::generated::GeoPoint* SearchParams::mutable_finish() {
  
  if (finish_ == NULL) {
    auto* p = CreateMaybeMessage<::sh::generated::GeoPoint>(GetArenaNoVirtual());
    finish_ = p;
  }
  // @@protoc_insertion_point(field_mutable:sh.generated.SearchParams.finish)
  return finish_;
}
inline void SearchParams::set_allocated_finish(::sh::generated::GeoPoint* finish) {
  ::google::protobuf::Arena* message_arena = GetArenaNoVirtual();
  if (message_arena == NULL) {
    delete finish_;
  }
  if (finish) {
    ::google::protobuf::Arena* submessage_arena = NULL;
    if (message_arena != submessage_arena) {
      finish = ::google::protobuf::internal::GetOwnedMessage(
          message_arena, finish, submessage_arena);
    }
    
  } else {
    
  }
  finish_ = finish;
  // @@protoc_insertion_point(field_set_allocated:sh.generated.SearchParams.finish)
}

// .sh.generated.Transport transport = 3;
inline void SearchParams::clear_transport() {
  transport_ = 0;
}
inline ::sh::generated::Transport SearchParams::transport() const {
  // @@protoc_insertion_point(field_get:sh.generated.SearchParams.transport)
  return static_cast< ::sh::generated::Transport >(transport_);
}
inline void SearchParams::set_transport(::sh::generated::Transport value) {
  
  transport_ = value;
  // @@protoc_insertion_point(field_set:sh.generated.SearchParams.transport)
}

// .sh.generated.TimeWindow availabilityWindow = 4;
inline bool SearchParams::has_availabilitywindow() const {
  return this != internal_default_instance() && availabilitywindow_ != NULL;
}
inline void SearchParams::clear_availabilitywindow() {
  if (GetArenaNoVirtual() == NULL && availabilitywindow_ != NULL) {
    delete availabilitywindow_;
  }
  availabilitywindow_ = NULL;
}
inline const ::sh::generated::TimeWindow& SearchParams::_internal_availabilitywindow() const {
  return *availabilitywindow_;
}
inline const ::sh::generated::TimeWindow& SearchParams::availabilitywindow() const {
  const ::sh::generated::TimeWindow* p = availabilitywindow_;
  // @@protoc_insertion_point(field_get:sh.generated.SearchParams.availabilityWindow)
  return p != NULL ? *p : *reinterpret_cast<const ::sh::generated::TimeWindow*>(
      &::sh::generated::_TimeWindow_default_instance_);
}
inline ::sh::generated::TimeWindow* SearchParams::release_availabilitywindow() {
  // @@protoc_insertion_point(field_release:sh.generated.SearchParams.availabilityWindow)
  
  ::sh::generated::TimeWindow* temp = availabilitywindow_;
  availabilitywindow_ = NULL;
  return temp;
}
inline ::sh::generated::TimeWindow* SearchParams::mutable_availabilitywindow() {
  
  if (availabilitywindow_ == NULL) {
    auto* p = CreateMaybeMessage<::sh::generated::TimeWindow>(GetArenaNoVirtual());
    availabilitywindow_ = p;
  }
  // @@protoc_insertion_point(field_mutable:sh.generated.SearchParams.availabilityWindow)
  return availabilitywindow_;
}
inline void SearchParams::set_allocated_availabilitywindow(::sh::generated::TimeWindow* availabilitywindow) {
  ::google::protobuf::Arena* message_arena = GetArenaNoVirtual();
  if (message_arena == NULL) {
    delete availabilitywindow_;
  }
  if (availabilitywindow) {
    ::google::protobuf::Arena* submessage_arena = NULL;
    if (message_arena != submessage_arena) {
      availabilitywindow = ::google::protobuf::internal::GetOwnedMessage(
          message_arena, availabilitywindow, submessage_arena);
    }
    
  } else {
    
  }
  availabilitywindow_ = availabilitywindow;
  // @@protoc_insertion_point(field_set_allocated:sh.generated.SearchParams.availabilityWindow)
}

// int32 timeLimit = 5;
inline void SearchParams::clear_timelimit() {
  timelimit_ = 0;
}
inline ::google::protobuf::int32 SearchParams::timelimit() const {
  // @@protoc_insertion_point(field_get:sh.generated.SearchParams.timeLimit)
  return timelimit_;
}
inline void SearchParams::set_timelimit(::google::protobuf::int32 value) {
  
  timelimit_ = value;
  // @@protoc_insertion_point(field_set:sh.generated.SearchParams.timeLimit)
}

// int32 distanceLimit = 6;
inline void SearchParams::clear_distancelimit() {
  distancelimit_ = 0;
}
inline ::google::protobuf::int32 SearchParams::distancelimit() const {
  // @@protoc_insertion_point(field_get:sh.generated.SearchParams.distanceLimit)
  return distancelimit_;
}
inline void SearchParams::set_distancelimit(::google::protobuf::int32 value) {
  
  distancelimit_ = value;
  // @@protoc_insertion_point(field_set:sh.generated.SearchParams.distanceLimit)
}

#ifdef __GNUC__
  #pragma GCC diagnostic pop
#endif  // __GNUC__
// -------------------------------------------------------------------

// -------------------------------------------------------------------


// @@protoc_insertion_point(namespace_scope)

}  // namespace generated
}  // namespace sh

namespace google {
namespace protobuf {

template <> struct is_proto_enum< ::sh::generated::Transport> : ::std::true_type {};
template <>
inline const EnumDescriptor* GetEnumDescriptor< ::sh::generated::Transport>() {
  return ::sh::generated::Transport_descriptor();
}

}  // namespace protobuf
}  // namespace google

// @@protoc_insertion_point(global_scope)

#endif  // PROTOBUF_INCLUDED_General_2eproto