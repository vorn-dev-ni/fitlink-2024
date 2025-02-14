class ActivityValidation {
  ActivityValidation._();

  static String? validateName(String? value, int maxLength, int minLength) {
    if (value == "" || value == null) {
      return 'Your first name must not be empty';
    }

    if (value.length < minLength) {
      return 'Your first name must be more then ${minLength - 1} characters';
    }
    if (value.length > maxLength - 1) {
      return 'Your first name must be less then ${maxLength} characters';
    }
    return null;
  }

  static String? validateNote(String? value, int maxLength, int minLength) {
    if (value == "" || value == null) {
      return null;
    }

    if (value.length < minLength) {
      return 'Your bio must be more then ${minLength - 1} characters';
    }
    if (value.length > maxLength - 1) {
      return 'Your bio must be less then ${maxLength} characters';
    }
    return null;
  }

  static String? validateStartTime(DateTime? value) {
    if (value == null) {
      return "Start time should not be empty*";
    }

    return "";
  }

  static String? validateEndtime(DateTime? value) {
    if (value == null) {
      return "End Time should not be empty*";
    }

    return "";
  }

  static String? validateDate(DateTime? value) {
    if (value == null) {
      return "Date Time should not be empty*";
    }

    return "";
  }
}
