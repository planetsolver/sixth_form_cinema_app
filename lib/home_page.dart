import 'package:flutter/material.dart';
import 'package:sixth_form_cinema_app/util.dart';

//home page :
/*
Scaffold
  - App Bar
    - Text (SyncListStudio)
  - Body
    - Grid view (for all pages using HomePageGridViewPage)
 */
class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.screenSize});

  final ScreenSize screenSize;

  //CONSTANTS
  static const List<PageClass> homePagePages = [
    PageClass(
      title: "theatre",
      path: "/theatre",
      image: null,
    ),
    PageClass(
      title: "account",
      path: "/account",
      image: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Theatre App"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: homePagePages.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (screenSize == ScreenSize.phone) ? 1 : 2,
          childAspectRatio: (1843 / 632),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (BuildContext context, int index) {
          return HomePageGridViewPage(
            image: homePagePages[index].image,
            pageTitle: homePagePages[index].title,
            pagePath: homePagePages[index].path,
          );
        },
      ),
    );
  }
}

//HomePageGridViewPage
/*
Button
  - Stack
    - Image (display for the current page)
    - Text (current page name)
 */
class HomePageGridViewPage extends StatelessWidget {
  const HomePageGridViewPage(
      {super.key,
      this.image,
      required this.pageTitle,
      required this.pagePath});

  final ImageProvider? image;
  final String pageTitle;
  final String pagePath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, pagePath);
      }, //When the user clicks on the button
      child: Container(
        decoration: BoxDecoration(
          image: (image == null) ? null : DecorationImage(
            image: image!,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            pageTitle,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
      ),
    );
  }
}
