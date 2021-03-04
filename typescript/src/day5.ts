import { FileReader } from './FileReader';

interface PositionItem {
  regex: RegExp;
  from: number;
  to: number;
}

export class SeatFinder {
  private boardingPasses: Array<string>;

  private ROW: PositionItem = {
    regex: /[FB]+/,
    from: 0,
    to: 127,
  };

  private COLUM: PositionItem = {
    regex: /[LR]+/,
    from: 0,
    to: 7,
  };

  constructor(boardingPassesFilePath: string) {
    this.boardingPasses = new FileReader(boardingPassesFilePath).getLines();
  }

  public findPosition(
    passInfo: string,
    index: number,
    from: number,
    to: number
  ): number {
    let newFrom = 0;
    let newTo = 0;

    const positionsFromTo = to - from + 1;
    const midPointPositions = positionsFromTo / 2;

    if (passInfo.charAt(index).match(/^(F|L)$/)) {
      newFrom = from;
      newTo = from + midPointPositions - 1;
    } else if (passInfo.charAt(index).match(/^(B|R)$/)) {
      newFrom = from + midPointPositions;
      newTo = to;
    }

    if (index + 1 < passInfo.length)
      return this.findPosition(passInfo, index + 1, newFrom, newTo);
    return newFrom;
  }

  private getValueFrom(
    positionItem: PositionItem,
    boardingPass: string
  ): number {
    const passInfo = boardingPass.match(positionItem.regex);
    const position = this.findPosition(
      passInfo ? passInfo[0] : '',
      0,
      positionItem.from,
      positionItem.to
    );
    return position;
  }

  private calculateID(row: number, column: number): number {
    return row * 8 + column;
  }

  public mapPassesWithID(): Map<number, string> {
    const mapPassesWithID = new Map<number, string>();
    this.boardingPasses.forEach(pass => {
      const passID = this.calculateID(
        this.getValueFrom(this.ROW, pass),
        this.getValueFrom(this.COLUM, pass)
      );
      mapPassesWithID.set(passID, pass);
    });
    return mapPassesWithID;
  }

  public getHighestID(): number {
    const boardingPassesIDs = Array.from(this.mapPassesWithID().keys()).sort(
      (a, b) => a - b // si el valor es negativo = menor, positivo = mayor, 0 = iguales
    );
    return boardingPassesIDs[boardingPassesIDs.length - 1];
  }
}
