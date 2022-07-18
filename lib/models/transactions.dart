class Transaction {
  final String title;
  final int price;
  final String id;
  final DateTime dateTime;

  Transaction(
      {required this.dateTime,
      required this.price,
      required this.title,
      required this.id});
}
