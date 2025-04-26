extension SwapString on String {
  String swapId({required String id}) {
    return this.replaceAll('{id}', id);
  }
}
