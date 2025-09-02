import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  // store only wallpaper IDs locally; data is still fetched from Firestore
  Set<String> _ids = {};

  Set<String> get ids => _ids;

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    _ids = (p.getStringList('fav_ids') ?? []).toSet();
    notifyListeners();
  }

  bool isFav(String id) => _ids.contains(id);

  Future<void> toggle(String id) async {
    if (_ids.contains(id)) {
      _ids.remove(id);
    } else {
      _ids.add(id);
    }
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setStringList('fav_ids', _ids.toList());
  }

  void clear() async {
    _ids.clear();
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setStringList('fav_ids', []);
  }
}
