import { readFileSync } from 'fs';
import { InputParser } from './InputParser';
export class FileReader {
  private filePath: string;

  constructor(filePath: string) {
    this.filePath = filePath;
  }

  getContent(): string {
    const buffer = readFileSync(this.filePath);
    return buffer.toString();
  }

  getLines(sepatator: string | RegExp = '\n'): Array<string> {
    return new InputParser(this.getContent()).getLines(sepatator);
  }
}
