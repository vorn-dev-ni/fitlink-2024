class EventCreateValidation {
  EventCreateValidation._();

  static String? validateTitle(String? value, int maxLength, int minLength) {
    if (value == "" || value == null) {
      return 'Your title must not be empty';
    }

    if (value.length < minLength) {
      return 'Your title must be less then $minLength characters';
    }
    if (value.length > maxLength - 1) {
      return 'Your title must be more then ${maxLength - 1} characters';
    }
    return null;
  }

  static String? validateEstablishment(
      String? value, int maxLength, int minLength) {
    if (value == "" || value == null) {
      return 'Your establishment name must not be empty';
    }

    if (value.length < minLength) {
      return 'Your establishment name must be less then $minLength characters';
    }
    if (value.length > maxLength - 1) {
      return 'Your establishment name must be more then ${maxLength - 1} characters';
    }
    return null;
  }

  static String? validateDesc(String? value, int maxLength, int minLength) {
    if (value == "" || value == null) {
      return 'Your description must not be empty';
    }

    if (value.length < minLength) {
      return 'Your description must be less then $minLength characters';
    }
    if (value.length > maxLength - 1) {
      return 'Your description must be more then ${maxLength - 1} characters';
    }
    return null;
  }

  static String? validatePricing(String? value) {
    if (value == null || value.isEmpty) {
      return 'Your price must not be empty';
    }

    String cleanedValue = value.replaceAll(',', '.');

    // Check for negative sign
    if (cleanedValue.startsWith('-')) {
      return 'Price cannot be negative';
    }

    final regex = RegExp(r'^\d+(\.\d{1,2})?$');

    if (!regex.hasMatch(cleanedValue)) {
      return 'Enter a valid price with up to two decimal places';
    }

    return null;
  }
}
