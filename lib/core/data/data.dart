part of core;

abstract class AsyncDataBuilder {
  Future<AsyncData> createData(String path);
}

abstract class AsyncData implements DataReader, DataWriter {
  bool get writable => false;
  bool get readable => false;
  Future<int> getLength();
  Future<WriteResult> write(Object buffer, int start,[int length=null]);
  Future<ReadResult> read(int offset, int length, {List<int> tmp: null});
  void beToReadOnly();
}

abstract class DataWriter {
  Future<int> getLength();
  Future<WriteResult> write(Object o, int start,[int length=null]);
}

abstract class DataReader {
  Future<int> getLength();
  Future<ReadResult> read(int offset, int length);
}

class WriteResult {}

class ReadResult {
  List<int> buffer;
  int length = 0;
  ReadResult(List<int> _buffer, [int length = -1]) {
    buffer = _buffer;
    if (length < 0) {
      this.length = _buffer.length;
    } else {
      this.length = length;
    }
  }
}
