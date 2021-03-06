pragma solidity ^0.5.0;

contract BasicProvenance {
    //Set of States
    enum StateType { Created, InTransit, Completed}

    //List of properties
    StateType public  State;
    address public  InitiatingCounterparty;
    address public  Counterparty;
    address public  PreviousCounterparty;
    address public  SupplyChainOwner;
    address public  SupplyChainObserver;

    event LogContractCreated(string applicationName, string workflowName, address originatingAddress);
    event LogContractUpdated(string applicationName, string workflowName, string action, address originatingAddress);

    string internal ApplicationName;
    string internal WorkflowName;

    constructor(address supplyChainOwner, address supplyChainObserver) public {
        InitiatingCounterparty = msg.sender;
        Counterparty = InitiatingCounterparty;
        SupplyChainOwner = supplyChainOwner;
        SupplyChainObserver = supplyChainObserver;
        State = StateType.Created;
        ApplicationName = "BasicProvenance";
        WorkflowName = "BasicProvenance";
        emit LogContractCreated(ApplicationName, WorkflowName, msg.sender);
    }

    function TransferResponsibility(address newCounterparty) public {
        if (Counterparty != msg.sender || State == StateType.Completed) {
            revert("old CounterParty must be msg sender and not completed");
        }

        if (State == StateType.Created) {
            State = StateType.InTransit;
        }

        PreviousCounterparty = Counterparty;
        Counterparty = newCounterparty;
        emit LogContractUpdated(ApplicationName, WorkflowName, "TransferResponsibility", msg.sender);
    }

    function Complete() public {
        if (SupplyChainOwner != msg.sender || State == StateType.Completed) {
            revert("complete must be called by the owner and not completed");
        }
        State = StateType.Completed;
        PreviousCounterparty = Counterparty;
        Counterparty = address(0x0);
        emit LogContractUpdated(ApplicationName, WorkflowName, "Complete", msg.sender);
    }
}
