class CharactersParams {
  String? page;

  CharactersParams({
    this.page,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
    };
  }

  void setPage(String value) {
    page = value;
  }

  static CharactersParams empty() {
    return CharactersParams(page: '');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CharactersParams && other.page == page;
  }

  @override
  int get hashCode {
    return page.hashCode;
  }

  @override
  String toString() {
    return 'CharactersParams(page: $page)';
  }
}
