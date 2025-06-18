import 'package:hive_flutter/hive_flutter.dart';
import 'package:obscure_me/core/services/hive/models/vpn_history.dart';

abstract interface class VpnHistoryLocalDataSource {
  List<VpnHistory> getHistory();

  void uploadHistory({required VpnHistory vpnHistory});
}

class VpnHistoryLocalDataSourceImpl implements VpnHistoryLocalDataSource {
  final Box<VpnHistory> box;

  const VpnHistoryLocalDataSourceImpl({required this.box});

  @override
  List<VpnHistory> getHistory() {
    List<VpnHistory> history = [];
    history = box.values.toList().reversed.toList();
    return history;
  }

  @override
  void uploadHistory({required VpnHistory vpnHistory}) {
    box.add(vpnHistory);
  }
}
