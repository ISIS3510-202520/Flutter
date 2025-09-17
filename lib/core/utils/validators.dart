String? emailValidator(String? value) {
  if (value == null || value.isEmpty) return 'Email is required';
  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) return 'Password is required';
  if (value.length < 8) return 'Password must be at least 8 characters';
  if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Include at least one uppercase letter';
  if (!RegExp(r'[a-z]').hasMatch(value)) return 'Include at least one lowercase letter';
  if (!RegExp(r'[0-9]').hasMatch(value)) return 'Include at least one number';
  if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) return 'Include at least one special character';
  return null;
}

String? nameValidator(String? value) {
  if (value == null || value.isEmpty) return 'Name is required';
  if (value.length < 2) return 'Name must be at least 2 characters';
  if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) return 'Name can only contain letters and spaces';
  return null;
}