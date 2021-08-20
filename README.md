# eth-card-purchase-example
Ethereum Smart Contract를 활용한 카드 판매 프로젝트 예제입니다.
## Prerequisite
| 환경 | 설명 |
| ------ | ------ |
| MacOS | OS |
| Virtual Studio Code | IDE |
| Node.js | Javascript Runtime, v8.9.4 or later |
| Solidity | Ethereum Smart Contract Language, 0.8.7 |
| Truffle | Solidity Framework |
| Ganache | Ethereum Test Blockchain(Optional) |
## Using Truffle Only.
- Visual Studio Code를 실행합니다.
- Visual Studio Code에서 이 프로젝트를 엽니다.
- Visual Studio Code 통합 터미널을 엽니다.
- 통합 터미널에서 다음 명령어를 실행하여 테스트 노드를 실행합니다.
   ```sh
  truffle develop  
  ```
- 통합 터미널에서 다음 명령어를 실행하여 Smart Contract를 테스트합니다.
   ```sh
  truffle) test  
  ```
## Using Ganache
- Visual Studio Code를 실행합니다.
- Visual Studio Code에서 이 프로젝트를 엽니다.
- Visual Studio Code 통합 터미널을 엽니다.
- Ganache를 실행합니다.
- Ganache에서 Quickstart를 선택합니다.
- 이 프로젝트의 truffle-config.js에서 다음 내용을 Ganache에 맞게 수정합니다.
   ```sh
        .
        .
        .
    development: {
     host: "127.0.0.1",     // Localhost (default: none)
     port: 7545,            // Standard Ethereum port (default: none)
     network_id: "*",       // Any network (default: none)
    }
        .
        .
        .
  ```
- 통합 터미널에서 다음 명령어를 실행하여 Smart Contract를 테스트합니다.
   ```sh
  truffle test
  ```
- Ganache에서 테스트 결과를 UI로 확인합니다.
