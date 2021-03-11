import { readFileSync } from 'fs';

function getReportEntries(): Array<number> {
  const buffer = readFileSync('./src/assets/expense_report.txt');
  return buffer
    .toString()
    .split('\n')
    .map((value: string) => parseInt(value));
}

export function findProduct(): number {
  let firsFactor = 0;
  let secondFactor = 0;
  const reportEntries = getReportEntries();
  for (let index = 0; index <= reportEntries.length; index++) {
    firsFactor = reportEntries[index];
    secondFactor = 2020 - firsFactor;
    if (reportEntries.find((entrie) => entrie === secondFactor)) break;
  }
  //console.log({ firsFactor, secondFactor });
  return firsFactor * secondFactor;
}

export function getProductTrioToSum(sum: number): number {
  const reportEntries = getReportEntries();
  let trio: Array<number> = [];
  for (let i = 0; i <= reportEntries.length - 2; i++)
    for (let j = 0; j <= reportEntries.length - 1; j++)
      for (let k = 0; k <= reportEntries.length; k++) {
        if (reportEntries[i] + reportEntries[j] + reportEntries[k] === sum){
          trio = [reportEntries[i], reportEntries[j], reportEntries[k]];
        }
          
      }
  return trio.reduce((x, acc) => x * acc);
}
