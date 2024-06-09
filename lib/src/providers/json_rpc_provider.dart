import 'package:flutter_ethers/src/json_rpc.dart' as json_rpc_package;
// import 'package:flutter_ethers/src/providers/json_rpc_provider.dart' as provider_package;
import 'package:http/http.dart';
// import 'dart:convert';

// 🌎 Project imports:
import 'package:flutter_ethers/src/crypto/formatting.dart';
import 'package:flutter_ethers/src/params/block_tag.dart';
import 'package:flutter_ethers/src/providers/provider.dart';
import 'package:flutter_ethers/src/providers/types/block.dart';
import 'package:flutter_ethers/src/providers/types/transaction_types.dart';
import 'package:flutter_ethers/src/signers/json_rpc_signer.dart';

const defaultURL = 'http://localhost:8545';

class JsonRpcProvider extends Provider {
  late final json_rpc_package.JsonRPC _jsonRPC;

  JsonRpcProvider(String? _url) {
    final String url = _url ?? defaultURL;
    _jsonRPC = json_rpc_package.JsonRPC(url, Client());
  }

  String defaultUrl() {
    return defaultURL;
  }

  Future<void> detectNetwork() async {
    try {
      final response = await _jsonRPC.call('net_version', []);
      print('Network ID: $response');
    } catch (e) {
      print('Error detecting network: $e');
    }
  }

  JsonRpcSigner getSigner() {
    return JsonRpcSigner(
      childProvider: this,
    );
  }

  JsonRpcSigner getUncheckedSigner({
    String? address,
    int? index,
  }) {
    return JsonRpcSigner(
      childProvider: this,
      address: address,
      index: index,
    );
  }

  Future<List<String>> listAccounts() async {
    final accounts = await send<List<dynamic>>('eth_accounts', params: []);
    return accounts.cast<String>();
  }

  Future<T> send<T>(String function, {List<dynamic>? params}) {
    return _makeRPCCall<T>(function, params);
  }

  bool printErrors = false;

  Future<T> _makeRPCCall<T>(String function, [List<dynamic>? params]) async {
    try {
      final data = await _jsonRPC.call(function, params);
      if (data is Error || data is Exception) throw data;
      return data.result as T;
    } catch (e) {
      if (printErrors) print(e);
      rethrow;
    }
  }

  Future<int> getBlockNumber() {
    return _makeRPCCall<String>('eth_blockNumber')
        .then((s) => hexToInt(s).toInt());
  }

  Future<BigInt> getGasPrice() async {
    final data = await _makeRPCCall<String>('eth_gasPrice');
    return hexToInt(data);
  }

  @override
  Future<BigInt> getBalance(
    String address, {
    BlockTag? blockTag,
  }) {
    final bt = blockTag?.toParam() ?? const BlockTag.latest().toParam();
    return _makeRPCCall<String>('eth_getBalance', [address.toLowerCase(), bt])
        .then((data) {
      return hexToInt(data);
    });
  }

  @override
  Future<int> getTransactionCount(
    String address, {
    BlockTag? blockTag,
  }) {
    final bt = blockTag?.toParam() ?? const BlockTag.latest().toParam();
    return _makeRPCCall<String>(
      'eth_getTransactionCount',
      [address.toLowerCase(), bt],
    ).then((data) {
      return hexToInt(data).toInt();
    });
  }

  @override
  Future<String> getCode(
    String address, {
    BlockTag? blockTag,
  }) {
    final bt = blockTag?.toParam() ?? const BlockTag.latest().toParam();
    return _makeRPCCall<String>('eth_getCode', [address.toLowerCase(), bt]);
  }

  @override
  Future<String> getStorageAt(
    String address,
    BigInt position, {
    BlockTag? blockTag,
  }) {
    final bt = blockTag?.toParam() ?? const BlockTag.latest().toParam();
    return _makeRPCCall<String>(
        'eth_getStorageAt', [address, '0x${position.toRadixString(16)}', bt]);
  }

  @override
  Future<TransactionResponse> getTransaction(String transactionHash) async {
    final responseMap = await _makeRPCCall<Map<String, dynamic>>(
      'eth_getTransactionByHash',
      [transactionHash],
    );
    return TransactionResponse(
      hash: responseMap['hash'],
      confirmations: responseMap['confirmations'],
      from: responseMap['from'],
    );
  }

  @override
  Future<TransactionReceipt> getTransactionReceipt(String hash) async {
    final res = await _makeRPCCall<Map<String, dynamic>>(
      'eth_getTransactionReceipt',
      [hash],
    );
    return TransactionReceipt(
      to: res['to'],
      from: res['from'],
      contractAddress: res['contractAddress'],
      transactionIndex: res['transactionIndex'],
      gasUsed: res['gasUsed'],
      logsBloom: res['logsBloom'],
      blockHash: res['blockHash'],
      transactionHash: res['transactionHash'],
      logs: res['logs'],
      blockNumber: res['blockNumber'],
      confirmations: res['confirmations'],
      cumulativeGasUsed: res['cumulativeGasUsed'],
      effectiveGasPrice: res['effectiveGasPrice'],
      byzantium: res['byzantium'],
      type: res['type'],
    );
  }

  @override
  Future<BigInt> estimateGas(TransactionRequest transaction) async {
    final amountHex = await _makeRPCCall<String>('eth_estimateGas', [
      transaction.toJSON(),
    ]);
    return hexToInt(amountHex);
  }

  @override
  Future<String> call(
    TransactionRequest transaction, {
    BlockTag? blockTag,
  }) async {
    final bt = blockTag?.toParam() ?? const BlockTag.latest().toParam();
    return await _makeRPCCall<String>('eth_call', [
      {
        'to': transaction.to,
        'data': transaction.data,
        if (transaction.from != null) 'from': transaction.from,
      },
      bt,
    ]);
  }

  @override
  Future<TransactionResponse> sendTransaction(TransactionRequest transaction) {
    throw UnimplementedError();
  }

  @override
  Future<Block> getBlock(BlockTag blockTag) {
    throw UnimplementedError();
  }

  @override
  Future<BlockWithTransactions> getBlockWithTransactions(BlockTag blockTag) {
    throw UnimplementedError();
  }

  @override
  Future<List<Log>> getLogs(Filter filter) {
    throw UnimplementedError();
  }

  @override
  Future<String?> lookupAddress(String address) {
    throw UnimplementedError();
  }

  @override
  Future<String?> resolveName(String name) {
    throw UnimplementedError();
  }
}
