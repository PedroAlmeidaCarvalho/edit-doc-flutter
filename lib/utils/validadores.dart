String? validarNome(String? value) {
  if (value == null || value.trim().isEmpty) return 'Informe um nome válido';
  return null;
}

String? validarEmail(String? value) {
  if (value == null || value.trim().isEmpty || !value.contains('@')) {
    return 'Informe um e-mail válido contendo @';
  }
  if (!value.endsWith('.com') && !value.endsWith('.com.br')) {
    return 'O e-mail deve terminar em .com ou .com.br';
  }
  return null;
}

String? validarSenha(String? value) {
  if (value == null || value.length < 6) {
    return 'A senha deve ter pelo menos 6 caracteres';
  }
  return null;
}