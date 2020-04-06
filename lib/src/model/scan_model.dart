class ScanModel {
  int id;
  String valor;

  ScanModel({
    this.id,
    this.valor,
  });

  factory ScanModel.fromJson(Map<String, dynamic> json) => new ScanModel(
        id: json["id"],
        valor: json["valor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "valor": valor,
      };
}
