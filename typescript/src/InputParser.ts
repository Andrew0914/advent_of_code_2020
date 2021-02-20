export class InputParser {
  private input: string

  constructor(input: string) {
    this.input = input
  }

  getLines(): Array<string> {
    return this.input.split('\n');
  }

  getLinesCount(): number {
    return this.getLines().length
  }
}