// 🌎 Project imports:
import 'package:flutter_ethers/src/providers/json_rpc_provider.dart';
import 'package:flutter_ethers/src/providers/provider.dart';
import 'package:flutter_ethers/src/signers/signer.dart';

class JsonRpcSigner extends Signer {
  final JsonRpcProvider childProvider;
  final int? index;
  final String? address;

  JsonRpcSigner({
    required this.childProvider,
    this.address,
    this.index = 0,
  }) {
    provider = childProvider;
  }

  @override
  JsonRpcSigner connect(Provider provider) {
    throw 'cannot alter JSON-RPC Signer connection';
  }

  @override
  Future<String> getAddress() async {
    // TODO:
    return '';
  }

  @override
  signMessage() {}

  @override
  signTransaction() {}

  connectUnchecked(Provider provider) {
    // TODO:
  }

  // @override
  // Future<BigInt> getBalance({
  //   BlockTag? blockTag,
  // }) async {
  //   return await provider.getBalance();
  // }
}
