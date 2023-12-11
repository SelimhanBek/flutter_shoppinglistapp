import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditorWidget extends ConsumerStatefulWidget {
  const EditorWidget({
    required this.btnName,
    this.curVal = "",
    super.key,
  });

  final String curVal;
  final String btnName;

  @override
  EditorWidgetState createState() => EditorWidgetState();
}

class EditorWidgetState extends ConsumerState<EditorWidget> {
  final TextEditingController _ct = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.curVal.isNotEmpty) {
      _ct.text = widget.curVal;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              /* Widget */
              Container(
                height: MediaQuery.of(context).size.width / 1.2,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /* Name */
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: _ct,
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: const InputDecoration(
                          hintText: "Liste adı girin...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.teal),
                          ),
                        ),
                      ),
                    ),

                    /* a little space */
                    const SizedBox(height: 30),

                    /* Done */
                    ElevatedButton(
                      onPressed: _ct.text.trim().isEmpty
                          ? null
                          : () => Navigator.of(context).pop(_ct.text.trim()),
                      child: Text(widget.btnName),
                    ),
                  ],
                ),
              ),

              /* Close */
              Positioned(
                top: 10,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    visualDensity: VisualDensity.compact,
                    iconSize: 40,
                    tooltip: 'Kapat',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
