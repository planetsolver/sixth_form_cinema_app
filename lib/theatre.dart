import 'package:flutter/material.dart';
import 'package:sixth_form_cinema_app/firestore/firestore.dart';
import 'package:sixth_form_cinema_app/util.dart';

class TheatrePage extends StatefulWidget {
  const TheatrePage({super.key, required this.screenSize, required this.addSeatToBasket, required this.basket, required this.removeFromBasket});

  final ScreenSize screenSize;
  final List<Seat> basket;
  final void Function(Seat) addSeatToBasket;
  final void Function(int, int) removeFromBasket;

  @override
  State<StatefulWidget> createState() {
    return _TheatrePageState();
  }
}

class _TheatrePageState extends State<TheatrePage> {
  //CONST
  int numRows = 30;
  int numCols = 15;

  late List<Seat> seats;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadSeats();
  }

  Future<void> loadSeats() async {
    setState(() {
      loading = true;
    });
    seats = await getSeatsInOrder(numRows, numCols);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seats"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BasketIcon(
              numInBasket: widget.basket.length,
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: (loading) ? const LoadingIndicator() : Align(
        alignment: AlignmentDirectional.center,
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: GridView.count(
            crossAxisCount: numCols, // Set the number of items per row
            childAspectRatio: 1.0, // Set the aspect ratio for the items (square in this case)
            children: List.generate(numCols * numRows, (index) {
              return SeatWidget(index: index, addSeatToBasket: widget.addSeatToBasket, numCols: numCols, removeFromBasket: widget.removeFromBasket, seat: seats[index],);
            }),
          ),
        ),
      ),
    );
  }
}

class SeatWidget extends StatefulWidget {
  const SeatWidget({super.key, required this.index, required this.addSeatToBasket, required this.numCols, required this.removeFromBasket, required this.seat});

  final int index;
  final int numCols;
  final void Function(Seat) addSeatToBasket;
  final void Function(int, int) removeFromBasket;
  final Seat seat;

  @override
  State<StatefulWidget> createState() {
    return _SeatWidgetState();
  }
}

class _SeatWidgetState extends State<SeatWidget> {
  bool selected = false;

  late int row;
  late int col;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (widget.seat.ownedById != null) ? () {} : () {
          debugPrint("row : ${widget.seat.row}, col : ${widget.seat.col}");
          if (selected) {
            widget.removeFromBasket(widget.seat.row, widget.seat.col);
          } else {
            widget.addSeatToBasket(widget.seat);
          }
          setState(() {
            selected = !selected;
          });
        },
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: ((widget.seat.ownedById == null) && (!selected))
                ? Theme.of(context).colorScheme.background
                : Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ((widget.seat.ownedById == null) && (!selected))
              ? Icon(
                  Icons.event_seat,
                  color: Theme.of(context).colorScheme.onBackground,
                )
              : Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
        ),
      ),
    );
  }
}
