pragma solidity >=0.4.22 <0.9.0;

contract CardMall {
    address private seller;

    struct User {
        address user;
        uint256 token;
    }

    User[] userList;

    struct Card {
        string name;
        string description;
        uint256 price;
        uint256 quantity;
    }

    Card[] cardList;

    struct Order {
        address seller;
        address buyer;
        string cardName;
        uint256 quantity;
    }

    Order[] orderList;

    constructor() {
        seller = msg.sender;
        userList.push(User(seller, 10000));
    }

    modifier onlySeller() {
        require(seller == msg.sender, "not seller.");
        _;
    }

    modifier onlyBuyer() {
        require(seller != msg.sender, "not buyer.");
        _;
    }

    // 토큰 발급
    function initToken() public onlyBuyer {
        for (uint256 i = 0; i < userList.length; i++) {
            if (userList[i].user == msg.sender) {
                return;
            }
        }
        userList.push(User(msg.sender, 1000));
    }

    // 카드 등록
    function registerCard(
        string memory _name,
        string memory _description,
        uint256 _price,
        uint256 _quantity
    ) public onlySeller {
        for (uint256 i = 0; i < cardList.length; i++) {
            require(!compareString(cardList[i].name, _name));
        }
        cardList.push(Card(_name, _description, _price, _quantity));
    }

    // 판매된 카드 목록 조회
    function findPurchasedCardAll()
        public
        view
        onlySeller
        returns (Order[] memory)
    {
        return orderList;
    }

    // 판매 중인 카드 목록 조회
    function findCardAll() public view returns (Card[] memory) {
        return cardList;
    }

    // 카드 구매
    function purchaseCard(string memory _name, uint256 _payQuantity)
        public
        onlyBuyer
    {
        require(_payQuantity > 0, "invalid quantity");
        for (uint256 i = 0; i < cardList.length; i++) {
            if (compareString(cardList[i].name, _name)) {
                uint256 index = findUserIndexByAddress(msg.sender);
                User memory user = userList[index];
                require(cardList[i].price * _payQuantity <= user.token);
                cardList[i].quantity -= _payQuantity;
                if (cardList[i].quantity == 0) {
                    delete cardList[i];
                }
                userList[index].token -= (cardList[i].price * _payQuantity);
                userList[0].token += (cardList[i].price * _payQuantity);
                orderList.push(Order(seller, msg.sender, _name, _payQuantity));
                break;
            }
        }
    }

    // 내 카드 목록 조회
    function findPurchasedCardListByAddress()
        public
        view
        onlyBuyer
        returns (Order[] memory)
    {
        uint256 length = countPurchasedCardListByAddress(msg.sender);
        Order[] memory purchasedCardList = new Order[](length);
        uint256 j = 0;
        for (uint256 i = 0; i < orderList.length; i++) {
            if (orderList[i].buyer == msg.sender) {
                purchasedCardList[j] = orderList[i];
                j++;
            }
        }
        return purchasedCardList;
    }

    // 내 카드 목록 수 조회
    function countPurchasedCardListByAddress(address _address)
        private
        view
        returns (uint256)
    {
        uint256 count = 0;
        for (uint256 i = 0; i < orderList.length; i++) {
            if (orderList[i].buyer == _address) {
                count++;
            }
        }

        return count;
    }

    // 사용자 인덱스 조회
    function findUserIndexByAddress(address _address)
        private
        view
        returns (uint256)
    {
        for (uint256 i = 0; i < userList.length; i++) {
            if (userList[i].user == _address) {
                return i;
            }
        }
        revert("user not found!!!");
    }

    // 사용자 조회
    function findUserByAddress(address _address)
        public
        view
        onlySeller
        returns (User memory)
    {
        for (uint256 i = 0; i < userList.length; i++) {
            if (userList[i].user == _address) {
                return userList[i];
            }
        }
        revert("user not found!!!");
    }

    // String 비교
    function compareString(string memory a, string memory b)
        private
        pure
        returns (bool)
    {
        return (keccak256(abi.encodePacked((a))) ==
            keccak256(abi.encodePacked((b))));
    }
}
