import 'dart:convert';
import 'package:http/http.dart' as http;

/// Resultado de uma busca de CEP.
class EnderecoCep {
  final String cep;
  final String logradouro;
  final String bairro;
  final String cidade;
  final String estado;

  EnderecoCep({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.cidade,
    required this.estado,
  });

  factory EnderecoCep.fromJson(Map<String, dynamic> json) {
    return EnderecoCep(
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      bairro: json['bairro'] ?? '',
      cidade: json['localidade'] ?? '',
      estado: json['uf'] ?? '',
    );
  }
}

/// Exceção lançada quando o CEP é inválido ou não é encontrado.
class CepNaoEncontradoException implements Exception {
  final String message;
  CepNaoEncontradoException(this.message);

  @override
  String toString() => message;
}

/// Serviço responsável por consultar um CEP na API pública ViaCEP
/// e retornar os dados de endereço correspondentes.
class CepService {
  static Future<EnderecoCep> buscar(String cepDigitado) async {
    final cep = cepDigitado.replaceAll(RegExp(r'[^0-9]'), '');

    if (cep.length != 8) {
      throw CepNaoEncontradoException('CEP deve conter 8 números');
    }

    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    final resposta = await http.get(url).timeout(
      const Duration(seconds: 8),
      onTimeout: () =>
          throw CepNaoEncontradoException('Tempo esgotado ao buscar o CEP'),
    );

    if (resposta.statusCode != 200) {
      throw CepNaoEncontradoException('Não foi possível buscar o CEP');
    }

    final dados = json.decode(resposta.body) as Map<String, dynamic>;

    if (dados['erro'] == true) {
      throw CepNaoEncontradoException('CEP não encontrado');
    }

    return EnderecoCep.fromJson(dados);
  }

  /// Aplica a máscara 00000-000 enquanto o usuário digita.
  static String aplicarMascara(String valor) {
    final digitos = valor.replaceAll(RegExp(r'[^0-9]'), '');
    final limitado = digitos.length > 8 ? digitos.substring(0, 8) : digitos;
    if (limitado.length <= 5) return limitado;
    return '${limitado.substring(0, 5)}-${limitado.substring(5)}';
  }
}
