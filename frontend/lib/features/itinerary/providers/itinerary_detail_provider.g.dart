// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$itineraryDetailHash() => r'eab9a9e5dec48f5b7eb472ab66e2bcb8cecc7f34';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// 특정 일정의 상세 정보를 가져오는 AutoDispose FutureProvider family.
///
/// [id]는 일정 고유 식별자. 화면을 벗어나면 자동으로 캐시를 해제한다.
///
/// Copied from [itineraryDetail].
@ProviderFor(itineraryDetail)
const itineraryDetailProvider = ItineraryDetailFamily();

/// 특정 일정의 상세 정보를 가져오는 AutoDispose FutureProvider family.
///
/// [id]는 일정 고유 식별자. 화면을 벗어나면 자동으로 캐시를 해제한다.
///
/// Copied from [itineraryDetail].
class ItineraryDetailFamily extends Family<AsyncValue<ItineraryDetail>> {
  /// 특정 일정의 상세 정보를 가져오는 AutoDispose FutureProvider family.
  ///
  /// [id]는 일정 고유 식별자. 화면을 벗어나면 자동으로 캐시를 해제한다.
  ///
  /// Copied from [itineraryDetail].
  const ItineraryDetailFamily();

  /// 특정 일정의 상세 정보를 가져오는 AutoDispose FutureProvider family.
  ///
  /// [id]는 일정 고유 식별자. 화면을 벗어나면 자동으로 캐시를 해제한다.
  ///
  /// Copied from [itineraryDetail].
  ItineraryDetailProvider call(
    int id,
  ) {
    return ItineraryDetailProvider(
      id,
    );
  }

  @override
  ItineraryDetailProvider getProviderOverride(
    covariant ItineraryDetailProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'itineraryDetailProvider';
}

/// 특정 일정의 상세 정보를 가져오는 AutoDispose FutureProvider family.
///
/// [id]는 일정 고유 식별자. 화면을 벗어나면 자동으로 캐시를 해제한다.
///
/// Copied from [itineraryDetail].
class ItineraryDetailProvider
    extends AutoDisposeFutureProvider<ItineraryDetail> {
  /// 특정 일정의 상세 정보를 가져오는 AutoDispose FutureProvider family.
  ///
  /// [id]는 일정 고유 식별자. 화면을 벗어나면 자동으로 캐시를 해제한다.
  ///
  /// Copied from [itineraryDetail].
  ItineraryDetailProvider(
    int id,
  ) : this._internal(
          (ref) => itineraryDetail(
            ref as ItineraryDetailRef,
            id,
          ),
          from: itineraryDetailProvider,
          name: r'itineraryDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$itineraryDetailHash,
          dependencies: ItineraryDetailFamily._dependencies,
          allTransitiveDependencies:
              ItineraryDetailFamily._allTransitiveDependencies,
          id: id,
        );

  ItineraryDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<ItineraryDetail> Function(ItineraryDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ItineraryDetailProvider._internal(
        (ref) => create(ref as ItineraryDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ItineraryDetail> createElement() {
    return _ItineraryDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ItineraryDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ItineraryDetailRef on AutoDisposeFutureProviderRef<ItineraryDetail> {
  /// The parameter `id` of this provider.
  int get id;
}

class _ItineraryDetailProviderElement
    extends AutoDisposeFutureProviderElement<ItineraryDetail>
    with ItineraryDetailRef {
  _ItineraryDetailProviderElement(super.provider);

  @override
  int get id => (origin as ItineraryDetailProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
