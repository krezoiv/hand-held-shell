class Store {
  String storeName;

  String storeId;

  Store({
    required this.storeName,
    required this.storeId,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        storeName: json["storeName"],
        storeId: json["storeId"],
      );

  Map<String, dynamic> toJson() => {
        "storeName": storeName,
        "storeId": storeId,
      };
}
