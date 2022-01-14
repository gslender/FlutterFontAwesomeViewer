import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:font_awesome_flutter/meta_icon_mapping.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String kAppTitle = 'Flutter FontAwesome Viewer';

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        cupertinoOverrideTheme: const CupertinoThemeData(
          primaryColor: Colors.white54,
        ),
      ),
      home: const MyHomePage(title: kAppTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showSearch = false;
  double _iconSize = 48;
  List<FontAwesomeIconMetadata> searchedIconsList = [];

  @override
  void initState() {
    super.initState();
    searchedIconsList = faIconMetaMapping.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: _showSearch ? _searchField() : Text(widget.title),
          actions: [
            _showSearch
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        searchedIconsList = faIconMetaMapping.values.toList();
                        _showSearch = false;
                      });
                    },
                    icon: const FaIcon(FontAwesomeIcons.solidTimesCircle))
                : IconButton(
                    onPressed: () {
                      setState(() {
                        _showSearch = true;
                      });
                    },
                    icon: const FaIcon(FontAwesomeIcons.search))
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: Container(
                    color: Colors.white,
                    child: ListView.separated(
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: searchedIconsList.length,
                        itemBuilder: (context, index) {
                          final FontAwesomeIconMetadata meta = searchedIconsList[index];
                          final List<IconData> iconFamilyList = meta.icons;
                          Widget iconFamily = Container(
                              color: Colors.transparent,
                              child: OverflowBar(
                                  alignment: MainAxisAlignment.spaceEvenly,
                                  overflowAlignment: OverflowBarAlignment.center,
                                  overflowSpacing: 10,
                                  children: iconFamilyList.map<Widget>((faicon) {
                                    return Card(
                                      margin: const EdgeInsets.all(1),
                                      child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: faicon is IconDataDuotone
                                              ? FaDuotoneIcon(
                                                  faicon,
                                                  primaryColor: Colors.red.shade600,
                                                  secondaryColor: Colors.blue.shade600,
                                                  size: _iconSize,
                                                )
                                              : FaIcon(faicon, size: _iconSize)),
                                    );
                                  }).toList()));
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                iconFamily,
                                SizedBox(
                                  height: 40,
                                  child: Center(child: Text(meta.label)),
                                )
                              ]);
                        }))),
            SafeArea(
                child: Container(
              width: double.infinity,
              height: 40,
              color: Colors.black,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text(
                  "${searchedIconsList.length} icons",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                Slider(
                    min: 12,
                    max: 130,
                    value: _iconSize,
                    onChanged: (value) {
                      setState(() {
                        _iconSize = value;
                      });
                    })
              ]),
            ))
          ],
        ));
  }

  Widget _searchField() {
    return Theme(
        data: Theme.of(context).copyWith(
            textSelectionTheme: const TextSelectionThemeData(
          selectionHandleColor: Colors.lightBlue,
          selectionColor: Colors.lightBlue,
        )),
        child: TextFormField(
          cursorColor: Colors.white,
          onChanged: (value) {
            setState(() {
              searchedIconsList = getIconsMetaListFromSearch(value);
            });
          },
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
              label: const Text("Search..."),
              labelStyle: TextStyle(color: Colors.lightBlue.shade200),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.lightBlue.shade200),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.lightBlue.shade200),
              )),
        ));
  }
}
