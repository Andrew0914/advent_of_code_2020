import { FileReader } from './FileReader';

function countTrees(forest: Array<string>): number {
  let y = 0;
  let x = 0;
  let countTrees = 0;
  while (y < forest.length) {
    x += 3;
    y += 1;
    if (x >= forest[y].length) {
      console.log(x, forest[y].length);
      x = forest[y].length - x;
      y += 1;
    }
    if (forest[y].charAt(x) === '#') console.log({ x, y });
    countTrees += forest[y].charAt(x) === '#' ? 1 : 0;
    if (y >= forest.length - 1) break;
  }
  return countTrees;
}

export function howManyTrees() {
  const reader = new FileReader('./src/forest.txt');

  return countTrees(reader.getLines());
}
