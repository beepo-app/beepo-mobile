import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ScreenshotPermissionSwitch extends StatefulWidget {
  const ScreenshotPermissionSwitch({Key key}) : super(key: key);

  @override
  _ScreenshotPermissionSwitchState createState() =>
      _ScreenshotPermissionSwitchState();
}

class _ScreenshotPermissionSwitchState
    extends State<ScreenshotPermissionSwitch> {
  bool _isSwitched;
  PermissionStatus _permissionStatus;

  @override
  void initState() {
    super.initState();
    _isSwitched = false;
    _getPermissionStatus();
  }

  Future<void> _getPermissionStatus() async {
    final status = await Permission.storage.status;
    setState(() {
      _permissionStatus = status;
    });
  }

  Future<void> _requestPermission() async {
    final status = await Permission.storage.request();
    setState(() {
      _permissionStatus = status;
    });
  }

  Future<void> _toggleSwitch(bool value) async {
    if (value) {
      final status = await Permission.storage.status;
      if (status.isGranted) {
        setState(() {
          _isSwitched = value;
        });
      } else {
        final isPermanentlyDenied =
            await Permission.storage.isPermanentlyDenied;
        if (isPermanentlyDenied) {
          // Show a dialog or snackbar explaining that the user needs to go
          // to the app settings to enable the permission.
          return;
        }

        final isDenied = await Permission.storage.isDenied;
        if (isDenied) {
          await _requestPermission();
          if (_permissionStatus.isGranted) {
            setState(() {
              _isSwitched = value;
            });
          }
        }
      }
    } else {
      setState(() {
        _isSwitched = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Allow Screenshots'),
      subtitle: _permissionStatus.isGranted
          ? const Text('Screenshots are allowed.')
          : const Text('Screenshots are not allowed.'),
      value: _isSwitched,
      onChanged: (value) async {
        await _toggleSwitch(value);
      },
    );
  }
}
