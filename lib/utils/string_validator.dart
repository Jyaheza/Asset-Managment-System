const _emailAddressRegex =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

String? validateEmailAddress(String? input) {
  if (input == null) {
    return 'Something went wrong';
  }
  return RegExp(_emailAddressRegex).hasMatch(input)
      ? null
      : 'Invalid email format';
}

String? validatePassword(String? password) {
  if (password == null) {
    return 'Something went wrong';
  }
  return password.length >= 6
      ? null
      : 'Password must contain at least 6 characters';
}

String? validateNonEmptyMessage(String? input) {
  return input == null || input.isEmpty ? 'This field must not be empty' : null;
}

String? validateSchoolID(String? input) {
  if (input == null) {
    return 'School ID is null';
  }
  try {
    int.parse(input);
    return null;
  } catch (e) {
    return 'School ID must be a valid integer';
  }
}
