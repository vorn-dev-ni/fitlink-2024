class ProfileEditValidation {
  ProfileEditValidation._();

  static String? validateFirstName(
      String? value, int maxLength, int minLength) {
    if (value == "" || value == null) {
      return 'Your first name must not be empty';
    }

    if (value.length < minLength) {
      return 'Your first name must be less then $minLength characters';
    }
    if (value.length > maxLength - 1) {
      return 'Your first name must be more then ${maxLength - 1} characters';
    }
    return null;
  }

  static String? validateLastName(String? value, int maxLength, int minLength) {
    if (value == "" || value == null) {
      return 'Your last name must not be empty';
    }

    if (value.length < minLength) {
      return 'Your last name must be less then $minLength characters';
    }
    if (value.length > maxLength - 1) {
      return 'Your last name must be more then ${maxLength - 1} characters';
    }
    return null;
  }

  static String? validateBio(String? value, int maxLength, int minLength) {
    if (value == "" || value == null) {
      return null;
    }

    if (value.length < minLength) {
      return 'Your bio must be less then $minLength characters';
    }
    if (value.length > maxLength - 1) {
      return 'Your bio must be more then ${maxLength - 1} characters';
    }
    return null;
  }
}
