import "dart:io";

import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:xml/xml.dart";

part "main.g.dart";

final basePath = "${Platform.environment["HOME"]}/.tv-launcher";

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue, brightness: Brightness.dark),
      ),
      home: Browser(entry: FolderEntry(basePath)),
    );
  }
}

@riverpod
List<DirEntry> directoryContents(Ref ref, String path) {
  final dir = Directory(path);
  if (!dir.existsSync()) {
    return [];
  }

  final contents =
      dir
          .listSync()
          .map((e) {
            try {
              return DirEntry.fromEntry(e);
            } catch (e, st) {
              print(e);
              print(st);
              return null;
            }
          })
          .whereType<DirEntry>()
          .toList();

  contents.sort((a, b) => a.sortKey.compareTo(b.sortKey));

  return contents;
}

sealed class DirEntry {
  const DirEntry(this.path, {this.hidden = false});
  final String path;

  String get headerTitle => "$path/".toString().replaceFirst(basePath, "");
  String get name => path.split("/").last;
  String? get imageUrl => null;
  String get sortKey => name.toLowerCase();

  final bool hidden;

  void onTapCard(BuildContext context, WidgetRef ref);

  factory DirEntry.fromEntry(FileSystemEntity entry) {
    if (entry is Directory || entry is Link) {
      final nfoPath = "${entry.path}/tvshow.nfo";
      if (File(nfoPath).existsSync()) {
        return TvshowEntry.fromNfo(entry.path, File(nfoPath));
      } else {
        return FolderEntry(entry.path);
      }
    } else {
      if (entry.path.endsWith(".nfo")) {
        throw "NFO file";
      }

      final nfoPath = entry.path.replaceFirst(RegExp(r"\.[^.]+$"), ".nfo");
      if (File(nfoPath).existsSync()) {
        return EpisodeEntry.fromNfo(entry.path, File(nfoPath));
      } else {
        return FileEntry(entry.path);
      }
    }
  }

  Widget browser(BuildContext context, WidgetRef ref) {
    return GridView.extent(
      maxCrossAxisExtent: 300,
      childAspectRatio: 3 / 5,
      children:
          ref.watch(directoryContentsProvider(path)).where((e) => !e.hidden).map((e) {
            return Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => e.onTapCard(context, ref),
                child: Column(
                  children: [Expanded(child: e.image(context, ref)), ListTile(title: Text("${e.name}\n", maxLines: 2))],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget image(BuildContext context, WidgetRef ref) {
    return imageUrl != null
        ? CachedNetworkImage(
          imageUrl: imageUrl!,
          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) {
            print(error);
            return Icon(Icons.error);
          },
          fit: BoxFit.cover,
        )
        : const Icon(Icons.folder);
  }
}

class FolderEntry extends DirEntry {
  const FolderEntry(super.path, {super.hidden});

  @override
  void onTapCard(BuildContext context, WidgetRef ref) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Browser(entry: this)));
  }
}

class TvshowEntry extends FolderEntry {
  const TvshowEntry(super.path, {required this.title, super.hidden});

  final String title;

  @override
  String get headerTitle => title;

  @override
  String get name => title;

  factory TvshowEntry.fromNfo(String path, File file) {
    // final xml = XmlDocument.parse(file.readAsStringSync());
    // final root = xml.getElement("tvshow");

    // if (root == null) {
    //   throw "Invalid NFO file";
    // }

    // final title = root.getElement("title")?.innerText ?? "<no title>";

    // if (root.getElement("anidb_id") != null) {
    //   final n = root.getElement("anidb_id")?.innerText;
    //   final anidbId = n != null ? int.tryParse(n) : null;
    //   final anidbPicname = root.getElement("anidb_picname")?.innerText;

    //   return AnimeFolderEntry(path, title: title, anidbId: anidbId, anidbPicname: anidbPicname);
    // } else {
    //   return TvshowEntry(path, title: title);
    // }

    final nfo = NfoData.fromFile(file);
    final title = nfo.get("title") ?? "<no title>";

    if (nfo.get("anidb_id") != null) {
      final anidbId = int.tryParse(nfo.get("anidb_id")!);
      final anidbPicname = nfo.get("anidb_picname");

      return AnimeFolderEntry(path, title: title, anidbId: anidbId, anidbPicname: anidbPicname);
    } else {
      return TvshowEntry(path, title: title);
    }
  }

  @override
  Widget browser(BuildContext context, WidgetRef ref) {
    final files = ref.watch(directoryContentsProvider(path)).where((e) => !e.hidden).whereType<EpisodeEntry>().toList();

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [Padding(padding: const EdgeInsets.all(32), child: image(context, ref)), Spacer()],
          ),
        ),
        Expanded(
          flex: 5,
          child: ListView(
            padding: const EdgeInsets.all(32),
            children:
                files.map((e) {
                  return ListTile(
                    leading: switch (e) {
                      EpisodeEntry(:final epno) => SizedBox(
                        width: 24,
                        child: Text(
                          epno?.replaceFirst(RegExp(r"^0+"), "") ?? "",
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      // FolderEntry() => const Icon(Icons.folder),
                      // _ => const Icon(Icons.file_present),
                    },
                    title: Text(e.name),
                    onTap: () {
                      final start = files.indexOf(e);
                      Process.run("mpv", [...files.map((e) => e.path), "--playlist-start=$start"]);
                    },
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}

class AnimeFolderEntry extends TvshowEntry {
  const AnimeFolderEntry(
    super.path, {
    required super.title,
    required this.anidbId,
    required this.anidbPicname,
    super.hidden,
  });

  final int? anidbId;
  final String? anidbPicname;

  @override
  String get imageUrl => "https://cdn-eu.anidb.net/images/main/$anidbPicname";
}

class FileEntry extends DirEntry {
  const FileEntry(super.path, {super.hidden});

  @override
  void onTapCard(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }
}

class EpisodeEntry extends FileEntry {
  const EpisodeEntry(super.path, {this.epno, this.title, super.hidden});

  final String? epno; // could be eg. S1 for specials or C1 for credits
  final String? title;

  @override
  String get name => title ?? super.name;

  @override
  String get sortKey => epno ?? super.sortKey;

  factory EpisodeEntry.fromNfo(String path, File file) {
    final nfo = NfoData.fromFile(file);
    final epno = nfo.get("episode");
    final title = nfo.get("title");
    final hidden = nfo.get("hidden") == "true";

    return EpisodeEntry(path, epno: epno, title: title, hidden: hidden);
  }
}

class Browser extends ConsumerWidget {
  const Browser({super.key, required this.entry});

  final DirEntry entry;

  static Route route(DirEntry entry) => MaterialPageRoute<void>(builder: (_) => Browser(entry: entry));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(entry.headerTitle)),
      body: entry.browser(context, ref),
    );
  }
}

class NfoData {
  const NfoData(this.data);

  final Map<String, String> data;

  String? get(String key) => data[key];

  factory NfoData.fromFile(File file) {
    final xml = XmlDocument.parse(file.readAsStringSync());
    final root = xml.childElements.firstOrNull;

    if (root == null) {
      throw "Invalid NFO file";
    }

    final data = <String, String>{};

    for (final element in root.children) {
      if (element is XmlElement) {
        data[element.name.toString()] = element.innerText;
      }
    }

    return NfoData(data);
  }
}
