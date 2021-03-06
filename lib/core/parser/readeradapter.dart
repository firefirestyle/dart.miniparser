
part of core;
class ReaderAdapter extends Reader {
  Reader _base = null;
  int _startIndex = 0;
  int operator [](int index) {
    return _base[index + _startIndex];
  }

  ReaderAdapter(Reader builder, int startIndex) {
    _base = builder;
    _startIndex = startIndex;
  }

  Future<int> getLength() {
    Completer<int> completer = new Completer();
    _base.getLength().then((int v) {
      completer.complete(v - _startIndex);
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  int get currentSize {
    return _base.currentSize;
  }

  //
  Future<bool> notifyImmutable() => _base.notifyImmutable();

  Future<List<int>> getBytes(int index, int length, {List<int> out: null}) async {
    return await _base.getBytes(index + _startIndex, length);
  }

  Future<int> getIndex(int index, int length) async {
    return await _base.getIndex(index + _startIndex, length);
  }

  void completeDataAppending() {
    _base.completeDataAppending();
  }

  bool get immutable => _base.immutable;

  void set doImmutable(bool v) {
    _base.doImmutable(v);
  }
}
