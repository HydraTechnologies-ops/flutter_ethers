# Flutter_Ethers For Flutter


Fluter_Ethers is a dart library that connects to interact with the Ethereum blockchain and inspired by [ethers.js](https://github.com/ethers-io/ethers.js/) and [ethers](https://pub.dev/packages/ethers/).

## Installing

Add Flutter_Ethers to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_ethers:
```

Import `Flutter_Ethers` in files that it will be used:

```yaml
import 'package:flutter_ethers/flutter_ethers.dart';
```

## Usage

### Provider

```dart
const provider = ethers.providers.JsonRpcProvider();

// Look up the current block number
await provider.getBlockNumber();
// Output: 14135476

// Get the balance of an account (by address or ENS name, if supported by network)
final balance = await provider.getBalance("0x0000000000000000000000000000000000000000");
// Output: { BigInt: "10478645750785322678769" }

// Often you need to format the output to something more user-friendly,
// such as in ether (instead of wei)
print(ethers.utils.formatEther(balance));
// Output: '10478.645750785321'

// If a user enters a string in an input field, you may need
// to convert it from ether (as a string) to wei (as a BigNumber)
print(ethers.utils.parseEther("1.0"));
// Output: { BigInt: "1000000000000000000" }

```

### Wallet

```dart
// Create a wallet instance from a mnemonic...
final mnemonic = "announce room limb pattern dry unit scale effort smooth jazz weasel alcohol";
final walletMnemonic = Wallet.fromMnemonic(mnemonic);

// ...or from a private key
final walletPrivateKey = Wallet(walletMnemonic.privateKey);

print(walletMnemonic.address == walletPrivateKey.address);
// Output: true

// The address as a Promise per the Signer API
print(walletMnemonic.getAddress());
// Output: '0x71CB05EE1b1F506fF321Da3dac38f25c0c9ce6E1'

// The address as a property
print(walletMnemonic.address);
// Output: '0x71CB05EE1b1F506fF321Da3dac38f25c0c9ce6E1'

// The internal cryptographic components
print(walletMnemonic.privateKey);
// Output: '0x1da6847600b0ee25e9ad9a52abbd786dd2502fa4005dd5af9310b7cc7a3b25db'
print(walletMnemonic.publicKey);
// Output: '0x04b9e72dfd423bcf95b3801ac93f4392be5ff22143f9980eb78b3a860c4843bfd04829ae61cdba4b3b1978ac5fc64f5cc2f4350e35a108a9c9a92a81200a60cd64'

// The wallet mnemonic
print(walletMnemonic.mnemonic);
// Output: {
//   locale: 'en',
//   path: "m/44'/60'/0'/0/0",
//   phrase: 'announce room limb pattern dry unit scale effort smooth jazz weasel alcohol'
// }

// Note: A wallet created with a private key does not
//       have a mnemonic (the derivation prevents it)
print(walletPrivateKey.mnemonic);
// Output: null


```
