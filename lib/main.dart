import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'greeting_page.dart';
import 'about.dart';
import 'contact.dart';
import 'wordle/wordle.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(480, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        ],
        background: Container(
          color: const Color(0xFFF5F5F5),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Marcos Gamarra',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff4d1f73),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0; // 0 = greeting, 1 = about, 2 = contact


  Widget backwardButton(int currentIndex, PageController controller) {
    return Align(
      alignment: Alignment.centerLeft,
      child: currentIndex != 0
          ? IconButton(
              hoverColor: const Color(0xff3a324d),
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                color:
                    currentIndex == 0 ? Colors.transparent : Colors.grey[600],
              ),
              onPressed: () {
                controller.previousPage(
                  duration: const Duration(seconds: 1),
                  curve: Curves.ease,
                );
              },
            )
          : Container(),
    );
  }

  Widget forwardButton(int currentIndex, PageController controller) {
    return Align(
      alignment: Alignment.centerRight,
      child: currentIndex != 3
          ? IconButton(
              hoverColor: const Color(0xff3a324d),
              icon: Icon(
                Icons.arrow_forward_ios_outlined,
                color:
                    currentIndex == 3 ? Colors.transparent : Colors.grey[600],
              ),
              onPressed: () {
                controller.nextPage(
                  duration: const Duration(seconds: 1),
                  curve: Curves.ease,
                );
              },
            )
          : Container(),
    );
  }

  SystemMouseCursor cursor = SystemMouseCursors.basic;

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            color: Colors.grey[300],
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        }),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: Material(
          color: Colors.grey[700],
          child: Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                title: const Text(
                  'Home',
                  //textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                onTap: () {
                  controller.animateToPage(
                    0,
                    duration: const Duration(seconds: 1),
                    curve: Curves.ease,
                  );
                  setState(() => currentIndex = 0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.info,
                  color: Colors.white,
                ),
                title: const Text(
                  'About',
                  //textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                onTap: () {
                  controller.animateToPage(
                    1,
                    duration: const Duration(seconds: 1),
                    curve: Curves.ease,
                  );
                  setState(() => currentIndex = 1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.contact_mail,
                  color: Colors.white,
                ),
                title: const Text(
                  'Contact',
                  //textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                onTap: () {
                  controller.animateToPage(
                    2,
                    duration: const Duration(seconds: 1),
                    curve: Curves.ease,
                  );
                  setState(() => currentIndex = 2);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.sports_esports,
                  color: Colors.white,
                ),
                title: const Text(
                  'Wordle',
                  //textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                onTap: () {
                  controller.animateToPage(
                    3,
                    duration: const Duration(seconds: 1),
                    curve: Curves.ease,
                  );
                  setState(() => currentIndex = 3);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Listener(
            onPointerDown: (details) {
              setState(() {
                cursor = SystemMouseCursors.grabbing;
                FocusScope.of(context).unfocus();
              });
            },
            onPointerUp: (details) {
              setState(() {
                cursor = SystemMouseCursors.basic;
              });
            },
            child: MouseRegion(
              cursor: cursor,
              child: PageView(
                onPageChanged: (pageNumber) {
                  setState(() => currentIndex = pageNumber);
                },
                dragStartBehavior: DragStartBehavior.start,
                scrollBehavior: DragScroll(),
                controller: controller,
                children: const <Widget>[
                  GreetingPage(),
                  About(),
                  Contact(),
                  Wordle(),
                ],
              ),
            ),
          ),
          forwardButton(currentIndex, controller),
          backwardButton(currentIndex, controller),
        ],
      ),
    );
  }
}

class DragScroll extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
