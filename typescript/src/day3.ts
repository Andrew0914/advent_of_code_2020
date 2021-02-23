import { FileReader } from './FileReader';
import { InputParser } from './InputParser';

function areThereAvailableSpaces(steps: number, availableSpace: number): boolean {
  return steps <= availableSpace
}

function encounterTree(square: string): number {
  return square === "#" ? 1 : 0
}

function countTrees(forest: Array<string>, stepsX: number, stepsY: number): number {
  let countTrees = 0;
  let currentX = 0
  for (let y = stepsY; y < forest.length; y += stepsY) {
    const availableXSpaces = forest[y].length - 1 -  currentX
    if (!areThereAvailableSpaces(stepsX, availableXSpaces))
      currentX = stepsX - availableXSpaces
    else
      currentX += stepsX 

    countTrees += encounterTree(forest[y].charAt(currentX))
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
