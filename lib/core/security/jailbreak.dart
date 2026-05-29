import 'dart:io';

class JailbreakDetector {
  static bool get isJailbroken {
    if (!Platform.isIOS) return false;
    return _checkPaths() || _checkSchemes();
  }

  static bool _checkPaths() {
    final paths = [
      '/Applications/Cydia.app',
      '/Applications/FakeCarrier.app',
      '/Applications/Icy.app',
      '/Applications/IntelliScreen.app',
      '/Applications/MxTube.app',
      '/Applications/RockApp.app',
      '/Applications/SBSettings.app',
      '/Applications/WinterBoard.app',
      '/Library/MobileSubstrate/MobileSubstrate.dylib',
      '/bin/bash',
      '/etc/apt',
      '/private/var/lib/apt',
      '/private/var/mobile/Library/SBSettings/Themes',
      '/private/var/stash',
      '/private/var/tmp/cydia.log',
      '/usr/bin/sshd',
      '/usr/libexec/ssh-keysign',
      '/usr/sbin/sshd',
      '/var/cache/apt',
      '/var/lib/apt',
      '/var/lib/cydia',
      '/var/log/syslog',
      '/var/tmp/cydia.log',
    ];
    return paths.any((path) => File(path).existsSync());
  }

  static bool _checkSchemes() {
    return false;
  }
}
