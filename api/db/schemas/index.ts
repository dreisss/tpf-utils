import * as employees from './employees'
import * as products from './products'
import * as stockItems from './stockItems'

const schema = {
  ...employees,
  ...stockItems,
  ...products,
}

export default { ...schema }
