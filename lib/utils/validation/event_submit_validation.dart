class EventSubmitValidation {
  EventSubmitValidation._();
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r".+@.+",
    );
    return emailRegex.hasMatch(email);
  }

  static String? validateZipCode(String? value, int maxLength, int minLength) {
    if (value == "" || value == null) {
      return 'Your zipcode must not be empty';
    }

    if (value.length < minLength) {
      return 'Your zipcode must be more then ${minLength - 1} characters';
    }
    if (value.length > maxLength - 1) {
      return 'Your zipcode must be less then ${maxLength} characters';
    }
    return null;
  }

  static String? validateLinkWebsite(
      String? value, int maxLength, int minLength) {
    if (value != "" && value!.length < minLength) {
      return 'Your website url must be more then ${minLength - 1} characters';
    }
    final RegExp websiteRegex = RegExp(r'^(https:\/\/|www\.)[^\s]+$');

    if (value != null && value.isNotEmpty && !websiteRegex.hasMatch(value)) {
      return 'Your website URL must start with "https" or "www"';
    }

    return null;
  }

  static String? valisdateHomeAddres(
      String? value, int maxLength, int minLength) {
    if (value == "" || value == null) {
      return 'Your address must not be empty';
    }

    if (value.length < minLength) {
      return 'Your address must be more then ${minLength - 1} characters';
    }
    if (value.length > maxLength - 1) {
      return 'Your address must be less then ${maxLength} characters';
    }
    return null;
  }

  static String? validateCountryPicker(String? value) {
    if (value == "" || value == null) {
      return 'Your country code must not be empty';
    }

    return null;
  }

  static String? validateFullname(String? value, int maxLength, int minLength) {
    if (value == "" || value == null) {
      return 'Your full name must not be empty';
    }

    if (value.length < minLength) {
      return 'Your full name must be more then ${minLength - 1} characters';
    }
    if (value.length > maxLength - 1) {
      return 'Your full name must be less then ${maxLength} characters';
    }

    return null;
  }

  static String? validateEmail(String? value, int maxLength, int minLength) {
    if (value == "" || value == null) {
      return 'Your email address must not be empty';
    }

    if (value.length < minLength) {
      return 'Your email address must be more then ${minLength - 1} characters';
    }
    if (value.length > maxLength - 1) {
      return 'Your email address must be less then ${maxLength} characters';
    }

    if (!isValidEmail(value)) {
      return 'Please provide valid email address';
    }
    return null;
  }

  static String? validatePhoneNumber(
      String? value, int maxLength, int minLength) {
    final RegExp phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');

    if (value == "" || value == null) {
      return 'Your phone number must not be empty';
    }

    if (value.length < minLength) {
      return 'Your phone number must be more then ${minLength - 1} characters';
    }
    if (value.length > maxLength - 1) {
      return 'Your phone number must be less then ${maxLength} characters';
    }
    if (!phoneRegex.hasMatch(value)) {
      return 'Your phone number must be a valid one';
    }

    return null;
  }
}
