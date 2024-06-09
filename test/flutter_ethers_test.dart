import 'package:flutter_ethers/flutter_ethers.dart';
import 'package:test/test.dart';

final provider = JsonRpcProvider('YOUR_RPC_URL_HERE');

void main() {
  test('Flutter Ethers', () async {
    final blockNumber = await provider.getBlockNumber();
    expect(blockNumber, isNot(0));
  });

  test('Querying the Blockchain', () async {
    // Look up the current block number
    final blockNumber = await provider.getBlockNumber();
    expect(blockNumber, isNot(0));

    // Get the balance of an account (by address or ENS name, if supported by network)
    final balance = await provider.getBalance("0x0000000000000000000000000000000000000000");
    expect(balance, isA<BigInt>());

    // Format the output to something more user-friendly, such as in ether (instead of wei)
    final formattedBalance = ethers.utils.formatEther(balance);
    print('Formatted Balance: $formattedBalance');
    expect(formattedBalance, isA<String>());

    // Convert ether (as a string) to wei (as a BigNumber)
    final parsedEther = ethers.utils.parseEther("1.0");
    print('Parsed Ether: $parsedEther');
    expect(parsedEther, isA<BigInt>());
  }, tags: ['runOnNewChain']);
}
