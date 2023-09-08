import 'package:flutter/material.dart';

enum ScreenSize { watch, phone, tabletVertical, tabletHorizontal, desktop }

class UserDetails {
  final String firstName;
  final String surname;
  final List<Seat> seats;

  const UserDetails({required this.firstName, required this.surname, required this.seats});
}

class PageClass {
  const PageClass(
      {required this.title, required this.path, this.image});

  final String title;
  final String path;
  final ImageProvider? image;
}

class Seat {
  final int row;
  final int col;
  final String? id;
  final String? ownedById;
  final double price = 10.5;

  const Seat({required this.row, required this.col, required this.id, required this.ownedById,});
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.center,
      child: AspectRatio(
        aspectRatio: 1,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary),
          strokeWidth: 8,
        ),
      ),
    );
  }
}

class BasketIcon extends StatelessWidget{
  const BasketIcon({super.key, required this.numInBasket});

  final int numInBasket;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, "/basket");
          },
          icon: const Icon(Icons.shopping_basket),
        ),
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: Text(
            "$numInBasket",
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
    );
  }
}