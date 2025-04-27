extension SwapString on String {
  String swapId({required String id}) {
    return replaceAll('{id}', id);
  }
}
