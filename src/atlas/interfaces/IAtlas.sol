//SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.28;

import "../types/SolverOperation.sol";
import "../types/UserOperation.sol";
import "../types/DAppOperation.sol";
import "../types/LockTypes.sol";

interface IAtlas {
    // Atlas.sol
    function metacall(
        UserOperation calldata userOp,
        SolverOperation[] calldata solverOps,
        DAppOperation calldata dAppOp,
        address gasRefundBeneficiary
    )
        external
        payable
        returns (bool auctionWon);

    // Factory.sol
    function createExecutionEnvironment(
        address user,
        address control
    )
        external
        returns (address executionEnvironment);
    function getExecutionEnvironment(
        address user,
        address control
    )
        external
        view
        returns (address executionEnvironment, uint32 callConfig, bool exists);

    // AtlETH.sol
    function accountLastActiveBlock(address account) external view returns (uint256);

    function withdrawSurcharge() external;
    function transferSurchargeRecipient(address newRecipient) external;
    function becomeSurchargeRecipient() external;
    function setSurchargeRates(uint128 newAtlasRate, uint128 newBundlerRate) external;

    // Permit69.sol
    function transferUserERC20(
        address token,
        address destination,
        uint256 amount,
        address user,
        address control
    )
        external;
    function transferDAppERC20(
        address token,
        address destination,
        uint256 amount,
        address user,
        address control
    )
        external;

    // GasAccounting.sol
    function contribute() external payable;
    function borrow(uint256 amount) external payable;
    function shortfall() external view returns (uint256 gasLiability, uint256 borrowLiability);
    function reconcile(uint256 maxApprovedGasSpend) external payable returns (uint256 owed);

    // SafetyLocks.sol
    function isUnlocked() external view returns (bool);

    // Storage.sol
    function VERIFICATION() external view returns (address);
    function SIMULATOR() external view returns (address);
    function L2_GAS_CALCULATOR() external view returns (address);
    function ESCROW_DURATION() external view returns (uint256);
    function SHMONAD() external view returns (address);
    function POLICY_ID() external view returns (uint64);

    function solverLockData() external view returns (address currentSolver, bool calledBack, bool fulfilled);
    function accessData(address account)
        external
        view
        returns (uint32 lastAccessedBlock, uint24 auctionWins, uint24 auctionFails, uint64 totalGasValueUsed);
    function solverOpHashes(bytes32 opHash) external view returns (bool);
    function lock() external view returns (address activeEnvironment, uint32 callConfig, uint8 phase);
    function solverLock() external view returns (uint256);
    function cumulativeSurcharge() external view returns (uint256);
    function surchargeRecipient() external view returns (address);
    function pendingSurchargeRecipient() external view returns (address);
    function getAtlasSurchargeRate() external view returns (uint256);
}
