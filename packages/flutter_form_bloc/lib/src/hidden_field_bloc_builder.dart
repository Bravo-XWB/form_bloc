import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

export 'package:flutter/services.dart'
    show TextInputType, TextInputAction, TextCapitalization;
export 'package:flutter/widgets.dart' show EditableText;
export 'package:flutter_form_bloc/src/flutter_typeahead.dart'
    show SuggestionsBoxDecoration;

/// A hidden text field.
class HiddenFieldBlocBuilder extends StatefulWidget {
  const HiddenFieldBlocBuilder({
    Key? key,
    required this.textFieldBloc,
    this.isEnabled = true,
    this.errorBuilder,
  }) : super(key: key);

  /// {@template flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  /// The `fieldBloc` for rebuild the widget
  /// when its state changes.
  /// {@endtemplate}
  final TextFieldBloc<dynamic> textFieldBloc;

  /// {@template flutter_form_bloc.FieldBlocBuilder.errorBuilder}
  /// This function take the `context` and the [FieldBlocState.error]
  /// and must return a String error to display in the widget when
  /// has an error or null if you don't want to display the error.
  /// By default is [FieldBlocBuilder.defaultErrorBuilder].
  /// {@endtemplate}
  final FieldBlocErrorBuilder? errorBuilder;

  /// {@template flutter_form_bloc.FieldBlocBuilder.isEnabled}
  ///  If false the text field is "disabled": it ignores taps
  /// and its [decoration] is rendered in grey.
  /// {@endtemplate}
  final bool isEnabled;

  @override
  _TextFieldBlocBuilderState createState() => _TextFieldBlocBuilderState();
}

class _TextFieldBlocBuilderState extends State<HiddenFieldBlocBuilder> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.textFieldBloc.state.value);
    _controller.addListener(_textControllerListener);
  }

  @override
  void didUpdateWidget(covariant HiddenFieldBlocBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.removeListener(_textControllerListener);
    _controller.dispose();
    super.dispose();
  }

  /// Disable editing when the state of the FormBloc is [FormBlocSubmitting].
  void _textControllerListener() {
    if (widget.textFieldBloc.state.formBloc?.state is FormBlocSubmitting) {
      if (_controller.text != (widget.textFieldBloc.value)) {
        _fixControllerTextValue(widget.textFieldBloc.value);
      }
    }
  }

  void _fixControllerTextValue(String value) async {
    _controller
      ..text = value
      ..selection = TextSelection.collapsed(offset: _controller.text.length);

    // TODO: Find out why the cursor returns to the beginning.
    await Future.delayed(const Duration(milliseconds: 0));
    _controller.selection =
        TextSelection.collapsed(offset: _controller.text.length);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleFieldBlocBuilder(
      singleFieldBloc: widget.textFieldBloc,
      builder: (_, __) {
        return BlocBuilder<TextFieldBloc, TextFieldBlocState>(
          bloc: widget.textFieldBloc,
          builder: (context, state) {
            if (_controller.text != state.value) {
              _fixControllerTextValue(state.value);
            }

            return _buildTextField(
              state: state,
            );
          },
        );
      },
    );
  }

  Widget _buildTextField({
    required TextFieldBlocState state,
  }) {
    return const SizedBox();
  }
}
