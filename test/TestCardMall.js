var CardMall = artifacts.require("CardMall")

contract('CardMall', async accounts => {

  let instance
  let seller = accounts[0]
  let buyer = accounts[1]

  beforeEach(async () => {
    instance = await CardMall.new()
    instance.initToken({ from: buyer })
  })

  it("카드 등록 테스트", async () => {
    // given
    let expected = [{
      name: "피카츄",
      description: "100만 볼트!!!",
      price: "100",
      quantity: "2"
    }
    ]

    console.log("카드 등록")
    console.log("카드명 : " + expected[0].name)
    console.log("설명 : " + expected[0].description)
    console.log("가격 : " + expected[0].price)
    console.log("수량 : " + expected[0].quantity)

    // when
    for (var i = 0; i < expected.length; i++) {
      await instance.registerCard(
        expected[i].name,
        expected[i].description,
        expected[i].price,
        expected[i].quantity,
        { from: seller }
      )
    }

    // then
    let result = await instance.findCardAll({ from: seller })
    let actual = []
    for (var i = 0; i < result.length; i++) {
      let parsedResult = {
        "name": result[i].name,
        "description": result[i].description,
        "price": result[i].price,
        "quantity": result[i].quantity
      }
      actual.push(parsedResult)
    }


    assert.deepEqual(actual, expected, "registered card should be matched!");
  })

  it("판매된 카드 목록 조회 테스트", async () => {
    // given
    let cardList = [{
      name: "피카츄",
      description: "100만 볼트!!!",
      price: 100,
      quantity: 2
    }
    ]

    console.log("판매된 카드 목록")
    console.log("카드명 : " + cardList[0].name)
    console.log("설명 : " + cardList[0].description)
    console.log("가격 : " + cardList[0].price)
    console.log("수량 : " + cardList[0].quantity)

    for (var i = 0; i < cardList.length; i++) {
      await instance.registerCard(
        cardList[i].name,
        cardList[i].description,
        cardList[i].price,
        cardList[i].quantity,
        { from: seller }
      )
    }

    let purchase = {
      name: "피카츄",
      payQuantity: 1
    }

    await instance.purchaseCard(purchase.name, purchase.payQuantity, { from: buyer })

    // when
    let result = await instance.findPurchasedCardAll({ from: seller })
    let actual = []
    for (var i = 0; i < result.length; i++) {
      let parsedResult = {
        "seller": result[i].seller,
        "buyer": result[i].buyer,
        "cardName": result[i].cardName,
        "quantity": result[i].quantity
      }
      actual.push(parsedResult)
    }

    // then
    let expected = [{
      seller: seller,
      buyer: buyer,
      cardName: "피카츄",
      quantity: "1"
    }
    ]

    assert.deepEqual(actual, expected, "purchased card should be matched!");
  })

  it("판매 중인 카드 목록 조회 테스트", async () => {
    // given
    let cardList = [{
      name: "피카츄",
      description: "100만 볼트!!!",
      price: 100,
      quantity: 2
    }
    ]

    console.log("판매 중인 카드 목록")
    console.log("카드명 : " + cardList[0].name)
    console.log("설명 : " + cardList[0].description)
    console.log("가격 : " + cardList[0].price)
    console.log("수량 : " + cardList[0].quantity)

    for (var i = 0; i < cardList.length; i++) {
      await instance.registerCard(
        cardList[i].name,
        cardList[i].description,
        cardList[i].price,
        cardList[i].quantity,
        { from: seller }
      )
    }

    // when
    let result = await instance.findCardAll({ from: buyer })
    let actual = []
    for (var i = 0; i < result.length; i++) {
      let parsedResult = {
        "name": result[i].name,
        "description": result[i].description,
        "price": result[i].price,
        "quantity": result[i].quantity
      }
      actual.push(parsedResult)
    }

    // then
    let expected = [{
      name: "피카츄",
      description: "100만 볼트!!!",
      price: "100",
      quantity: "2"
    }
    ]
    assert.deepEqual(actual, expected, "card list on sale should be matched!");
  })

  it("카드 구매 테스트, 내 카드 목록 조회 테스트", async () => {
    // given
    let cardList = [{
      name: "피카츄",
      description: "100만 볼트!!!",
      price: 100,
      quantity: 2
    }
    ]

    console.log("카드 구매")
    console.log("카드명 : " + cardList[0].name)
    console.log("설명 : " + cardList[0].description)
    console.log("가격 : " + cardList[0].price)
    console.log("수량 : " + cardList[0].quantity)
    console.log("구매 수량 : " + 1)

    console.log("판매자 : " + seller)
    let user = await instance.findUserByAddress(seller, { from: seller })
    console.log("판매자 잔고 : " + user.token)
    console.log("구매자 : " + buyer)
    user = await instance.findUserByAddress(buyer, { from: seller })
    console.log("구매자 잔고 : " + user.token)
  
    for (var i = 0; i < cardList.length; i++) {
      await instance.registerCard(
        cardList[i].name,
        cardList[i].description,
        cardList[i].price,
        cardList[i].quantity,
        { from: seller }
      )
    }

    // when
    let purchase = {
      name: "피카츄",
      payQuantity: 1
    }

    await instance.purchaseCard(purchase.name, purchase.payQuantity, { from: buyer })
    user = await instance.findUserByAddress(seller, { from: seller })
    console.log("거래 후 판매자 잔고 : " + user.token)
    user = await instance.findUserByAddress(buyer, { from: seller })
    console.log("거래 후 구매자 잔고 : " + user.token)
    // then
    let result = await instance.findPurchasedCardListByAddress({ from: buyer })
    let actual = []
    for (var i = 0; i < result.length; i++) {
      let parsedResult = {
        "seller": result[i].seller,
        "buyer": result[i].buyer,
        "cardName": result[i].cardName,
        "quantity": result[i].quantity
      }
      actual.push(parsedResult)
    }

    let expected = [{
      seller: seller,
      buyer: buyer,
      cardName: "피카츄",
      quantity: "1"
    }
    ]
    assert.deepEqual(actual, expected, "buyer's card should be matched!");
  })
})

