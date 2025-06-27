// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchChatConversationsHash() =>
    r'cd8850d88e474f36306bf30b9e890b97c156fcf5';

/// See also [fetchChatConversations].
@ProviderFor(fetchChatConversations)
final fetchChatConversationsProvider =
    AutoDisposeFutureProvider<List<ChatConversation>>.internal(
  fetchChatConversations,
  name: r'fetchChatConversationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchChatConversationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchChatConversationsRef
    = AutoDisposeFutureProviderRef<List<ChatConversation>>;
String _$fetchChatMessagesHash() => r'105d067eeef66bab35b51515baeda183893c797d';

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

/// See also [fetchChatMessages].
@ProviderFor(fetchChatMessages)
const fetchChatMessagesProvider = FetchChatMessagesFamily();

/// See also [fetchChatMessages].
class FetchChatMessagesFamily extends Family<AsyncValue<List<ChatMessage>>> {
  /// See also [fetchChatMessages].
  const FetchChatMessagesFamily();

  /// See also [fetchChatMessages].
  FetchChatMessagesProvider call({
    required String conversationId,
  }) {
    return FetchChatMessagesProvider(
      conversationId: conversationId,
    );
  }

  @override
  FetchChatMessagesProvider getProviderOverride(
    covariant FetchChatMessagesProvider provider,
  ) {
    return call(
      conversationId: provider.conversationId,
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
  String? get name => r'fetchChatMessagesProvider';
}

/// See also [fetchChatMessages].
class FetchChatMessagesProvider
    extends AutoDisposeFutureProvider<List<ChatMessage>> {
  /// See also [fetchChatMessages].
  FetchChatMessagesProvider({
    required String conversationId,
  }) : this._internal(
          (ref) => fetchChatMessages(
            ref as FetchChatMessagesRef,
            conversationId: conversationId,
          ),
          from: fetchChatMessagesProvider,
          name: r'fetchChatMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchChatMessagesHash,
          dependencies: FetchChatMessagesFamily._dependencies,
          allTransitiveDependencies:
              FetchChatMessagesFamily._allTransitiveDependencies,
          conversationId: conversationId,
        );

  FetchChatMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.conversationId,
  }) : super.internal();

  final String conversationId;

  @override
  Override overrideWith(
    FutureOr<List<ChatMessage>> Function(FetchChatMessagesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchChatMessagesProvider._internal(
        (ref) => create(ref as FetchChatMessagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        conversationId: conversationId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ChatMessage>> createElement() {
    return _FetchChatMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchChatMessagesProvider &&
        other.conversationId == conversationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, conversationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchChatMessagesRef on AutoDisposeFutureProviderRef<List<ChatMessage>> {
  /// The parameter `conversationId` of this provider.
  String get conversationId;
}

class _FetchChatMessagesProviderElement
    extends AutoDisposeFutureProviderElement<List<ChatMessage>>
    with FetchChatMessagesRef {
  _FetchChatMessagesProviderElement(super.provider);

  @override
  String get conversationId =>
      (origin as FetchChatMessagesProvider).conversationId;
}

String _$sendChatMessageHash() => r'f6e118218d5cc4c3f0d69dea68e82a5db6dd7353';

/// See also [sendChatMessage].
@ProviderFor(sendChatMessage)
const sendChatMessageProvider = SendChatMessageFamily();

/// See also [sendChatMessage].
class SendChatMessageFamily extends Family<AsyncValue<ChatMessage>> {
  /// See also [sendChatMessage].
  const SendChatMessageFamily();

  /// See also [sendChatMessage].
  SendChatMessageProvider call({
    required String conversationId,
    required String content,
  }) {
    return SendChatMessageProvider(
      conversationId: conversationId,
      content: content,
    );
  }

  @override
  SendChatMessageProvider getProviderOverride(
    covariant SendChatMessageProvider provider,
  ) {
    return call(
      conversationId: provider.conversationId,
      content: provider.content,
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
  String? get name => r'sendChatMessageProvider';
}

/// See also [sendChatMessage].
class SendChatMessageProvider extends AutoDisposeFutureProvider<ChatMessage> {
  /// See also [sendChatMessage].
  SendChatMessageProvider({
    required String conversationId,
    required String content,
  }) : this._internal(
          (ref) => sendChatMessage(
            ref as SendChatMessageRef,
            conversationId: conversationId,
            content: content,
          ),
          from: sendChatMessageProvider,
          name: r'sendChatMessageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sendChatMessageHash,
          dependencies: SendChatMessageFamily._dependencies,
          allTransitiveDependencies:
              SendChatMessageFamily._allTransitiveDependencies,
          conversationId: conversationId,
          content: content,
        );

  SendChatMessageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.conversationId,
    required this.content,
  }) : super.internal();

  final String conversationId;
  final String content;

  @override
  Override overrideWith(
    FutureOr<ChatMessage> Function(SendChatMessageRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SendChatMessageProvider._internal(
        (ref) => create(ref as SendChatMessageRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        conversationId: conversationId,
        content: content,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ChatMessage> createElement() {
    return _SendChatMessageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SendChatMessageProvider &&
        other.conversationId == conversationId &&
        other.content == content;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, conversationId.hashCode);
    hash = _SystemHash.combine(hash, content.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SendChatMessageRef on AutoDisposeFutureProviderRef<ChatMessage> {
  /// The parameter `conversationId` of this provider.
  String get conversationId;

  /// The parameter `content` of this provider.
  String get content;
}

class _SendChatMessageProviderElement
    extends AutoDisposeFutureProviderElement<ChatMessage>
    with SendChatMessageRef {
  _SendChatMessageProviderElement(super.provider);

  @override
  String get conversationId =>
      (origin as SendChatMessageProvider).conversationId;
  @override
  String get content => (origin as SendChatMessageProvider).content;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
