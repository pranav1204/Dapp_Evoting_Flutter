import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:voting_dapp/utils/constants.dart';
import 'package:web3dart/web3dart.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString('assets/abi.json');
  String contractAddress = contractAddress1;
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'Election'),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

Future<String> callFunction(String functionName, List<dynamic> args,
    Web3Client ethClient, String privateKey) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(functionName);
  final result = await ethClient.sendTransaction(
    credentials,
    Transaction.callContract(
        contract: contract, function: ethFunction, parameters: args),
    chainId: null,
    fetchChainIdFromNetworkId: true,
  );
  return result;
}

Future<String> startElection(String name, Web3Client ethClient) async {
  var response =
      await callFunction('startElection', [name], ethClient, ownerPrivateKey);
  if (kDebugMode) {
    print('Election Start Successfully');
  }
  return response;
}

Future<String> addCandidate(String name, Web3Client ethClient) async {
  var response =
      await callFunction('addCandidate', [name], ethClient, ownerPrivateKey);
  if (kDebugMode) {
    print('Candidate Added Successfully');
  }
  return response;
}

Future<String> authorizedVoter(String address, Web3Client ethClient) async {
  var response = await callFunction('authorisedVoter',
      [EthereumAddress.fromHex(address)], ethClient, ownerPrivateKey);
  if (kDebugMode) {
    print('Voter Authorized Successfully');
  }
  return response;
}

Future<List> getCandidatesNum(Web3Client ethClient) async {
  List<dynamic> result = await ask('getNumCandidates', [], ethClient);
  return result;
}

Future<List> totalVote(Web3Client ethClient) async {
  List<dynamic> result = await ask('totalVote', [], ethClient);
  return result;
}

Future<List> candidateInfo(int index, Web3Client ethClient) async {
  List<dynamic> result =
      await ask('CandidateInfo', [BigInt.from(index)], ethClient);
  return result;
}

Future<List<dynamic>> ask(
    String functionName, List<dynamic> args, Web3Client ethClient) async {
  final contract = await loadContract();
  final ethFunction = contract.function(functionName);
  final result =
      ethClient.call(contract: contract, function: ethFunction, params: args);
  return result;
}

Future<String> vote(int candidateIndex, Web3Client ethClient) async {
  var response = await callFunction(
      'vote', [BigInt.from(candidateIndex)], ethClient, voterPrivateKey);
  if (kDebugMode) {
    print('Vote Counted Successfully');
  }
  return response;
}
