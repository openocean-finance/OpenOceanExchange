// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

library ExternalCall {
    // Source: https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
    // call has been separated into its own function in order to take advantage
    // of the Solidity's code generator to produce a loop that copies tx.data into memory.
    function externalCall(
        address target,
        uint256 value,
        bytes memory data,
        uint256 dataOffset,
        uint256 dataLength,
        uint256 gasLimit
    ) internal returns (bool result) {
        if (gasLimit == 0) {
            gasLimit = gasleft() - 40000;
        }
        assembly {
            let x := mload(0x40) // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
            let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
            result := call(
                gasLimit,
                target,
                value,
                add(d, dataOffset),
                dataLength, // Size of the input (in bytes) - this is what fixes the padding problem
                x,
                0 // Output is ignored, therefore the output size is zero
            )
        }
    }
}
