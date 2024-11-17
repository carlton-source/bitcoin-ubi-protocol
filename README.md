# Bitcoin-backed Universal Basic Income Protocol

A decentralized Universal Basic Income (UBI) system implemented as a smart contract, allowing for automated distribution of regular payments to verified participants. The protocol is built with governance features and safety mechanisms to ensure sustainable and secure operation.

## Features

- **Participant Management**

  - User registration system
  - Verification process for eligible participants
  - Tracking of claim history and participant status

- **UBI Distribution**

  - Automated periodic distributions
  - Configurable distribution amounts
  - Cooldown periods between claims
  - Treasury management with minimum balance requirements

- **Governance System**

  - Proposal submission and voting mechanism
  - Configurable protocol parameters
  - Democratic decision-making process
  - Time-bound voting periods

- **Safety Features**
  - Emergency pause/unpause functionality
  - Treasury balance checks
  - Owner-only administrative functions
  - Value limits and validation checks

## Technical Details

### Constants

- Distribution Interval: 144 blocks (~1 day)
- Minimum Treasury Balance: 10,000,000 microSTX
- Maximum Proposal Value: 1,000,000,000,000 microSTX

### Error Codes

- `100`: Owner-only operation
- `101`: Already registered
- `102`: Not registered
- `103`: Ineligible for claim
- `104`: Cooldown period active
- `105`: Insufficient funds
- `106`: Invalid amount
- `107`: Unauthorized operation
- `108`: Invalid proposal
- `109`: Expired proposal
- `110`: Invalid value

## Usage

### For Participants

1. **Registration**

```clarity
(contract-call? .ubi-protocol register)
```

2. **Claiming UBI**

```clarity
(contract-call? .ubi-protocol claim-ubi)
```

3. **Contributing to Treasury**

```clarity
(contract-call? .ubi-protocol contribute)
```

### For Governance

1. **Submit Proposal**

```clarity
(contract-call? .ubi-protocol submit-proposal "distribution-amount" u1000000)
```

2. **Vote on Proposal**

```clarity
(contract-call? .ubi-protocol vote u1 true)
```

### For Administrators

1. **Verify Participant**

```clarity
(contract-call? .ubi-protocol verify-participant 'SP2J6ZY48GV1EZ5V2V5RB9MP66SW86PYKKNRV9EJ7)
```

2. **Emergency Controls**

```clarity
(contract-call? .ubi-protocol pause)
(contract-call? .ubi-protocol unpause)
```

## Governance Parameters

The following parameters can be modified through governance proposals:

- Distribution amount
- Distribution interval
- Minimum treasury balance

## Query Functions

- `get-participant-info`: Retrieve participant details
- `get-treasury-balance`: Check current treasury balance
- `get-proposal`: View proposal details
- `get-distribution-info`: Get current distribution parameters

## Security Considerations

1. All monetary operations include balance checks and overflow protection
2. Administrative functions are protected by owner-only access
3. Participant verification prevents fraudulent claims
4. Cooldown periods prevent abuse of the distribution system
5. Emergency pause functionality for crisis management

## Notes

- Participants must be verified before claiming UBI
- Claims are subject to cooldown periods
- Treasury must maintain minimum balance
- Governance proposals expire after 1440 blocks
- Contract can be paused in emergency situations

## Contributing

Contributions to improve the protocol are welcome. Please ensure all proposed changes:

1. Include appropriate test coverage
2. Maintain existing security measures
3. Follow the established error handling patterns
4. Include documentation updates

## License

This protocol is released under the MIT License. See the LICENSE file for details.
