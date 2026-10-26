import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/router/app_router.dart';
import '../../../core/data/locations.dart';
import '../../../core/shared/widgets/buttons/app_back_button.dart';
import '../../../core/shared/widgets/buttons/app_primary_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../generated/locale_keys.g.dart';
import '../cubit/auth_cubit.dart';
import '../data/auth_repository.dart';
import '../models/user_role.dart';
import '../../../core/utils/validators.dart';
import '../widgets/auth_extras.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_role_widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Login passes the role that was selected there, so Sign Up starts on the same one.
    final arg = ModalRoute.of(context)?.settings.arguments;
    return BlocProvider(
      create: (_) {
        final cubit = AuthCubit(AuthRepository());
        if (arg is UserRole) cubit.selectRole(arg);
        return cubit;
      },
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final cubit = context.read<AuthCubit>();
    final formOk = _formKey.currentState!.validate();
    cubit.showTermsError();
    if (!formOk || !cubit.state.acceptedTerms) return;
    cubit.register(
      fullName: _name.text.trim(),
      email: _email.text.trim(),
      phone: Validators.normalizeEgyptPhone(_phone.text)!,
      password: _password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            state.role == UserRole.marketer ? AppRoutes.marketerRequests : AppRoutes.home,
            (_) => false,
          );
        } else if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.error!.text), backgroundColor: AppColors.error));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
          title: Text(LocaleKeys.authSignUpTitle.tr(), style: AppTextStyles.heading3.copyWith(color: AppColors.primaryDark)),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AuthHeader(
                        title: LocaleKeys.authJoinTitle.tr(),
                        subtitle: LocaleKeys.authJoinSubtitle.tr(),
                        showLanguageSwitch: false,
                        logoSize: 72,
                      ),
                      const SizedBox(height: 22),
                      Text(LocaleKeys.authAccountType.tr(), style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      BlocSelector<AuthCubit, AuthState, UserRole>(
                        selector: (state) => state.role,
                        builder: (context, role) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AuthRoleCard(
                              icon: Icons.person_search_rounded,
                              title: LocaleKeys.authRoleClient.tr(),
                              description: LocaleKeys.authClientCardDesc.tr(),
                              selected: role == UserRole.client,
                              onTap: () => context.read<AuthCubit>().selectRole(UserRole.client),
                            ),
                            const SizedBox(height: 10),
                            AuthRoleCard(
                              icon: Icons.business_center_outlined,
                              title: LocaleKeys.authRoleMarketer.tr(),
                              description: LocaleKeys.authMarketerCardDesc.tr(),
                              selected: role == UserRole.marketer,
                              onTap: () => context.read<AuthCubit>().selectRole(UserRole.marketer),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      AuthField(
                        label: LocaleKeys.authFullNameLabel.tr(),
                        controller: _name,
                        hint: LocaleKeys.authFullNameHint.tr(),
                        icon: Icons.badge_outlined,
                        textInputAction: TextInputAction.next,
                        validator: (v) => (v ?? '').trim().length < 3 ? LocaleKeys.authErrName.tr() : null,
                      ),
                      const SizedBox(height: 16),
                      AuthField(
                        label: LocaleKeys.emailLabel.tr(),
                        controller: _email,
                        hint: LocaleKeys.authEmailHint.tr(),
                        icon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (v) {
                          final t = (v ?? '').trim();
                          if (t.isEmpty) return LocaleKeys.authErrRequired.tr();
                          return Validators.isEmail(t) ? null : LocaleKeys.authErrIdentifier.tr();
                        },
                      ),
                      const SizedBox(height: 16),
                      AuthField(
                        label: LocaleKeys.authPhoneWhatsapp.tr(),
                        controller: _phone,
                        hint: LocaleKeys.authPhoneHint.tr(),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        prefix: const PhonePrefix(),
                        validator: (v) {
                          if ((v ?? '').trim().isEmpty) return LocaleKeys.authErrRequired.tr();
                          return Validators.normalizeEgyptPhone(v!) == null ? LocaleKeys.authErrPhone.tr() : null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AuthDropdownField(
                              label: LocaleKeys.authCityLabel.tr(),
                              icon: Icons.location_city_rounded,
                              value: context.read<AuthCubit>().state.cityId,
                              items: [
                                for (final c in Locations.cities) DropdownMenuItem(value: c.id, child: Text(c.name(lang), overflow: TextOverflow.ellipsis)),
                              ],
                              onChanged: (v) {
                                if (v != null) context.read<AuthCubit>().selectCity(v);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            // only the district list rebuilds when the city or district changes
                            child: BlocBuilder<AuthCubit, AuthState>(
                              buildWhen: (p, c) => p.cityId != c.cityId || p.districtId != c.districtId,
                              builder: (context, state) => AuthDropdownField(
                                key: ValueKey('district-${state.cityId}'), // fresh list when the city changes
                                label: LocaleKeys.authDistrictLabel.tr(),
                                icon: Icons.place_outlined,
                                hint: LocaleKeys.authSelectHint.tr(),
                                value: state.districtId,
                                items: [
                                  for (final d in Locations.districtsOf(state.cityId)) DropdownMenuItem(value: d.id, child: Text(d.name(lang), overflow: TextOverflow.ellipsis)),
                                ],
                                onChanged: context.read<AuthCubit>().selectDistrict,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      AuthPasswordField(
                        label: LocaleKeys.authSetPassword.tr(),
                        controller: _password,
                        hint: LocaleKeys.authPasswordHint.tr(),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        validator: (v) => Validators.isStrongPassword(v ?? '') ? null : LocaleKeys.authErrPassword.tr(),
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<AuthCubit, AuthState>(
                        buildWhen: (p, c) => p.acceptedTerms != c.acceptedTerms || p.termsError != c.termsError,
                        builder: (context, state) => AuthCheckRow(
                          value: state.acceptedTerms,
                          label: LocaleKeys.authAgreeTerms.tr(),
                          errorText: state.termsError ? LocaleKeys.authErrTerms.tr() : null,
                          onChanged: context.read<AuthCubit>().setTerms,
                        ),
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<AuthCubit, AuthState>(
                        buildWhen: (p, c) => p.role != c.role || p.status != c.status,
                        builder: (context, state) => AppPrimaryButton(
                          label: state.role == UserRole.client ? LocaleKeys.authSignUpClient.tr() : LocaleKeys.authSignUpMarketer.tr(),
                          icon: Icons.check_rounded,
                          isLoading: state.status == AuthStatus.loading,
                          onPressed: _submit,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(LocaleKeys.authHaveAccount.tr(), style: AppTextStyles.bodySmall),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => Navigator.of(context).maybePop(),
                            child: Text(
                              LocaleKeys.authLoginLink.tr(),
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
