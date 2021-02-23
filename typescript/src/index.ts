import { findProduct, getProductTrioToSum } from './day1';
import { howManyTrees } from './day3';
const FOREST_FILE = './src/forest.txt'
// Results
console.log('Day 1 | PART 1📝: ', findProduct());
console.log('Day 1 | PART 2📝: ', getProductTrioToSum(2020));
console.log('Day 3 | PART 1 🌳:', howManyTrees(FOREST_FILE, { stepsX: 3, stepsY: 1 }));
