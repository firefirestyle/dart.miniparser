part of core;

abstract class Reader {
  bool _immutable = false;
  Completer<bool> _completerFin = new Completer();

  Future<int> getIndex(int index, int length);
  Future<List<int>> getBytes(int index, int length, {List<int> out: null});
  Future<int> getLength();
  int get currentSize;
  int operator [](int index);

  Completer<bool> get rawcompleterFin => _completerFin;
  Future<bool> getStockedSignal() {
    return _completerFin.future;
  }

  Future<List<int>> getAllBytes({bool allowMalformed: true}) async {
    await getStockedSignal();
    int length = await getLength();
    return await getBytes(0, length);
  }

  Future<String> getString({bool allowMalformed: true}) async {
    return convert.UTF8.decode(await getAllBytes(), allowMalformed: allowMalformed);
  }

  void fin() {
    immutable = true;
  }

  bool get immutable => _immutable;
  void set immutable(bool v) {
    bool prev = _immutable;
    _immutable = v;
    if (prev == false && v == true) {
      _completerFin.complete(v);
    }
  }

  void clearInnerBuffer(int len) {
    ;
  }
}
