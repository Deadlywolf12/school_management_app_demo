class ValidatorHelper {
  static String? validator(String? value) {
    if (value == "") {
      return "";
    }
    return null;
  }

  static String? validatorDropdown(Object? value) {
    if (value == null) {
      return "";
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return "";
    } else if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
        .hasMatch(value)) {
      return ("Invalid email format");
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return "";
    } else if (value.length < 8) {
      return ("Password Must be more than 8 characters");
    } else if (!RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(value)) {
      return ("Password should contain upper,lower,digit and Special character");
    }
    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == "") {
      return "";
    }
    if (value!.length < 10) {
      return "Please enter the valid number";
    }
    return null;
  }

  static String? validateSessionCost(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a session cost';
    }

    final double? cost = double.tryParse(value);
    if (cost == null) {
      return 'Please enter a valid number';
    }

    if (cost < 35) {
      return 'The session cost must be at least 35 dollars';
    }

    return null;
  }
}
