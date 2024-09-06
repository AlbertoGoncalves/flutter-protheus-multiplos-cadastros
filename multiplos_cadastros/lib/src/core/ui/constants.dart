
import 'package:flutter/material.dart';

sealed class FontsConstants {
  static const fontFamily = 'Poppins';
}


sealed class ImageConstants {
  static const backgroundChair = 'assets/images/background_image_chair.png';
  static const avatar = 'assets/images/avatar.png';
  static const calendar = 'assets/images/calendar.png';
  static const event = 'assets/images/touch-screen.png';
}
sealed class ImagePersonTypeConstants {
  static const porteiro = 'assets/images/person_type/porteiro.png';
  static const visitante = 'assets/images/person_type/detetive.png';
  static const solicitante = 'assets/images/person_type/agente-de-call-center.png';
  static const aprovador = 'assets/images/person_type/gerente.png';
  static const visualizador = 'assets/images/person_type/mensageiro.png';
  static const entregador = 'assets/images/person_type/entregador.png';
  static const delivery = 'assets/images/person_type/bicicleta-de-entrega.png';
  static const motorista = 'assets/images/person_type/motorista.png';
  static const agricultor = 'assets/images/person_type/agricultor.png';


}

sealed class ColorsConstants {
  static const brow = Color(0xFFB07B01);
  static const grey = Color(0xFF999999);
  static const greyLight = Color(0xFFE6E2E9);
  static const red = Color(0xFFEB1212);
  static const green = Colors.green;

}