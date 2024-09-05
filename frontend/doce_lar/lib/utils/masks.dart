import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class InputMasks {
  // Máscara para telefone
  static final phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  // Máscara para email (não requer máscara complexa, mas apenas filtro)
  static final emailMask = MaskTextInputFormatter(
    filter: {"#": RegExp(r'[a-zA-Z0-9@.]')},
  );

  static final cepMask = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
}