## Environment requirements

Xcode 15+

```
iOS 17.2 +
```

```
Swift 5
```

Please be ready to share Simmulator or connected device.


# dna-task-livecoding-swift


The goal is to implement an app that will work on a POS (point-of-sale) device that will allow to select products from the available set and pay for them with a card.

Task 1:
As an MVP you should enhance product list with functionality to select/unselect product on the list and ...

Task 2:
...be able to buy at least one product (MVP approach).

To perform payment you must:
- initiate purchase transaction
- call payment API using transaction identifier and card token read from reader API
- confirm purchase transaction after successful payment
