import { FileReader } from './FileReader';
import { InputParser } from './InputParser';

interface Steps {
  stepsX: number, stepsY: number
}

export class TreeFinder {
  private forest: Array<string>

  constructor(forestFile: string) {
    this.forest = this.getForest(forestFile)
  }

  private getForest(foresFile: string) {
    const reader = new FileReader(foresFile);
    return new InputParser(reader.getContent()).getLines();
  }

  private encounterTree(square: string): number {
    return square === "#" ? 1 : 0
  }

  private countTrees(forest: Array<string>, stepsX: number, stepsY: number): number {
    let countTrees = 0;
    let x = 0
    for (let y = stepsY; y < forest.length; y += stepsY) {
      x += stepsX
      if (x >= forest[y].length - 1)
        x = x % (forest[y].length - 1)
      countTrees += this.encounterTree(forest[y].charAt(x))
    }
    return countTrees;
  }

  public howManyTrees(steps: Steps): number {
    return this.countTrees(this.forest, steps.stepsX, steps.stepsY);
  }

  public bulkFind(stepsList: Array<Steps>): Array<number> {
    const treecounter: Array<number> = new Array()
    stepsList.forEach(steps => {
      treecounter.push(this.howManyTrees(steps))
    })
    return treecounter
  }
}
