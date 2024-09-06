import 'package:asyncstate/asyncstate.dart';
import 'package:multiplos_cadastros/src/core/exceptions/service_exception.dart';
import 'package:multiplos_cadastros/src/core/fp/either.dart';
import 'package:multiplos_cadastros/src/core/providers/application_providers.dart';
import 'package:multiplos_cadastros/src/features/auth/login/login_state.dart';
import 'package:multiplos_cadastros/src/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_vm.g.dart';

@riverpod
class LoginVm extends _$LoginVm {
  @override
  LoginState build() => LoginState.initial();

  Future<void> login(String email, String password) async {
    final loaderHandle = AsyncLoaderHandler()..start();

    final loginService = ref.watch(userLoginServiceProvider);

    final result = await loginService.execute(email, password);

    switch (result) {
      case Success():
        //Invalidando os caches para evitar login com usuário errado
        ref.invalidate(getMyCompanyProvider);
        ref.invalidate(getMeProvider);
        
        final userModel = await ref.read(getMeProvider.future);
        switch (userModel) {
          case UserModelADM():
            state = state.copyWith(status: LoginStateStatus.admLogin);
          case UserModelEmployee():
            state = state.copyWith(status: LoginStateStatus.employeeLogin);
        }

      case Failure(exception: ServiceException(:final message)):
        state = state.copyWith(
          status: LoginStateStatus.error,
          errorMessage: () => message,
        );
    }
    loaderHandle.close();
  }
}
