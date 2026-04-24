import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/models/app_user.dart';
import 'package:chat_app/services/chat_repository.dart';
import 'package:chat_app/widgets/my_profile.dart';
import 'package:chat_app/widgets/notification_settings.dart';
import 'package:chat_app/widgets/security_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/my_search_bar.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final chatRepository = ChatRepository();

  Future<void> logOut() async {
    final shouldLogOut = await _showConfirmDialog(
      title: 'Log Out',
      message: 'Are you sure you want to log out of MadaniChat?',
      confirmTitle: 'Log out',
    );

    if (shouldLogOut != true) {
      return;
    }

    if (!mounted) return;
    await FirebaseAuth.instance.signOut();
  }

  Future<void> deleteAccount() async {
    final passwordController = TextEditingController();
    await _showDeleteAccountDialog(passwordController);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    passwordController.dispose();
  }

  Future<void> editProfile(AppUser user) async {
    final nameController = TextEditingController(text: user.displayName);
    final aboutController = TextEditingController(text: user.about);

    await _showAppDialog(
      title: 'Edit Profile',
      fields: [
        _DialogField(label: 'Name', controller: nameController),
        _DialogField(
          label: 'Description',
          controller: aboutController,
          maxLines: 3,
        ),
      ],
      onSave: () async {
        await chatRepository.updateProfile(
          displayName: nameController.text,
          about: aboutController.text,
        );
        if (!mounted) return;
        _showMessage('Profile updated.');
      },
    );

    await Future<void>.delayed(const Duration(milliseconds: 350));
    nameController.dispose();
    aboutController.dispose();
  }

  Future<void> editSecurity(AppUser user) async {
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phoneNumber);
    final passwordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    await _showSecurityDialog(
      emailController: emailController,
      phoneController: phoneController,
      currentPasswordController: passwordController,
      newPasswordController: newPasswordController,
      confirmPasswordController: confirmPasswordController,
    );

    await Future<void>.delayed(const Duration(milliseconds: 350));
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  Future<void> _showAppDialog({
    required String title,
    required List<_DialogField> fields,
    required Future<void> Function() onSave,
  }) async {
    bool isSaving = false;
    bool dialogOpen = true;

    void closeDialog(BuildContext dialogContext) {
      dialogOpen = false;
      FocusManager.instance.primaryFocus?.unfocus();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (dialogContext.mounted && Navigator.canPop(dialogContext)) {
          Navigator.pop(dialogContext);
        }
      });
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return _SettingsDialogShell(
              title: title,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final field in fields) ...[
                    _DialogTextField(field: field),
                    const SizedBox(height: 12),
                  ],
                  _DialogActions(
                    isSaving: isSaving,
                    onCancel: () => closeDialog(context),
                    onSave: () async {
                      if (!dialogOpen) return;
                      setDialogState(() {
                        isSaving = true;
                      });

                      try {
                        await onSave();
                        if (context.mounted && dialogOpen) {
                          closeDialog(context);
                        }
                      } catch (error) {
                        if (context.mounted && dialogOpen) {
                          _showDialogError(error);
                        }
                      } finally {
                        if (context.mounted && dialogOpen) {
                          setDialogState(() {
                            isSaving = false;
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showSecurityDialog({
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required TextEditingController currentPasswordController,
    required TextEditingController newPasswordController,
    required TextEditingController confirmPasswordController,
  }) async {
    bool isUnlocked = false;
    bool isSaving = false;
    bool dialogOpen = true;
    String? passwordError;

    void closeDialog(BuildContext dialogContext) {
      dialogOpen = false;
      FocusManager.instance.primaryFocus?.unfocus();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (dialogContext.mounted && Navigator.canPop(dialogContext)) {
          Navigator.pop(dialogContext);
        }
      });
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return _SettingsDialogShell(
              title: 'Edit Security',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isUnlocked) ...[
                    Text(
                      'Enter your current password to edit security details.',
                      style: GoogleFonts.quicksand(
                        color: customGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DialogTextField(
                      field: _DialogField(
                        label: 'Current password',
                        controller: currentPasswordController,
                        obscureText: true,
                        errorText: passwordError,
                      ),
                    ),
                    if (passwordError != null) ...[
                      const SizedBox(height: 8),
                      _InlineErrorText(passwordError!),
                    ],
                    const SizedBox(height: 12),
                    _DialogActions(
                      isSaving: isSaving,
                      saveTitle: 'Unlock',
                      savingTitle: 'Checking...',
                      onCancel: () => closeDialog(context),
                      onSave: () async {
                        if (!dialogOpen) return;
                        setDialogState(() {
                          isSaving = true;
                          passwordError = null;
                        });

                        try {
                          await chatRepository.verifyCurrentPassword(
                            currentPasswordController.text,
                          );
                          if (!context.mounted || !dialogOpen) return;
                          setDialogState(() {
                            isUnlocked = true;
                            isSaving = false;
                          });
                        } catch (error) {
                          if (context.mounted && dialogOpen) {
                            setDialogState(() {
                              passwordError = _errorMessage(error);
                              isSaving = false;
                            });
                          }
                        }
                      },
                    ),
                  ] else ...[
                    _DialogTextField(
                      field: _DialogField(
                        label: 'Email',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DialogTextField(
                      field: _DialogField(
                        label: 'Phone number',
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DialogTextField(
                      field: _DialogField(
                        label: 'New password',
                        controller: newPasswordController,
                        obscureText: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DialogTextField(
                      field: _DialogField(
                        label: 'Confirm new password',
                        controller: confirmPasswordController,
                        obscureText: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DialogActions(
                      isSaving: isSaving,
                      onCancel: () => closeDialog(context),
                      onSave: () async {
                        if (!dialogOpen) return;
                        setDialogState(() {
                          isSaving = true;
                        });

                        try {
                          if (newPasswordController.text !=
                              confirmPasswordController.text) {
                            throw ArgumentError('Passwords do not match.');
                          }

                          await chatRepository.updateSecuritySettings(
                            currentPassword: currentPasswordController.text,
                            email: emailController.text,
                            phoneNumber: phoneController.text,
                            newPassword: newPasswordController.text,
                          );
                          if (!mounted) return;
                          _showMessage('Security settings updated.');
                          if (context.mounted && dialogOpen) {
                            closeDialog(context);
                          }
                        } catch (error) {
                          if (context.mounted && dialogOpen) {
                            _showDialogError(error);
                          }
                        } finally {
                          if (context.mounted && dialogOpen) {
                            setDialogState(() {
                              isSaving = false;
                            });
                          }
                        }
                      },
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showDeleteAccountDialog(
    TextEditingController passwordController,
  ) async {
    bool isDeleting = false;
    bool dialogOpen = true;
    String? passwordError;

    void closeDialog(BuildContext dialogContext) {
      dialogOpen = false;
      FocusManager.instance.primaryFocus?.unfocus();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (dialogContext.mounted && Navigator.canPop(dialogContext)) {
          Navigator.pop(dialogContext);
        }
      });
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return _SettingsDialogShell(
              title: 'Delete Account',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: lightRed,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0X4DFF7777),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'This will permanently delete your account, profile, contacts, friend requests, chats, and messages.',
                      style: GoogleFonts.quicksand(
                        color: red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _DialogTextField(
                    field: _DialogField(
                      label: 'Current password',
                      controller: passwordController,
                      obscureText: true,
                      errorText: passwordError,
                    ),
                  ),
                  if (passwordError != null) ...[
                    const SizedBox(height: 8),
                    _InlineErrorText(passwordError!),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: isDeleting ? null : () => closeDialog(context),
                          child: MyButton(
                            title: 'Cancel',
                            fontSize: 15,
                            color: lightRed,
                            shadowEnabled: false,
                            fontColor: fontColor,
                            border: Border.all(
                              color: strokeColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: isDeleting
                              ? null
                              : () async {
                                  setDialogState(() {
                                    isDeleting = true;
                                    passwordError = null;
                                  });

                                  try {
                                    await chatRepository.deleteCurrentAccount(
                                      currentPassword: passwordController.text,
                                    );
                                    if (context.mounted && dialogOpen) {
                                      closeDialog(context);
                                    }
                                  } catch (error) {
                                    if (context.mounted && dialogOpen) {
                                      setDialogState(() {
                                        passwordError = _errorMessage(error);
                                        isDeleting = false;
                                      });
                                    }
                                  }
                                },
                          child: MyButton(
                            title: isDeleting ? 'Deleting...' : 'Delete',
                            fontSize: 15,
                            color: lightRed,
                            shadowEnabled: false,
                            fontColor: red,
                            border: Border.all(
                              color: const Color(0X4DFF7777),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<bool?> _showConfirmDialog({
    required String title,
    required String message,
    required String confirmTitle,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return _SettingsDialogShell(
          title: title,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.yellow[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: strokeColor),
                ),
                child: Text(
                  message,
                  style: GoogleFonts.quicksand(
                    color: customGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _DialogActions(
                isSaving: false,
                saveTitle: confirmTitle,
                onCancel: () => Navigator.pop(context, false),
                onSave: () async => Navigator.pop(context, true),
              ),
            ],
          ),
        );
      },
    );
  }

  String _errorMessage(Object error) {
    return switch (error) {
      FirebaseAuthException(code: 'wrong-password') =>
        'Current password is incorrect.',
      FirebaseAuthException(code: 'invalid-credential') =>
        'Current password is incorrect.',
      FirebaseAuthException(:final message) =>
        message ?? 'Unable to update settings.',
      _ => error.toString().replaceFirst('Invalid argument(s): ', ''),
    };
  }

  void _showDialogError(Object error) {
    ScaffoldMessenger.of(this.context).showSnackBar(
      SnackBar(
        content: Text(_errorMessage(error)),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MySearchBar(),
        const SizedBox(height: 15),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: boxShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 15),
                  child: Text(
                    'Settings',
                    style: GoogleFonts.quicksand(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<AppUser>(
                    stream: chatRepository.watchCurrentUserProfile(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Unable to load settings.',
                            style: GoogleFonts.quicksand(color: red),
                          ),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final user = snapshot.data;
                      if (user == null) {
                        return const SizedBox.shrink();
                      }

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            ProfileWidget(
                              user: user,
                              onEdit: () => editProfile(user),
                            ),
                            const SizedBox(height: 20),
                            SecurityWidget(
                              user: user,
                              onEdit: () => editSecurity(user),
                            ),
                            const SizedBox(height: 20),
                            const NotificationWidget(),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: logOut,
                              child: MyButton(
                                title: 'Log out',
                                fontSize: 16,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                color: lightRed,
                                shadowEnabled: false,
                                fontColor: fontColor,
                                border:
                                    Border.all(color: strokeColor, width: 2),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: deleteAccount,
                              child: MyButton(
                                title: 'Delete Account',
                                fontSize: 16,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                color: lightRed,
                                shadowEnabled: false,
                                fontColor: red,
                                border: Border.all(
                                  color: const Color(0X4DFF7777),
                                  width: 2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DialogField {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final String? errorText;

  const _DialogField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.errorText,
  });
}

class _SettingsDialogShell extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingsDialogShell({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: boxShadow,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.quicksand(
                  color: customGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogTextField extends StatelessWidget {
  final _DialogField field;

  const _DialogTextField({
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.yellow[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: field.errorText == null ? strokeColor : red,
          width: field.errorText == null ? 1 : 1.5,
        ),
      ),
      child: TextField(
        controller: field.controller,
        keyboardType: field.keyboardType,
        obscureText: field.obscureText,
        maxLines: field.obscureText ? 1 : field.maxLines,
        cursorColor: Colors.yellow[700],
        style: GoogleFonts.quicksand(
          color: grey_333,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          labelText: field.label,
          labelStyle: GoogleFonts.quicksand(
            color: field.errorText == null ? lightGrey : red,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
}

class _InlineErrorText extends StatelessWidget {
  final String message;

  const _InlineErrorText(this.message);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.error_outline, color: red, size: 16),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            message,
            style: GoogleFonts.quicksand(
              color: red,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _DialogActions extends StatelessWidget {
  final bool isSaving;
  final String saveTitle;
  final String savingTitle;
  final VoidCallback onCancel;
  final Future<void> Function() onSave;

  const _DialogActions({
    required this.isSaving,
    required this.onCancel,
    required this.onSave,
    this.saveTitle = 'Save',
    this.savingTitle = 'Saving...',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: isSaving ? null : onCancel,
            child: MyButton(
              title: 'Cancel',
              fontSize: 15,
              color: lightRed,
              shadowEnabled: false,
              fontColor: fontColor,
              border: Border.all(color: strokeColor, width: 1.5),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: isSaving ? null : onSave,
            child: MyButton(
              title: isSaving ? savingTitle : saveTitle,
              fontSize: 15,
              color: Colors.yellow[500],
              shadowEnabled: false,
              fontColor: Colors.black,
              border: Border.all(color: Colors.yellow.shade600, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
