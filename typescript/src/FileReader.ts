import { readFileSync } from 'fs';

export class FileReader {
  private filePath: string;

  constructor(filePath: string) {
    this.filePath = filePath;
  }

  getContent(): string {
    const buffer = readFileSync(this.filePath);
    return buffer.toString();
  }
}
