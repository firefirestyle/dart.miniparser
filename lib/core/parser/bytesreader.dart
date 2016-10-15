part of core;

class BytesReader extends Reader {
  int _bufferSize = 1024;
  BufferImpl _bufferObj;
  int _length = 0;

  BufferImpl get rawbuffer8 => _bufferObj;
  List<GetByteFutureInfo> mGetByteFutreList = new List();

  int get clearedBuffer => _bufferObj.clearedBuffer;

  bool logon = false;
  BytesReader({bufferSize: 1024,this.logon:false}) {
    _bufferSize = bufferSize;
    _bufferObj = new BufferImpl(_bufferSize); //new data.Uint8List(_max);
  }

  BytesReader.fromList(List<int> buffer, {isImmutable :false}) {
    _bufferObj = new BufferImpl.fromList(buffer);
    _length = buffer.length;
    if (isImmutable == true) {
      completeDataAppending();
    }
  }

  Future<int> getIndex(int index, int length) {
    GetByteFutureInfo info = new GetByteFutureInfo();

    info.completerResultLength = length;
    info.index = index;
    info.completer = new Completer();

    if (false == _updateGetInfo(info)) {
      mGetByteFutreList.add(info);
    }

    return info.completer.future;
  }

  Future<List<int>> getBytes(int index, int length, {List<int> out:null}) async {
    if(out != null && out.length < length) {
      throw new Exception();
    }
    await getIndex(index, length);
    int len = currentSize - index;
    len = (len > length ? length : len);
    if(out == null) {
      out = new data.Uint8List(len >= 0 ? len : 0);
    }
    for (int i = 0; i < len; i++) {
      out[i] = _bufferObj[index + i];
    }
    return out;
  }

  int operator [](int index) => 0xFF & _bufferObj[index];

  int get(int index) => 0xFF & _bufferObj[index];

  void clear() {
    _length = 0;
  }

  void clearInnerBuffer(int len, {reuse: true}) {
    _bufferObj.clearBuffer(len, reuse: reuse);
  }

  int get currentSize => _length;

  Future<int> getLength() async => _length;

  void completeDataAppending() {
    super.completeDataAppending();
    _updateGetInfos();
    mGetByteFutreList.clear();
  }

  void update(int plusLength) {
    if (_length + plusLength < _bufferSize) {
      return;
    } else {
      int nextMax = _length + plusLength + (_bufferSize - _bufferObj.clearedBuffer);
      _bufferObj.expandBuffer(nextMax);
      _bufferSize = nextMax;
    }
  }

  bool appendByte(int v) {
    if (immutable) {
      return false;
    }
    update(1);
    _bufferObj[_length] = v;
    _length += 1;

    _updateGetInfos();
    return true;
  }

  bool appendIntList(List<int> buffer, [int index = 0, int length = -1]) {
    if (immutable) {
      return false;
    }
    if (length < 0) {
      length = buffer.length;
    }
    update(length);

    for (int i = 0; i < length; i++) {
      _bufferObj[_length + i] = buffer[index + i];
    }
    _length += length;
    _updateGetInfos();
    return true;
  }

  bool appendString(String text) => appendIntList(convert.UTF8.encode(text));

  List toList() => _bufferObj.sublist(0, _length);

  data.Uint8List toUint8List() => new data.Uint8List.fromList(toList());

  String toText() => convert.UTF8.decode(toList());
  //
  //
  //
  bool _updateGetInfo(GetByteFutureInfo info) {
    if (this.immutable == true || info.index + info.completerResultLength - 1 < _length) {
      info.completer.complete(info.index);
      return true;
    } else {
      return false;
    }
  }

  void _updateGetInfos() {
    var removeList = null;
    for (GetByteFutureInfo f in mGetByteFutreList) {
      if (true == _updateGetInfo(f)) {
        if (removeList == null) {
          removeList = [];
        }
        removeList.add(f);
      }
    }
    if (removeList != null) {
      for (GetByteFutureInfo f in removeList) {
        mGetByteFutreList.remove(f);
      }
    }
  }
}

class GetByteFutureInfo {
  int completerResultLength = 0;
  int index = 0;
  Completer<int> completer = null;
}
