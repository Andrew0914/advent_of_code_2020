import { FileReader } from './FileReader';
import { InputParser } from './InputParser';

function encounterTree(square: string): number {
  return square === "#" ? 1 : 0
}

function countTrees(forest: Array<string>, stepsX: number, stepsY: number): number {
  let countTrees = 0;
  let x = 0
  for (let y = stepsY; y < forest.length; y += stepsY) {
    x += stepsX
    if (x  >= forest[y].length - 1)
      x = x - (forest[y].length - 1)    
    countTrees += encounterTree(forest[y].charAt(x))
  }
  return countTrees;
}

interface Steps {
  stepsX: number, stepsY: number
}
export function howManyTrees(foresFile: string, steps: Steps): number {
  const reader = new FileReader(foresFile);
  const forest = new InputParser(reader.getContent()).getLines();
  return countTrees(forest, steps.stepsX, steps.stepsY);
}
