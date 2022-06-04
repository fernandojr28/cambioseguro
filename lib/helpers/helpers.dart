import 'package:cambioseguro/enums/enum.dart';
import 'package:cambioseguro/models/models.dart';
import 'package:cambioseguro/shared/app_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:validators/validators.dart';
import 'package:cambioseguro/extensions/string_extensions.dart';

String validateEmail(String email) {
  if (email.trim().isEmpty || !isEmail(email))
    return "Por favor ingrese un correo válido";

  return null;
}

String validateRuc(String value) {
  var _value = value.trim();
  if (_value.isEmpty) return "Por favor ingrese ruc válido";
  if (_value.length != 11) return "El RUC debe tener 11 dígitos";
  return null;
}

String validateText(String value) {
  if (value.trim().isEmpty) return "Campo requerido";
  return null;
}

String validatePhone(String value) {
  if (value.trim().isEmpty) return "Campo requerido";
  if (value.length != 9) return "El número debe tener 9 dígitos";
  return null;
}

String validatePassword(String password) => _isValidLengthEmail(password);

String confirmPassword(String password, String password2) {
  if (password2.trim().isEmpty) return "Por favor ingrese la contraseña";
  if (password.compareTo(password2).isNegative)
    return "Las contraseña no coinciden";
  return null;
}

String validateFullName(String name) {
  if (name.trim().isEmpty) return "Inregrese nombre";
  return null;
}

String _isValidLengthEmail(String email) {
  if (email.trim().isEmpty) return "Por favor ingrese la contraseña";
  if (email.length < 4) return "Contraseña muy corta";
  if (email.length > 30) return "Contraseña muy larga";

  return null;
}

String isValidAccountBank(String text) {
  if (text.trim().isEmpty) return "Por favor ingrese número de cuenta";
  // validate with length characters
  return null;
}

IconData getIconChange(String type) {
  return type == "compra" ? AppIcons.usd : AppIcons.pen;
}

String validateMinAndMaxPurchase(
    String value, Coupon coupon, RequestType type) {
  if (value.isEmpty || coupon == null) return null;
  if (type == RequestType.venta && value.parseDouble() < coupon.minVenta) {
    return 'El monto mínimo es ${coupon.minVenta.toStringAsFixed(2)}';
  }
  if (type == RequestType.compra && value.parseDouble() < coupon.minCompra) {
    return 'El monto mínimo es ${coupon.minCompra.toStringAsFixed(2)}';
  }
  return null;
}

String validateDocumentNumberByType(String credentialType, String value) {
// DNI: 8 dígitos (números y permitir que comience con 0)
// Pasaporte: 14 dígitos (permitir números, letras y que comience con 0)
// CE: 10 dígitos (permitir números, letras y que comience con 0)
  String errorText;
  if (credentialType == 'DNI' && value.length != 8 && !isNumeric(value))
    errorText = 'Número de DNI no válido';
  if (credentialType == 'CE' && value.length != 10)
    errorText = 'Número no válido';
  if (credentialType == 'PASAPORTE' && value.length != 14)
    errorText = 'Número no válido';

  return errorText;
}

int getLenthByCredentialType(String credentialType) {
  if (credentialType == 'DNI') return 8;
  if (credentialType == 'CE') return 10;
  if (credentialType == 'PASAPORTE') return 14;
  return null;
}

TextInputType getTextInputTypeByCredentialType(String credentialType) {
  if (credentialType == 'DNI') return TextInputType.number;
  return TextInputType.text;
}
