import 'package:uniclip/mongodatabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'sync.dart';

//================== App Bar Widget =======================
AppBar _buildAppBar() {
  return AppBar(
    backgroundColor: Colors.black,
    title: const Text(
      "Universal Clipboard",
      style: TextStyle(
          fontSize: 25.0, color: Colors.white, fontWeight: FontWeight.bold),
    ),
    automaticallyImplyLeading: false,
    centerTitle: true,
  );
}
//================== App Bar Widget =======================

class ClipboardPage extends StatefulWidget {
  const ClipboardPage({Key? key}) : super(key: key);

  @override
  _ClipboardPageState createState() => _ClipboardPageState();
}

class _ClipboardPageState extends State<ClipboardPage> {
  var cache = '';
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildAppBody()
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget _buildAppBody() {
    final _clipboardDatabase = ClipboardDatabase();
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(children: [
          Expanded(flex: 6, child: Card(child: _buildFutureBuilder(_clipboardDatabase))),
          Card(elevation: 20,child: _buildTextField('Entry', 'https://... anything ...')),
          Padding(padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
            child: Row(children: [Expanded(child: _buildFloatingSyncButton()),
              Expanded(child: _buildFloatingAddButtonFromClipboard())]),)
        ]));
  }

  FutureBuilder _buildFutureBuilder(_clipboardDatabase) {
    return FutureBuilder(
      future: _clipboardDatabase.retriveFromClipboard(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: ObjectKey(snapshot.data[index]),
                    child: GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                              text: snapshot.data[index].entry));
                        },
                        child: _buildClipboardEntryCard(
                            (snapshot.data[index].id).toString(),
                            snapshot.data[index].entry)),
                    onDismissed: (direction) {
                      var deleteID = snapshot.data[index].id;
                      cache = snapshot.data[index].entry;
                      _clipboardDatabase.deleteFromClipboard(deleteID);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Item deleted"),
                          action: SnackBarAction(
                              label: "UNDO",
                              onPressed: () {
                                setState(() {_clipboardDatabase.insertIntoClipboard(cache);});
                              })
                      ));
                    },
                  );
                });
          case ConnectionState.waiting:
            return const Card(
              child: Center(
                child: Text("Nothing here"),
              ),
            );
          default:
            return Container();
        }
      },
    );
  }

  Card _buildClipboardEntryCard(String id, String entry) {
    return Card(
        elevation: 20,
        color: Colors.white10,
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 2, right: 10),
                  child: Text(id),
                ),
                Expanded(
                  child: Text(
                    entry,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                )
              ],
            )));
  }


  Widget _buildTextField(labelText, hintText) {
    return Padding(padding: const EdgeInsets.all(10),
    child: TextField(
      controller: _textEditingController,
      decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          suffixIcon: _buildFloatingAddButtonFromText(_textEditingController)
      ))
    );
  }

  FloatingActionButton _buildFloatingAddButtonFromText(_textEditingController) {
    final _clipboardDatabase = ClipboardDatabase();
      return FloatingActionButton(
          child: const Icon(
            Icons.add_comment_rounded,
            color: Colors.black,
          ),
          backgroundColor: Colors.grey,
          elevation: 30,
          autofocus: true,
          onPressed: () async {
            if (_textEditingController.text != '') {
              setState(() {
                _clipboardDatabase.insertIntoClipboard(_textEditingController.text);
                _textEditingController.text = '';
              });
            }
          }
      );
  }

  FloatingActionButton _buildFloatingSyncButton() {
    return FloatingActionButton.extended(
        icon: const Icon(
          Icons.refresh_rounded,
          color: Colors.black,
        ),
        label: const Text(
          "Sync",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey,
        elevation: 30,
        onPressed: () {
          setState(() {

          });
        });
  }

  FloatingActionButton _buildFloatingAddButtonFromClipboard() {
    final _clipboardDatabase = ClipboardDatabase();
    return FloatingActionButton.extended(
        icon: const Icon(
          Icons.add_circle_outline_rounded,
          color: Colors.black,
        ),
        label: const Text(
          "From Clipboard",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey,
        elevation: 20,
        onPressed: () async {
          await Clipboard.getData(Clipboard.kTextPlain).then((value) =>
              setState(() {
                _clipboardDatabase.insertIntoClipboard(value!.text.toString());
              })
          );
        }
    );
  }
}
