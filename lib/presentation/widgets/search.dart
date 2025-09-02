import 'package:flutter/material.dart';
import 'package:registration/presentation/widgets/navigator.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.icon});
  final String? icon;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true, // قفل الكتابة
      controller: _controller,
      onTap: () {
        // AppNavigator.fade(
        //   context,
        //   SearchCarsPage(),
        //   replace: false,
        // ); // فتح صفحة البحث
      },
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintText: "Search",
        hintStyle: const TextStyle(color: Colors.white70, fontSize: 16),
        filled: true,
        fillColor: const Color.fromARGB(88, 124, 124, 124),

        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset(
            widget.icon ?? "assets/search.svg",
            width: 20,
            height: 20,
            // color: Colors.white,
          ),
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
