part of hetimaregex;

class RegexEasyParser extends heti.MiniParser {
  RegexEasyParser(heti.Reader builder) : super(builder) {}

  async.Future<List<List<int>>> readFromCommand(List<RegexCommand> command) {
    RegexVM vm = new RegexVM.createFromCommand(command);
    return vm.lookingAtFromEasyParser(this);
  }
}
