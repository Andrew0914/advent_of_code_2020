import { findProduct, getProductTrioToSum } from './day1';
import { TreeFinder } from './day3';
import { SeatFinder } from './day5';
//DAY1
console.log('Day 1 | PART 1📝: ', findProduct());
console.log('Day 1 | PART 2📝: ', getProductTrioToSum(2020));
//DAY 3
const FOREST_FILE = './src/forest.txt';
const treeFinder = new TreeFinder(FOREST_FILE);
console.log(
  'Day 3 | PART 1 🌳:',
  treeFinder.howManyTrees({ stepsX: 3, stepsY: 1 })
);
const stepsList = [
  { stepsX: 1, stepsY: 1 },
  { stepsX: 3, stepsY: 1 },
  { stepsX: 5, stepsY: 1 },
  { stepsX: 7, stepsY: 1 },
  { stepsX: 1, stepsY: 2 },
];
console.log(
  'Day 3 | PART 2 🌳:',
  treeFinder.bulkFind(stepsList).reduce((acc, trees) => (acc *= trees))
);
// Day 5
const seatFinder = new SeatFinder('./src/boarding_passes.txt');
console.log('Day 5 | Part 1 💺 highest seat ID', seatFinder.getHighestID());
console.log('Day 5 | Part 2 💺 Finding my seat ID', seatFinder.findMySeat());
