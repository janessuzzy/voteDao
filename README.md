# voteDao

[VoteDAO](https://votedao.netlify.app/) is a decentralized voting system that enables transparent and secure governance. It allows users to create proposals, vote in a fair manner, and view real-time results—all on the blockchain.

## Key Features

- <strong>Proposal Creation:</strong> Create proposals with predefined deadlines.
- <strong>One Person, One Vote:</strong> Prevents double voting to ensure fairness.
- <strong>Live Results:</strong> View real-time voting results transparently on-chain.

## Technologies Used

- **Solidity:** Smart contract development for Ethereum.
- **Hardhat:** Development, testing, and deployment framework.
- **HTML/CSS:** Responsive and user-friendly frontend.
- **JavaScript:** Blockchain interaction using Ethers.js.

## Setup Instructions

1. Clone the Repository:
   `   git clone https://github.com/yourusername/VoteDAO.git <br>
cd VoteDAO`

2. Install Dependencies:
   `npm install`

3. Deploy Smart Contract:
   `npx hardhat run scripts/deploy.ts --network localhost`

4. Run the Frontend:
   Open `index.html` in your browser.

## How to Use

- <strong>Create Proposals:</strong> Only the contract manager can create proposals.
- <strong>Vote:</strong> Users can vote once per proposal.
- <strong>Track Results:</strong> Use the "getProposalResults" function to view live voting results.

## License

This project is licensed under the MIT License.

---

Contributions are welcome! Feel free to fork this repository, create issues, or submit pull requests.
