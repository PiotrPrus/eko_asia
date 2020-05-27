class BinResponse {
  final int binType;
  final Set<String> products;

  String binName() {
    return "Happy Bin";
  }

  BinResponse(this.binType, this.products);
}