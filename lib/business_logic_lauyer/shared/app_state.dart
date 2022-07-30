part of 'app_cubit.dart';

@immutable
abstract class AppStates {}

class AppInitial extends AppStates {}

class AppChangeBottomNavBarState extends AppStates {}

class AppCreateDatabaseState extends AppStates {}
class AppGetDatabaseState extends AppStates {}
class AppGetDatabaseLoadingState extends AppStates {}
class AppInsertDatabaseState extends AppStates {}
class AppUpdateDatabaseState extends AppStates {}

class AppChangeBottomSheetState extends AppStates {}

class AppSetDefaultResultInFieldsState extends AppStates {}