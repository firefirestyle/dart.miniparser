import 'package:test/test.dart' as unit;
import 'package:miniparser/core.dart';

void main() {
  unit.test("nextBuffer", () async {
    {
      BytesReader b = new BytesReader();
      b.appendIntList([1, 2, 3, 4, 5]);
      MiniParser parser = new MiniParser(b);
      List<int> bb = await parser.nextBuffer(3);
      unit.expect(bb, [1, 2, 3]);
    }
  });

  unit.test("nextString", () async {
    {
      BytesReader b = new BytesReader();
      b.appendString("abc");
      MiniParser parser = new MiniParser(b);
      String bb = await parser.nextString("abc");
      unit.expect(bb, "abc");
    }
  });

  unit.test("readSign", () async {
    {
      BytesReader b = new BytesReader();
      b.appendString("abc");
      MiniParser parser = new MiniParser(b);
      String bb = await parser.readStringWithLength(2);
      unit.expect(bb, "ab");
    }
  });
  unit.test("readShort", () async {
    {
      BytesReader b = new BytesReader();
      b.appendIntList(ByteOrder.parseShortByte(10, ByteOrderType.BigEndian));
      MiniParser parser = new MiniParser(b);
      int bb = await parser.readShort(ByteOrderType.BigEndian);
      unit.expect(bb, 10);
    }
  });


  unit.test("readInt", () async {
    {
      BytesReader b = new BytesReader();
      b.appendIntList(ByteOrder.parseIntByte(10, ByteOrderType.LittleEndian));
      MiniParser parser = new MiniParser(b);
      int bb = await parser.readInt(ByteOrderType.LittleEndian);
      unit.expect(bb, 10);
    }
  });

  unit.test("readLong", () async {
    {
      BytesReader b = new BytesReader();
      b.appendIntList(ByteOrder.parseLongByte(10, ByteOrderType.LittleEndian));
      MiniParser parser = new MiniParser(b);
      int bb = await parser.readLong(ByteOrderType.LittleEndian);
      unit.expect(bb, 10);
    }
  });

  unit.test("readByte", () async {
    {
      BytesReader b = new BytesReader();
      b.appendByte(10);
      MiniParser parser = new MiniParser(b);
      int bb = await parser.readByte();
      unit.expect(bb, 10);
    }
  });

  unit.test("nextBuffer", () async {
    {
      BytesReader b = new BytesReader();
      b.appendIntList([1,2,3,4,5,6]);
      MiniParser parser = new MiniParser(b);
      List<int> b1 = await parser.nextBuffer(3);
      unit.expect(b1, [1,2,3]);
      List<int> b2 = await parser.nextBuffer(3);
      unit.expect(b2, [4,5,6]);
    }
  });

}
