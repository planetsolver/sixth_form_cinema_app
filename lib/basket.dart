import 'package:flutter/material.dart';
import 'package:sixth_form_cinema_app/firestore/firestore.dart';
import 'package:sixth_form_cinema_app/util.dart';

class BasketPage extends StatelessWidget {
  const BasketPage(
      {super.key,
      required this.basket,
      required this.removeFromBasket,
      required this.clearBasket});

  final List<Seat> basket;
  final void Function(int, int) removeFromBasket;
  final void Function() clearBasket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Basket"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (basket.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                      itemCount: basket.length,
                      itemBuilder: (BuildContext context, int index) {
                        Seat seat = basket[index];
                        return ListTile(
                          title: Text(
                            "Row : ${seat.row}, Col : ${seat.col}",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          leading: Text(
                            "£${seat.price} -- ",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              removeFromBasket(seat.row, seat.col);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).colorScheme.error),
                            ),
                            child: Text(
                              "Remove",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.onError,
                                  ),
                            ),
                          ),
                        );
                      }),
                ),
              if (basket.isEmpty)
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.center,
                    child: Text(
                      "Nothing in Basket",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                ),
              //BUY
              ElevatedButton(
                onPressed: () async {
                  for (Seat seat in basket) {
                    if (await createSeat(seat) == false) {
                      debugPrint("Failed to purchase seat : $seat");
                    }
                  }
                  clearBasket();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.secondary),
                ),
                child: Text(
                  "Purchase",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
