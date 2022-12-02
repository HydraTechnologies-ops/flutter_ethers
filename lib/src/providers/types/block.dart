// 🌎 Project imports:
import 'package:flutter_ethers/src/providers/types/transaction_types.dart';

class Block {
  final List<String> transactions;

  Block({required this.transactions});
}

class BlockWithTransactions {
  final List<TransactionResponse> transactions;
  BlockWithTransactions({required this.transactions});
}
