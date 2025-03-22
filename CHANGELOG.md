## 2.4.0
- Add a elevation parameter
- Add a margin parameter

## 2.3.0
- Add an option to configure open & close button alignment

## 2.2.0
- Made to work without Scaffold.
- Add ExpandableFabPos.center.
- Add 'of' method.

## 2.1.0
- Allows children's animations to be changed.
- Fixed animation issues.
- Fixed issue with some properties not being reflected when hot reloading.
- overlayStyle supports setting both color and blur.

## 2.0.0
- Changed customization to a builder-based method.
- Left-handed mode added.
- Fixed some minor bugs.

##### Braking changes: 
Removed foregroundColor, backgroundColor, closeButtonStyle, expandedFabSize, and others.
Use Default/RotateFloatingActionButtonBuilder or FloatingActionButtonBuilder instead.

## 1.8.1
- Fixed overlap with snackbar.
- Fixed onTap being executed with action button closed

## 1.8.0
- Allow changing the shape of the FAB.
  
## 1.7.1
- Fixed a issue when there is only one child.

## 1.7.0+1
- Updated docs.
  
## 1.7.0
- Allow changing the size of the FAB.
  
## 1.6.1
- Added heroTag parameters.
  
## 1.6.0
- Added new event callbacks (afterOpen() / afterClose())

## 1.5.2
- Fixed a bug with blur on the web.

## 1.5.1
- Fix issue with FAB not being displayed when overlayStyle is NULL.

## 1.5.0
- Fix issue with buttons not disappearing on Navigator push
- Adjust button position.
  
##### `floatingActionButtonLocation` is now required.
```dart
Scaffold(
  floatingActionButtonLocation: ExpandableFab.location,
  ...
```

## 1.4.0
- Add programmatic open/close.

## 1.3.0
- Add overlay fade animation.

## 1.2.0
- Add overlay.
- Add onOpen/onClose.
  
## 1.1.0
- Remove heroTag.

## 1.0.0
- Initial version.
