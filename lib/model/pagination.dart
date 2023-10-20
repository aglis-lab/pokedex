class Pagination<T> {
  Pagination({required this.total, required this.data});

  int total;
  List<T> data;
}
