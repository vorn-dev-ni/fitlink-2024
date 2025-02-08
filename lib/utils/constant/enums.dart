enum Gender { men, women }

enum Option { s, m, l }

enum ActivityTag { gym, food }

enum StatusSnackbar { success, failed }

enum AppTheme { dark, light }

enum NutritionFactsType { calories, fat, protein, sugar, carbohydrate }

enum TimeSelection { startTime, endTime }

// ignore: constant_identifier_names
enum UserRoles { ADMIN, NORMAL, GYM_OWNER, GUEST }

extension UserRolesExtension on UserRoles {
  String toValue() {
    switch (this) {
      case UserRoles.ADMIN:
        return "admin";
      case UserRoles.NORMAL:
        return "normal";
      case UserRoles.GYM_OWNER:
        return "gym_owner";
      case UserRoles.GUEST:
        return "guest";
    }
  }

  static UserRoles? fromValue(String? value) {
    switch (value?.toLowerCase()) {
      case "admin":
        return UserRoles.ADMIN;
      case "normal":
        return UserRoles.NORMAL;
      case "gym_owner":
        return UserRoles.GYM_OWNER;
      case "guest":
        return UserRoles.GUEST;
      default:
        return null;
    }
  }
}

enum UploadType { camera, photo }

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTHORIZED,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_DELETED,
  DATA_NOT_ADDED,
  DATA_NOT_DELETED,
  STEPS_READY,
  HEALTH_CONNECT_STATUS,
  PERMISSIONS_REVOKING,
  PERMISSIONS_REVOKED,
  PERMISSIONS_NOT_REVOKED,
}

enum AppConfigState {
  banner_tag('banner_tag'),
  social_login('social_login');

  final String value;
  const AppConfigState(this.value);
}

enum Flavor {
  dev('dev'),
  production('prod'),
  staging('staging');

  final String value;
  const Flavor(this.value);
}
