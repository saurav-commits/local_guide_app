import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertravelapp/models/beach_model.dart';
import 'package:fluttertravelapp/models/popular_model.dart';
import 'package:fluttertravelapp/models/recommended_model.dart';
import 'package:fluttertravelapp/screens/selected_place_screen.dart';
import 'package:fluttertravelapp/widgets/bottom_navigation_bar.dart';
import 'package:fluttertravelapp/widgets/custom_tab_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  // Page Controller
  final _pageController = PageController(viewportFraction: 0.877);
  TextEditingController textController = TextEditingController();
  final name = "das";

  String location = 'Null, Press Button';
  String address = 'search';
  late Timer timer;

  Future _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future getAddressFromLatLong(Position position) async {
    List placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    // print(placemarks);
    Placemark place = placemarks[0];
    address =
        // '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
        '${place.subLocality},${place.locality}';
    // print(address);
    setState(() {});
  }

  checkForNewSharedLists() async {
    Position position = await _getGeoLocationPosition();
    getAddressFromLatLong(position);
    // print(position);
    // print("Hello");
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        const Duration(seconds: 5), (Timer t) => checkForNewSharedLists());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarTravel(),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            /// Custom Navigation Drawer and Search Button
            Container(
              height: 57.6,
              margin: const EdgeInsets.only(top: 28.8, left: 28.8, right: 28.8),
              child: Stack(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 80.8),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.6),
                      color: const Color(0x080a0928),
                    ),
                    // child: SvgPicture.asset(
                    //   'assets/svg/icon_location.svg',
                    //   color: Color.fromARGB(160, 0, 0, 0),
                    // ),
                    child: Text('${address}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.all(0),
                    child: AnimSearchBar(
                      width: 350,
                      textController: textController,
                      closeSearchOnSuffixTap: false,
                      onSuffixTap: () {
                        setState(() {
                          textController.clear();
                        });
                      },
                    ),
                  )
                ],
              ),
            ),

            /// Text Widget for Title
            Padding(
              padding: const EdgeInsets.only(top: 48, left: 28.8),
              child: Text(
                '👋 Hi! Guest',
                style: GoogleFonts.pacifico(
                    fontSize: 30.6, fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 28.8),
              child: Text(
                'Where would you like to go?',
                style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromARGB(213, 138, 138, 138)),
              ),
            ),

            /// Custom Tab bar with Custom Indicator
            Container(
              height: 30,
              margin: const EdgeInsets.only(left: 14.4, top: 28.8),
              child: DefaultTabController(
                length: 4,
                child: TabBar(
                    labelPadding:
                        const EdgeInsets.only(left: 14.4, right: 14.4),
                    indicatorPadding:
                        const EdgeInsets.only(left: 14.4, right: 14.4),
                    isScrollable: true,
                    labelColor: const Color(0xFF000000),
                    unselectedLabelColor: const Color(0xFF8a8a8a),
                    labelStyle: GoogleFonts.lato(
                        fontSize: 14, fontWeight: FontWeight.w700),
                    unselectedLabelStyle: GoogleFonts.lato(
                        fontSize: 14, fontWeight: FontWeight.w700),
                    indicator: RoundedRectangleTabIndicator(
                        color: const Color(0xFF000000),
                        weight: 2.4,
                        width: 14.4),
                    tabs: [
                      Tab(
                        child: Container(
                          child: const Text('Recommended'),
                        ),
                      ),
                      Tab(
                        child: Container(
                          child: const Text('Popular'),
                        ),
                      ),
                      Tab(
                        child: Container(
                          child: const Text('New Destination'),
                        ),
                      ),
                      Tab(
                        child: Container(
                          child: const Text('Hidden Gems'),
                        ),
                      )
                    ]),
              ),
            ),

            /// ListView widget with PageView
            /// Recommendations Section
            Container(
              height: 218.4,
              margin: const EdgeInsets.only(top: 16),
              child: PageView(
                physics: const BouncingScrollPhysics(),
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  recommendations.length,
                  (int index) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SelectedPlaceScreen(
                              recommendedModel: recommendations[index])));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 28.8),
                      width: 333.6,
                      height: 218.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.6),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                              recommendations[index].image),
                        ),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            bottom: 19.2,
                            left: 19.2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.8),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaY: 19.2, sigmaX: 19.2),
                                child: Container(
                                  height: 36,
                                  padding: const EdgeInsets.only(
                                      left: 16.72, right: 14.4),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: <Widget>[
                                      SvgPicture.asset(
                                          'assets/svg/icon_location.svg'),
                                      const SizedBox(
                                        width: 9.52,
                                      ),
                                      Text(
                                        recommendations[index].name,
                                        style: GoogleFonts.lato(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            fontSize: 16.8),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// Dots Indicator
            /// Using SmoothPageIndicator Library
            Padding(
              padding: const EdgeInsets.only(left: 28.8, top: 28.8),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: recommendations.length,
                effect: const ExpandingDotsEffect(
                    activeDotColor: Color(0xFF8a8a8a),
                    dotColor: Color(0xFFababab),
                    dotHeight: 4.8,
                    dotWidth: 6,
                    spacing: 4.8),
              ),
            ),

            /// Text Widget for Popular Categories
            Padding(
              padding: const EdgeInsets.only(top: 48, left: 28.8, right: 28.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // ignore: sized_box_for_whitespace
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: FittedBox(
                      child: Text(
                        'Popular Categories',
                        style: GoogleFonts.playfairDisplay(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ),
                  ),
                  // ignore: sized_box_for_whitespace
                  Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: FittedBox(
                      child: Text(
                        'Show All ',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF8a8a8a),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            /// ListView for Popular Categories Section
            Container(
              margin: const EdgeInsets.only(top: 33.6),
              height: 45.6,
              child: ListView.builder(
                itemCount: populars.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 28.8, right: 9.6),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 19.2),
                    height: 45.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.6),
                      color: Color(populars[index].color),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          width: 19.2,
                        ),
                        Image.asset(
                          populars[index].image,
                          height: 16.8,
                        ),
                        const SizedBox(
                          width: 19.2,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),

            /// ListView for Beach Section
            Container(
              margin: const EdgeInsets.only(top: 28.8, bottom: 16.8),
              height: 124.8,
              child: ListView.builder(
                itemCount: beaches.length,
                padding: const EdgeInsets.only(left: 28.8, right: 12),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    height: 124.8,
                    width: 188.4,
                    margin: const EdgeInsets.only(right: 16.8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.6),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(beaches[index].image),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
