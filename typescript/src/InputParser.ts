export class InputParser {
  private input: string

  constructor(input: string) {
    this.input = input
  }

  getLines(sepatator: string | RegExp = '\n'): Array<string> {
    return this.input.split(sepatator);
  }

  getLinesCount(): number {
    return this.getLines().length
  }
}