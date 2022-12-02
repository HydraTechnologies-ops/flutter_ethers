library flutter_ethers;

import 'package:flutter_ethers/src/providers/json_rpc_provider.dart';
import 'package:flutter_ethers/src/utils/utils.dart';

// 🌎 Project imports:

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

final ethers = Ethers();

class Ethers {
  Providers providers = Providers();

  Utils utils = Utils();
}

class Providers {
  JsonRpcProvider jsonRpcProvider({String? url}) {
    return JsonRpcProvider(url);
  }
}
