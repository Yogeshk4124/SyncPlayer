import 'package:SyncPlayer/Utils/MarqueeText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModalTrigger extends StatefulWidget {
  dynamic audios = [];
  dynamic ap;

  ModalTrigger({this.audios, this.ap});

  @override
  _ModalTriggerState createState() => _ModalTriggerState();
}

class _ModalTriggerState extends State<ModalTrigger> {
  _showModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              color: Color(0xff121212),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.minus),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Playlist",
                      style: GoogleFonts.merriweather(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: widget.audios.length,
                          itemBuilder: (context, index) {
                            if (widget.ap.current.value.index == index)
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Card(
                                  child: ListTile(
                                    selected: true,
                                    selectedTileColor: Color(0xff303030),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          height: 46,
                                          child: MarqueeText(
                                            text: widget.audios[index].path
                                                .substring(widget
                                                        .audios[index].path
                                                        .lastIndexOf('/') +
                                                    1),
                                            textStyle: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            await widget.ap.playOrPause();
                                            setState(() {});
                                          },
                                          child: widget.ap.isPlaying.value
                                              ? Icon(Icons.pause)
                                              : Icon(Icons.play_arrow),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            else
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Card(
                                    child: ListTile(
                                  onTap: () async {
                                    await widget.ap.playlistPlayAtIndex(index);
                                    setState(() {});
                                  },
                                  tileColor: Color(0xff181818),
                                  title: Container(
                                    child: Text(
                                      widget.audios[index].path.substring(widget
                                              .audios[index].path
                                              .lastIndexOf('/') +
                                          1),
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )),
                              );
                          }))
                ],
              ),
            );
          });
        });
  }

  List<ListTile> getPendingAudio(setState) {
    if (widget.audios.isEmpty || widget.ap.current.value == null) return [];
    List<ListTile> l = [];
    for (int x = 0; x < widget.audios.length; x++)
      if (widget.ap.current.value.index == x)
        l.add(
          ListTile(
            selected: true,
            selectedTileColor: Color(0xff303030),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 46,
                  child: MarqueeText(
                    text: widget.audios[x].path
                        .substring(widget.audios[x].path.lastIndexOf('/') + 1),
                    textStyle: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    await widget.ap.playOrPause();
                    setState(() {});
                  },
                  child: widget.ap.isPlaying.value
                      ? Icon(Icons.pause)
                      : Icon(Icons.play_arrow),
                ),
              ],
            ),
          ),
        );
      else
        l.add(ListTile(
          onTap: () async {
            await widget.ap.playlistPlayAtIndex(x);
            setState(() {});
          },
          tileColor: Color(0xff181818),
          title: Container(
            child: Text(
              widget.audios[x].path
                  .substring(widget.audios[x].path.lastIndexOf('/') + 1),
              maxLines: 1,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ));
    return l;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showModalBottomSheet(context);
      },
      child: Container(
        width: double.infinity,
        // color: Colors.red,
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Color(0xff252525),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.square_favorites,
              size: 26,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Playlist',
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}
