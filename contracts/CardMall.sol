pragma solidity >=0.4.22 <0.9.0;

contract CardMall {

  address public seller;

  constructor() public payable {
    seller = msg.sender;
  }

  struct Card {
    string name;
    string description;
    uint price;
    uint quantity;
  }

  Card[] cardList;

  struct Order {
    address seller;
    address buyer;
    string cardName;
    uint price;
    uint quantity;
  }

  Order[] orderList;

  // 카드 등록
  function registerCard(string memory name, string memory desc, uint price, uint quantity) public {
    require(seller == msg.sender);
    for(uint i = 0; i < cardList.length; i++){
      require(!compareString(cardList[i].name, name));
    }
    cardList.push(Card(name, desc, price, quantity));
  }
  
  // 판매된 카드 목록 조회
  function findPurchasedCardAll() public view returns(Order[] memory){
    require(seller == msg.sender);
    return orderList;
  }

  // 판매 중인 카드 목록 조회
  function findCardAll() public view returns(Card[] memory){
    require(seller == msg.sender);
    return cardList;
  }

  // 카드 구매
  function purchaseCard(string memory name, uint payPrice, uint payQuantity) public payable {
    require(seller != msg.sender);
    require(payPrice > 0 && payQuantity > 0);
    for(uint i = 0; i < cardList.length; i++){
      if(compareString(cardList[i].name, name)){
        require(cardList[i].price * cardList[i].quantity <= payPrice * payQuantity);
        cardList[i].quantity = cardList[i].quantity - payQuantity;
        orderList.push(Order(seller, msg.sender, cardList[i].name, payPrice, payQuantity));
        payable(msg.sender).transfer(payPrice * payQuantity);
        break;
      }
    }
  }

  // 내 카드 목록 조회
  function findPurchasedCardListByAddress() public view returns(Order[] memory){
    require(seller != msg.sender);
    Order[] memory purchasedCardList;
    for(uint i = 0; i < orderList.length; i++){
      if(orderList[i].buyer == msg.sender){
        purchasedCardList.push(orderList[i]);
      }
    }
    return purchasedCardList;
  }

  // String 비교
  function compareString(string memory a, string memory b) private pure returns (bool) {
    return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
  }
}