import { FileReader } from './FileReader';

export class LuggageValidator {
  private plainRules: Array<string>
  public readonly COLORS = {
    SHINY_GOLD: "shiny gold"
  }

  constructor(rulesFilePath: string) {
    this.plainRules = new FileReader(rulesFilePath).getLines(/\.\r\n|\.\n/);
  }

  private getParsedRules(): Array<Array<Array<string>>> {
    return this.plainRules.map(rule => {
      return rule.split("contain")
        .map(rule => rule
          .replace(".", "")
          .trim())
        .map(rule => rule.split(",")
          .map(rule => rule.replace(/\bbag\b|\bbags\b/, "")
            .trim()))
    })

  }

  private mapRuleParts(ruleParts: Array<string>): Map<string, number> {
    const mapRuleParts = new Map<string, number>()
    ruleParts.forEach(part => {
      const key = part.match(/\D+/)
      const count = parseInt(part)
      if (key && key[0].trim() !== "no other")
        mapRuleParts.set(key ? key[0].trim() : "", count)
    })
    return mapRuleParts
  }

  private mapRules(): Map<string, any> {
    const rulesMap = new Map<string, any>()
    this.getParsedRules().forEach(rule => {
      const [ruleKey, ruleParts] = rule
      rulesMap.set(ruleKey[0], this.mapRuleParts(ruleParts))
    })
    return rulesMap
  }

  private areThereBags(rulesMap: Map<string, Map<string, number>>, keys: Array<string>, searchedColor: string): boolean {

    for (let key of keys) {
      if (rulesMap.get(key)?.get(searchedColor)) {
        return true
      }
    }

    if (keys.length > 0) {
      let newKeys = new Array<string>()
      for (let key of keys) {
        const partKeys = rulesMap.get(key)
        newKeys = newKeys.concat(Array.from(partKeys ? partKeys.keys() : []))
      }
      return this.areThereBags(rulesMap, newKeys, searchedColor)
    }

    return false
  }

  public howManyBagsCanContains(color: string): number {
    let count = 0
    const rulesMap = this.mapRules()
    const rulesKeys = Array.from(rulesMap.keys())
    rulesKeys.forEach(ruleKey => {

      count += this.areThereBags(rulesMap, [ruleKey], color) ? 1 : 0
    })
    return count
  }

}