class Item {
  String nome;
  double preco;
  Item({required this.nome, required this.preco});

//Teste de igualdade Modelo 02
@override
  bool operator == (Object other) {
    if (identical(this, other)) return true;

    return other is Item && other.nome == nome && other.preco == preco;
  }
  
  @override
  int get hashCode => nome.hashCode ^ preco.hashCode; 
}


