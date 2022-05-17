import 'package:emerald/src/emerald.dart';

class Data {
  final List<int> value;

  final bool isValid;

  Data(this.value, this.isValid);
}

void main() {
  var map = <String, Data>{
    'data': Data([1, 2, 3], true)
  };

  // Serializes instance
  var json = Emerald.serialize(map);

  print(json);
}
