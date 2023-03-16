import 'package:nostr_dart/nostr_dart.dart';
import 'package:nostrmo/util/lazy_function.dart';

/// a memory event box
/// use to hold event received from relay and offer event List to ui
class EventMemBox {
  List<Event> _pendingList = [];

  List<Event> _eventList = [];

  Map<String, int> _idMap = {};

  EventMemBox() {}

  Event? get newestEvent {
    if (_eventList.isNotEmpty) {
      return null;
    }
    return _eventList.first;
  }

  void _sort() {
    _eventList.sort((event1, event2) {
      return event2.createdAt - event1.createdAt;
    });
  }

  bool add(Event event) {
    if (_idMap[event.id] != null) {
      return false;
    }

    _idMap[event.id] = 1;
    _eventList.add(event);
    _sort();
    return true;
  }

  bool addList(List<Event> list) {
    bool added = false;
    for (var event in list) {
      if (_idMap[event.id] == null) {
        _idMap[event.id] = 1;
        _eventList.add(event);
        added = true;
      }
    }

    if (added) {
      _sort();
    }

    return added;
  }

  void addBox(EventMemBox b) {
    var all = b.all();
    addList(all);
  }

  bool isEmpty() {
    return _eventList.isEmpty;
  }

  int length() {
    return _eventList.length;
  }

  List<Event> all() {
    return _eventList;
  }

  List<Event> listByPubkey(String pubkey) {
    List<Event> list = [];
    for (var event in _eventList) {
      if (event.pubKey == pubkey) {
        list.add(event);
      }
    }
    return list;
  }

  List<Event> suList(int start, int limit) {
    var length = _eventList.length;
    if (start > length) {
      return [];
    }
    if (start + limit > length) {
      return _eventList.sublist(start, length);
    }
    return _eventList.sublist(start, limit);
  }

  Event? get(int index) {
    if (_eventList.length < index) {
      return null;
    }

    return _eventList[index];
  }
}