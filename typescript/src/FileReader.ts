import { readFileSync } from 'fs';

export class FileReader {
  filePath: string;

  constructor(filePath: string) {
    this.filePath = filePath;
  }

  getContent(): string {
    const buffer = readFileSync(this.filePath);
    return buffer.toString();
  }

  getLines(): Array<string> {
    return this.getContent().split('\n');
  }
}
