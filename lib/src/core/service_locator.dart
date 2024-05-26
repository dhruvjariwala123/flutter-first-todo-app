import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_todo_app/src/core/network_service.dart';
import 'package:first_todo_app/src/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:first_todo_app/src/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:first_todo_app/src/features/auth/data/repositories/auth_repository_implementation.dart';
import 'package:first_todo_app/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:first_todo_app/src/features/auth/domain/usecases/logout_usecase.dart';
import 'package:first_todo_app/src/features/auth/domain/usecases/registration_usecase.dart';
import 'package:first_todo_app/src/features/home/presentation/bloc/home_bloc.dart';
import 'package:first_todo_app/src/features/sync/data/repositories/sync_todo_repository_impl.dart';
import 'package:first_todo_app/src/features/sync/domain/usecases/is_sync_needed_usecase.dart';
import 'package:first_todo_app/src/features/sync/domain/usecases/sync_todo_data_from_cloud_to_local_usecase.dart';
import 'package:first_todo_app/src/features/sync/domain/usecases/sync_todo_data_from_local_to_cloud_usecase.dart';
import 'package:first_todo_app/src/features/sync/presentation/bloc/bloc/sync_todo_bloc.dart';
import 'package:first_todo_app/src/features/todo/data/data_sources/local/todo_local_data_source.dart';
import 'package:first_todo_app/src/features/todo/data/data_sources/remote/todo_remote_data_source.dart';
import 'package:first_todo_app/src/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:first_todo_app/src/features/todo/domain/repositories/todo_repository.dart';
import 'package:first_todo_app/src/features/todo/domain/usecases/add_todo_usecase.dart';
import 'package:first_todo_app/src/features/todo/domain/usecases/change_todo_complete_status_usecase.dart';
import 'package:first_todo_app/src/features/todo/domain/usecases/delete_todo_usecase.dart';
import 'package:first_todo_app/src/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:first_todo_app/src/features/todo/domain/usecases/update_todo_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/sync/domain/repositories/sync_todo_repository.dart';

class ServiceManager {
  static final sl = GetIt.instance;
  static Future<void> setupServices() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    sl
      ..registerSingleton(firebaseAuth)
      ..registerSingleton(firebaseFirestore)
      ..registerSingleton(Connectivity())
      ..registerSingleton(NetworkService(connectivity: sl<Connectivity>()))
      ..registerSingleton(await SharedPreferences.getInstance())
      ..registerSingleton(
          AuthLocalDataSource(sharePref: sl<SharedPreferences>()))
      ..registerSingleton(AuthRemoteDataSource(
          firebaseAuth: sl<FirebaseAuth>(),
          firebaseFirestore: sl<FirebaseFirestore>()))
      ..registerSingleton(TodoRemoteDataSource(
          firebaseFirestore: firebaseFirestore, firebaseAuth: firebaseAuth))
      ..registerSingleton(
        TodoLocalDataSource(
          sharedPref: sl<SharedPreferences>(),
        ),
      )
      ..registerSingleton<AuthRepository>(AuthRepositoryImpl(
        remoteDataSource: sl<AuthRemoteDataSource>(),
        localDataSource: sl<AuthLocalDataSource>(),
        todoLocal: sl<TodoLocalDataSource>(),
      ))
      ..registerSingleton<TodoRepository>(
        TodoRepositoryImlp(
            todoRemote: sl<TodoRemoteDataSource>(),
            todoLocal: sl<TodoLocalDataSource>(),
            networkService: sl<NetworkService>()),
      )
      ..registerSingleton<SyncTodoRepository>(SyncTodoRepositoryImpl(
          todoRemote: sl<TodoRemoteDataSource>(),
          todoLocal: sl<TodoLocalDataSource>(),
          networkService: sl<NetworkService>()))
      ..registerSingleton(LoginUsecase(sl<AuthRepository>()))
      ..registerSingleton(RegistrationUsecase(sl<AuthRepository>()))
      ..registerSingleton(LogOutUsecase(sl<AuthRepository>()))
      ..registerSingleton(AddTodoUsecase(todoRepository: sl<TodoRepository>()))
      ..registerSingleton(GetTodosUsecase(todoRepository: sl<TodoRepository>()))
      ..registerSingleton(
          ChangeTodoCompleteStatusUsecase(todoRepository: sl<TodoRepository>()))
      ..registerSingleton(
          DeleteTodoUsecase(todoRepository: sl<TodoRepository>()))
      ..registerSingleton(
          UpdateTodoUsecase(todoRepository: sl<TodoRepository>()))
      ..registerSingleton(
          IsSyncNeededUsecase(syncTodoRepo: sl<SyncTodoRepository>()))
      ..registerSingleton(
        SyncTodoDataFromCloudToLocalUsecase(
          syncTodoRepo: sl<SyncTodoRepository>(),
        ),
      )
      ..registerSingleton(SyncTodoDataFromLocalToCloudUsecase(
          syncTodoRepo: sl<SyncTodoRepository>()))
      ..registerFactory<AuthBloc>(
        () => AuthBloc(
            logOutUsecase: sl<LogOutUsecase>(),
            loginUsecase: sl<LoginUsecase>(),
            registrationUsecase: sl<RegistrationUsecase>()),
      )
      ..registerFactory<HomeBloc>(
        () => HomeBloc(
          addTodoUsecase: sl<AddTodoUsecase>(),
          changeTodoCompleteStatusUsecase:
              sl<ChangeTodoCompleteStatusUsecase>(),
          deleteTodoUsecase: sl<DeleteTodoUsecase>(),
          getTodosUsecase: sl<GetTodosUsecase>(),
          updateTodoUsecase: sl<UpdateTodoUsecase>(),
          isSyncNeededUseCase: sl<IsSyncNeededUsecase>(),
        ),
      )
      ..registerFactory<SyncTodoBloc>(() => SyncTodoBloc(
          syncTodoDataFromCloudToLocalUsecase:
              sl<SyncTodoDataFromCloudToLocalUsecase>(),
          syncTodoDataFromLocalToCloudUsecase:
              sl<SyncTodoDataFromLocalToCloudUsecase>()));
  }
}
