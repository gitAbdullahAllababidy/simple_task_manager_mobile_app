import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

T lazyGetInstance<T extends Object>(
    String? instanceName, FactoryFunc<T> factoryFunc,
    {FutureOr<dynamic> Function(T)? dispose}) {
  if (sl.isRegistered<T>(
    instanceName: instanceName,
  )) {
    return sl<T>(
      instanceName: instanceName,
    );
  }

  sl.registerLazySingleton(factoryFunc,
      instanceName: instanceName, dispose: dispose);
  return sl.get<T>(instanceName: instanceName);
}

Either<dynamic, T> lazyGetInstanceIfExist<T extends Object>(
  String? instanceName,
) {
  if (sl.isRegistered<T>(instanceName: instanceName)) {
    return right(sl.get<T>(instanceName: instanceName));
  }

  return left(
      "The $instanceName instance with this type ${T.runtimeType.toString()} is not exist.");
}

T lazyGetInstanceWithoutId<T extends Object>(FactoryFunc<T> factoryFunc,
    {FutureOr<dynamic> Function(T)? dispose}) {
  if (sl.isRegistered<T>()) {
    return sl.get<T>();
  }

  sl.registerLazySingleton(factoryFunc, dispose: dispose);
  return sl.get<T>();
}

Either<dynamic, T> lazyGetInstanceWithoutIdIfExist<T extends Object>(
  FactoryFunc<T> factoryFunc,
) {
  if (sl.isRegistered<T>()) {
    return right(sl.get<T>());
  }

  return left("Not exist");
}
