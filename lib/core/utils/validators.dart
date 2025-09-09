String? emailValidator(String? v) {
  if (v == null || v.trim().isEmpty) return 'Vui lòng nhập email';
  if (!v.contains('@')) return 'Email không hợp lệ';
  return null;
}

String? passwordValidator(String? v) {
  if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu';
  if (v.length < 4) return 'Mật khẩu tối thiểu 4 ký tự';
  return null;
}
