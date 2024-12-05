import 'package:shared_preferences/shared_preferences.dart';

class GlobalState {
  // Singleton instance
  static final GlobalState _instance = GlobalState._internal();

  // Private constructor
  GlobalState._internal();

  // Factory constructor to return the singleton instance
  factory GlobalState() {
    return _instance;
  }

  // Keys for SharedPreferences
  static const String _userIdKey = 'user_id';
  static const String _personalityIdKey = 'personality_id';
  static const String _colorKey = 'color';
  static const String _initialSetupCompletedKey = 'initial_setup_completed';
  static const String _subscriptionEndDateKey = 'subscription_end_date';
  static const String _isSubscribedKey = 'is_subscribed';

  // New companion-related keys
  static const String _companionNameKey = 'companion_name';
  static const String _selectedGenderKey = 'selected_gender';
  static const String _relationshipTypeKey = 'relationship_type';
  static const String _personalityTypeKey = 'personality_type';
  static const String _isAdultKey = 'is_adult';

  // Store values in memory
  String? _userId;
  String? _personalityId;
  String? _color;
  bool _initialSetupCompleted = false;
  DateTime? _subscriptionEndDate;
  bool _isSubscribed = false;

  // New companion-related variables
  String? _companionName;
  String? _selectedGender;
  String? _relationshipType;
  String? _personalityType;
  bool _isAdult = false;

  // Track initialization state
  bool _isInitialized = false;

  // Existing getters
  String? get userId => _userId;
  String? get personalityId => _personalityId;
  String? get color => _color;
  bool get initialSetupCompleted => _initialSetupCompleted;
  DateTime? get subscriptionEndDate => _subscriptionEndDate;
  bool get isSubscribed => _isSubscribed;

  // New companion-related getters
  String? get companionName => _companionName;
  String? get selectedGender => _selectedGender;
  String? get relationshipType => _relationshipType;
  String? get personalityType => _personalityType;
  bool get isAdult => _isAdult;

  // New companion-related setters
  Future<void> setCompanionName(String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value == null) {
      if (await _hasValue(_companionNameKey)) {
        await prefs.remove(_companionNameKey);
        _companionName = null;
        print('Companion name cleared');
      }
    } else {
      await prefs.setString(_companionNameKey, value);
      _companionName = value;
      print('Companion name set to: $value');
    }
  }

  Future<void> setSelectedGender(String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value == null) {
      if (await _hasValue(_selectedGenderKey)) {
        await prefs.remove(_selectedGenderKey);
        _selectedGender = null;
        print('Selected gender cleared');
      }
    } else {
      await prefs.setString(_selectedGenderKey, value);
      _selectedGender = value;
      print('Selected gender set to: $value');
    }
  }

  Future<void> setRelationshipType(String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value == null) {
      if (await _hasValue(_relationshipTypeKey)) {
        await prefs.remove(_relationshipTypeKey);
        _relationshipType = null;
        print('Relationship type cleared');
      }
    } else {
      await prefs.setString(_relationshipTypeKey, value);
      _relationshipType = value;
      print('Relationship type set to: $value');
    }
  }

  Future<void> setPersonalityType(String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value == null) {
      if (await _hasValue(_personalityTypeKey)) {
        await prefs.remove(_personalityTypeKey);
        _personalityType = null;
        print('Personality type cleared');
      }
    } else {
      await prefs.setString(_personalityTypeKey, value);
      _personalityType = value;
      print('Personality type set to: $value');
    }
  }

  Future<void> setIsAdult(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isAdultKey, value);
    _isAdult = value;
    print('Is adult status set to: $value');
  }

  // Existing initialization method updated with new companion properties
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Load existing values
      if (await _hasValue(_userIdKey)) {
        _userId = prefs.getString(_userIdKey);
        print('Loaded existing User ID: $_userId');
      }

      if (await _hasValue(_personalityIdKey)) {
        _personalityId = prefs.getString(_personalityIdKey);
        print('Loaded existing Personality ID: $_personalityId');
      }

      if (await _hasValue(_colorKey)) {
        _color = prefs.getString(_colorKey);
        print('Loaded existing Color: $_color');
      }

      if (await _hasValue(_initialSetupCompletedKey)) {
        _initialSetupCompleted = prefs.getBool(_initialSetupCompletedKey) ?? false;
        print('Loaded initial setup status: $_initialSetupCompleted');
      }

      if (await _hasValue(_subscriptionEndDateKey)) {
        final dateStr = prefs.getString(_subscriptionEndDateKey);
        _subscriptionEndDate = dateStr != null ? DateTime.parse(dateStr) : null;
        print('Loaded subscription end date: $_subscriptionEndDate');
      }

      if (await _hasValue(_isSubscribedKey)) {
        _isSubscribed = prefs.getBool(_isSubscribedKey) ?? false;
        print('Loaded subscription status: $_isSubscribed');
      }

      // Load companion-related values
      if (await _hasValue(_companionNameKey)) {
        _companionName = prefs.getString(_companionNameKey);
        print('Loaded companion name: $_companionName');
      }

      if (await _hasValue(_selectedGenderKey)) {
        _selectedGender = prefs.getString(_selectedGenderKey);
        print('Loaded selected gender: $_selectedGender');
      }

      if (await _hasValue(_relationshipTypeKey)) {
        _relationshipType = prefs.getString(_relationshipTypeKey);
        print('Loaded relationship type: $_relationshipType');
      }

      if (await _hasValue(_personalityTypeKey)) {
        _personalityType = prefs.getString(_personalityTypeKey);
        print('Loaded personality type: $_personalityType');
      }

      if (await _hasValue(_isAdultKey)) {
        _isAdult = prefs.getBool(_isAdultKey) ?? false;
        print('Loaded is adult status: $_isAdult');
      }

      _isInitialized = true;
      print('GlobalState initialized');
    } catch (e) {
      print('Error in GlobalState initialization: $e');
      rethrow;
    }
  }

  // New check methods for companion properties
  Future<bool> hasCompanionName() => _hasValue(_companionNameKey);
  Future<bool> hasSelectedGender() => _hasValue(_selectedGenderKey);
  Future<bool> hasRelationshipType() => _hasValue(_relationshipTypeKey);
  Future<bool> hasPersonalityType() => _hasValue(_personalityTypeKey);
  Future<bool> hasIsAdult() => _hasValue(_isAdultKey);

  // New clear methods for companion properties
  Future<void> clearCompanionName() => setCompanionName(null);
  Future<void> clearSelectedGender() => setSelectedGender(null);
  Future<void> clearRelationshipType() => setRelationshipType(null);
  Future<void> clearPersonalityType() => setPersonalityType(null);
  Future<void> clearUserId() => setUserId(null);
  Future<void> clearPersonalityId() => setPersonalityId(null);
  Future<void> clearColor() => setColor(null);
  Future<void> clearSubscriptionEndDate() => setSubscriptionEndDate(null); // New clear method

  // Check methods
  Future<bool> hasUserId() => _hasValue(_userIdKey);
  Future<bool> hasPersonalityId() => _hasValue(_personalityIdKey);
  Future<bool> hasColor() => _hasValue(_colorKey);
  Future<bool> hasInitialSetupCompleted() => _hasValue(_initialSetupCompletedKey);
  Future<bool> hasSubscriptionEndDate() => _hasValue(_subscriptionEndDateKey); // New check method
  Future<bool> hasIsSubscribed() => _hasValue(_isSubscribedKey); // New check method

  // Updated clearAll method to include companion properties
  Future<void> clearAll() async {
    await clearUserId();
    await clearPersonalityId();
    await clearColor();
    await clearCompanionName();
    await clearSelectedGender();
    await clearRelationshipType();
    await clearPersonalityType();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_initialSetupCompletedKey);
    await prefs.remove(_subscriptionEndDateKey);
    await prefs.remove(_isSubscribedKey);
    await prefs.remove(_isAdultKey);

    _initialSetupCompleted = false;
    _subscriptionEndDate = null;
    _isSubscribed = false;
    _isAdult = false;

    print('All values cleared');
  }

  // Existing utility methods
  Future<bool> _hasValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  // Existing setters remain unchanged
  Future<void> setUserId(String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value == null) {
      if (await _hasValue(_userIdKey)) {
        await prefs.remove(_userIdKey);
        _userId = null;
        print('User ID cleared');
      }
    } else {
      await prefs.setString(_userIdKey, value);
      _userId = value;
      print('User ID set to: $value');
    }
  }

  Future<void> setPersonalityId(String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value == null) {
      if (await _hasValue(_personalityIdKey)) {
        await prefs.remove(_personalityIdKey);
        _personalityId = null;
        print('Personality ID cleared');
      }
    } else {
      await prefs.setString(_personalityIdKey, value);
      _personalityId = value;
      print('Personality ID set to: $value');
    }
  }

  Future<void> setColor(String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value == null) {
      if (await _hasValue(_colorKey)) {
        await prefs.remove(_colorKey);
        _color = null;
        print('Color cleared');
      }
    } else {
      await prefs.setString(_colorKey, value);
      _color = value;
      print('Color set to: $value');
    }
  }

  Future<void> setInitialSetupCompleted(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_initialSetupCompletedKey, value);
    _initialSetupCompleted = value;
    print('Initial setup completed status set to: $value');
  }

  Future<void> setSubscriptionEndDate(DateTime? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value == null) {
      if (await _hasValue(_subscriptionEndDateKey)) {
        await prefs.remove(_subscriptionEndDateKey);
        _subscriptionEndDate = null;
        print('Subscription end date cleared');
      }
    } else {
      await prefs.setString(_subscriptionEndDateKey, value.toIso8601String());
      _subscriptionEndDate = value;
      print('Subscription end date set to: $value');
    }
  }

  Future<void> setIsSubscribed(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isSubscribedKey, value);
    _isSubscribed = value;
    print('Subscription status set to: $value');
  }
}