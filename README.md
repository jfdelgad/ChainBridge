# ChainBridge

ChainBridge is a system that allows sending tokens between different chains. The system's architecture is described in Figure 1.


![Figure 1](https://github.com/jfdelgad/ChainBridge/blob/master/images/bridge.png)

The Bridge is composed of several nodes that validate the information collected from each network, achieve consensus and execute changes.  Nodes in the bridge get logs from one network and execute a specific function in the second network based on that information.  Consensus about data provided to each contract should be achieved in order to avoid fraud.

For private operations, the bridge could be a set of servers (to make the system resistant to failure) controlled by the organization. 

The repository shows an example of this using two Ethereum test networks and a centralized node as a bridge (for the sake of the example). A token contract is deployed in Rinkeby and also in Ropsten. The system allows token holders to transfer tokens between Rinkeby and Ropsten, and vice-versa. As the Bridge needs to execute transactions that have cost in the form of gas, the user pays a fee, in tokens, that is deducted from the amount transfered to the other network. The number of tokens remains constant and this is enforced by both smart contracts' logic.

The system is live (for a few days starting on September 14). The addresses of the contracts are:

| Network | Address|
|----------|---------|
|Ropsten|0x169bd27cbd9f4bcd1626480cb75f36806f439952|
|Rinkeby|0xd8ee680167527e39300bc40336cc36ba84d6cba3|

To get tokens you can use the functions buy (for free, just use test Ether).



